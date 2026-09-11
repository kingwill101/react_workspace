import 'dart:io';
import 'dart:convert';

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

import 'project_config.dart';

/// Locates the analysis configuration owner for a package or workspace member.
Directory analysisRoot(Directory project) {
  final spec = _readMap(File(p.join(project.path, 'pubspec.yaml')));
  if (spec['resolution'] != 'workspace') return project;
  var directory = project.parent;
  while (true) {
    final candidate = File(p.join(directory.path, 'pubspec.yaml'));
    if (candidate.existsSync() && _readMap(candidate)['workspace'] is List) {
      return directory;
    }
    final parent = directory.parent;
    if (parent.path == directory.path) {
      throw const ReactToolException('Workspace member has no workspace root.');
    }
    directory = parent;
  }
}

Map<dynamic, dynamic> _readMap(File file) {
  final value = _readEditor(file).parseAt([]).value;
  if (value is! Map) {
    throw ReactToolException('Expected a YAML mapping in ${file.path}.');
  }
  return value;
}

YamlEditor _readEditor(File file, {String? content, bool allowEmpty = false}) {
  try {
    final editor = YamlEditor(content ?? file.readAsStringSync());
    if (allowEmpty && editor.parseAt([]).value == null) {
      editor.update([], <String, Object>{});
    }
    if (editor.parseAt([]).value is! Map) {
      throw ReactToolException('Expected a YAML mapping in ${file.path}.');
    }
    return editor;
  } on FileSystemException catch (error) {
    throw ReactToolException('Cannot read ${file.path}: ${error.message}');
  } on YamlException catch (error) {
    throw ReactToolException('Invalid YAML in ${file.path}: $error');
  }
}

void _inheritWorkspaceOptions(YamlEditor editor, File member, File root) {
  if (editor.parseAt([]).value == null) editor.update([], <String, Object>{});
  final document = editor.parseAt([]).value;
  if (document is! Map) {
    throw ReactToolException('Expected a YAML mapping in ${member.path}.');
  }
  final value = document['include'];
  if (value != null && value is! String && value is! List) {
    throw ReactToolException(
      'Expected an include path or list in ${member.path}.',
    );
  }
  final includes = value is List ? List<Object?>.of(value) : [?value];
  if (includes.any((entry) => entry is! String)) {
    throw ReactToolException('Expected include paths in ${member.path}.');
  }
  final target = p.normalize(root.absolute.path);
  if (includes.cast<String>().any(
    (entry) =>
        !Uri.parse(entry).hasScheme &&
        p.normalize(p.join(member.parent.absolute.path, entry)) == target,
  )) {
    return;
  }
  final relative = p
      .relative(target, from: member.parent.absolute.path)
      .replaceAll(r'\', '/');
  editor.update([
    'include',
  ], includes.isEmpty ? relative : [...includes, relative]);
}

/// Enables React diagnostics while preserving unrelated YAML and comments.
///
/// Local plugin paths are absolute because the analyzer resolves plugins in a
/// separate package context. Existing plugin settings are left intact.
File enableReactAnalyzer(Directory project, {String? packagesPath}) {
  final root = analysisRoot(project);
  final file = File(p.join(root.path, 'analysis_options.yaml'));
  final memberFile = File(p.join(project.path, 'analysis_options.yaml'));
  YamlEditor? member;
  if (!p.equals(root.absolute.path, project.absolute.path) &&
      memberFile.existsSync()) {
    member = YamlEditor(memberFile.readAsStringSync());
    _inheritWorkspaceOptions(member, memberFile, file);
  }
  final editor = YamlEditor(
    file.existsSync() ? file.readAsStringSync() : '{}\n',
  );
  if (editor.parseAt([]).value == null) editor.update([], <String, Object>{});
  final document = editor.parseAt([]).value;
  if (document is! Map) {
    throw ReactToolException('Expected a YAML mapping in ${file.path}.');
  }
  if (document['plugins'] != null && document['plugins'] is! Map) {
    throw ReactToolException('Expected a plugins mapping in ${file.path}.');
  }
  final plugins = document['plugins'] as Map?;
  final local = packagesPath != null && packagesPath.isNotEmpty;
  if ((plugins?.containsKey('react_analyzer') ?? false) && !local) {
    if (member != null) memberFile.writeAsStringSync(member.toString());
    return file;
  }
  final plugin = <String, Object>{
    'version': '^0.1.0',
    'diagnostics': {
      'invalid_hook_call': 'error',
      'invalid_react_component': 'error',
    },
  };
  final existingPlugin = plugins?['react_analyzer'];
  if (local) {
    final path = p.normalize(p.absolute(packagesPath, 'react_analyzer'));
    if (!File(p.join(path, 'pubspec.yaml')).existsSync()) {
      throw ReactToolException('React analyzer package not found at $path.');
    }
    plugin.remove('version');
    plugin.remove('git');
    plugin.remove('hosted');
    plugin['path'] = path;
    final enginePath = p.normalize(p.absolute(packagesPath, 'react_analysis'));
    if (!File(p.join(enginePath, 'pubspec.yaml')).existsSync()) {
      throw ReactToolException(
        'React analysis package not found at $enginePath.',
      );
    }
    final overrides = plugins?['dependency_overrides'];
    if (overrides != null && overrides is! Map) {
      throw const ReactToolException(
        'Expected plugin dependency_overrides mapping.',
      );
    }
    // An explicit source choice switches both the plugin and its engine.
    if (plugins == null) editor.update(['plugins'], <String, Object>{});
    if (overrides == null) {
      editor.update(['plugins', 'dependency_overrides'], <String, Object>{});
    }
    editor.update(
      ['plugins', 'dependency_overrides', 'react_analysis'],
      {'path': enginePath},
    );
  }
  if (editor.parseAt([]).value['plugins'] == null) {
    editor.update(['plugins'], <String, Object>{});
  }
  if (existingPlugin is Map && local) {
    for (final key in ['version', 'git', 'hosted']) {
      if (existingPlugin.containsKey(key)) {
        editor.remove(['plugins', 'react_analyzer', key]);
      }
    }
    editor.update(['plugins', 'react_analyzer', 'path'], plugin['path']);
  } else {
    editor.update(['plugins', 'react_analyzer'], plugin);
  }
  file.writeAsStringSync(editor.toString());
  if (member != null) memberFile.writeAsStringSync(member.toString());
  return file;
}

/// Registers an application in an existing Dart workspace.
///
/// Shared overrides and plugin declarations move to the workspace root. All
/// conflicts are checked before writing, and relative package paths retain
/// their original meaning after relocation.
///
/// Scaffolds supply [generatedFiles] and [dryRun] to preflight the rendered
/// configuration in memory before creating or overwriting the application.
void registerWorkspaceMember(
  Directory project,
  Directory workspace, {
  Map<String, String>? generatedFiles,
  bool dryRun = false,
}) {
  final memberPath = p.normalize(project.absolute.path);
  final rootPath = p.normalize(workspace.absolute.path);
  if (!p.isWithin(rootPath, memberPath)) {
    throw const ReactToolException(
      'The application must be inside its workspace.',
    );
  }
  final rootSpec = File(p.join(rootPath, 'pubspec.yaml'));
  final memberSpec = File(p.join(memberPath, 'pubspec.yaml'));
  final root = _readEditor(rootSpec);
  final member = _readEditor(
    memberSpec,
    content: generatedFiles?['pubspec.yaml'],
  );
  final rootMap = root.parseAt([]).value as Map;
  final memberMap = member.parseAt([]).value as Map;
  final members = rootMap['workspace'];
  if (members is! List || members.any((entry) => entry is! String)) {
    throw const ReactToolException(
      'Expected a workspace list in the root pubspec.',
    );
  }
  final relative = p.relative(memberPath, from: rootPath).replaceAll(r'\', '/');
  if (!members.contains(relative)) {
    root.update(['workspace'], [...members, relative]);
  }
  member.update(['resolution'], 'workspace');

  Object? canonicalize(Object? value) {
    if (value is Map) {
      final keys = value.keys.cast<String>().toList()..sort();
      return {for (final key in keys) key: canonicalize(value[key])};
    }
    if (value is List) return value.map(canonicalize).toList();
    return value;
  }

  Object? relocate(Object? value, String from) {
    // Only a dependency's top-level path is local to this pubspec. In a Git
    // descriptor, git.path is relative to the remote repository instead.
    if (value is Map && value['path'] is String) {
      return canonicalize({
        ...value,
        'path': p.normalize(p.join(from, value['path'] as String)),
      });
    }
    return canonicalize(value);
  }

  void mergeSection(
    YamlEditor destination,
    Map destinationMap,
    String section,
    Map incoming,
    String incomingRoot, {
    List<String> prefix = const [],
  }) {
    final existing = destinationMap[section];
    if (existing != null && existing is! Map) {
      throw ReactToolException(
        'Expected a $section mapping at the workspace root.',
      );
    }
    if (existing == null) {
      destination.update([...prefix, section], <String, Object>{});
    }
    for (final entry in incoming.entries) {
      if (section == 'plugins' && entry.key == 'dependency_overrides') {
        if (entry.value is! Map) {
          throw const ReactToolException(
            'Expected plugin dependency_overrides mapping.',
          );
        }
        mergeSection(
          destination,
          existing is Map ? existing : {},
          'dependency_overrides',
          entry.value as Map,
          incomingRoot,
          prefix: ['plugins'],
        );
        continue;
      }
      final normalized = relocate(entry.value, incomingRoot);
      if (existing is Map && existing.containsKey(entry.key)) {
        if (jsonEncode(relocate(existing[entry.key], rootPath)) !=
            jsonEncode(normalized)) {
          throw ReactToolException(
            'Conflicting $section entry ${entry.key} at the workspace root.',
          );
        }
      } else {
        destination.update([...prefix, section, entry.key], normalized);
      }
    }
  }

  final overrides = memberMap['dependency_overrides'];
  if (overrides != null) {
    if (overrides is! Map) {
      throw const ReactToolException('Expected dependency_overrides mapping.');
    }
    mergeSection(root, rootMap, 'dependency_overrides', overrides, memberPath);
    member.remove(['dependency_overrides']);
  }
  final memberOptions = File(p.join(memberPath, 'analysis_options.yaml'));
  final rootOptions = File(p.join(rootPath, 'analysis_options.yaml'));
  YamlEditor? memberAnalysis;
  YamlEditor? rootAnalysis;
  if (generatedFiles?.containsKey('analysis_options.yaml') ??
      memberOptions.existsSync()) {
    memberAnalysis = _readEditor(
      memberOptions,
      content: generatedFiles?['analysis_options.yaml'],
      allowEmpty: true,
    );
    final options = memberAnalysis.parseAt([]).value;
    if (options is Map && options['plugins'] != null) {
      final plugins = options['plugins'];
      if (plugins is! Map) {
        throw const ReactToolException('Expected a plugins mapping.');
      }
      rootAnalysis = _readEditor(
        rootOptions,
        content: rootOptions.existsSync() ? null : '{}\n',
        allowEmpty: true,
      );
      if (rootAnalysis.parseAt([]).value == null) {
        rootAnalysis.update([], <String, Object>{});
      }
      final rootOptionsMap = rootAnalysis.parseAt([]).value;
      if (rootOptionsMap is! Map) {
        throw const ReactToolException(
          'Expected root analysis options mapping.',
        );
      }
      mergeSection(
        rootAnalysis,
        rootOptionsMap,
        'plugins',
        plugins,
        memberPath,
      );
      memberAnalysis.remove(['plugins']);
    }
  }
  if (memberAnalysis != null &&
      (rootAnalysis != null || rootOptions.existsSync())) {
    _inheritWorkspaceOptions(memberAnalysis, memberOptions, rootOptions);
  }
  // Write only after all configuration conflicts have been checked.
  if (dryRun) return;
  rootSpec.writeAsStringSync(root.toString());
  memberSpec.writeAsStringSync(member.toString());
  if (rootAnalysis != null) {
    rootOptions.writeAsStringSync(rootAnalysis.toString());
  }
  if (memberAnalysis != null) {
    memberOptions.writeAsStringSync(memberAnalysis.toString());
  }
}
