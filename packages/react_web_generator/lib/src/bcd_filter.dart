import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;

/// Filters Web IDL definitions to match the same subset that
/// `package:web` targets (standard-track, non-experimental APIs).
///
/// Uses the `@mdn/browser-compat-data` pinned in the `dart-lang/web`
/// submodule at `third_party/web`. The upstream `web_generator` applies
/// the same BCD gate when `generateAll` is false.
///
/// See: https://github.com/dart-lang/web/tree/web-v1.1.1/web_generator
class BcdFilter {
  final Map<String, dynamic> _bcd;
  final Set<String> _includedInterfaces = {};
  final Set<String> _bcdInterfaceNames = {};
  final Map<String, Set<String>> _includedMembers = {};

  BcdFilter._(this._bcd);

  static BcdFilter load({String submodulePath = 'third_party/web'}) {
    final bcdPath = p.join(
      submodulePath,
      'web_generator',
      'lib',
      'src',
      'node_modules',
      '@mdn',
      'browser-compat-data',
      'data.json',
    );
    if (!File(bcdPath).existsSync()) {
      throw StateError('BCD data not found at $bcdPath. '
          'Ensure the submodule is initialized.');
    }
    final data = jsonDecode(File(bcdPath).readAsStringSync()) as Map<String, dynamic>;
    final filter = BcdFilter._(data);
    filter._buildCache();
    return filter;
  }

  void _buildCache() {
    final api = _bcd['api'] as Map<String, dynamic>? ?? {};
    for (final entry in api.entries) {
      final name = entry.key;
      _bcdInterfaceNames.add(name);
      final info = entry.value as Map<String, dynamic>? ?? {};
      final compat = info['__compat'] as Map<String, dynamic>? ?? {};
      final status = compat['status'] as Map<String, dynamic>? ?? {};
      final standardTrack = status['standard_track'] as bool? ?? false;
      final experimental = status['experimental'] as bool? ?? false;
      if (standardTrack && !experimental) {
        _includedInterfaces.add(name);
        _cacheMembers(name, info);
      }
    }
  }

  void _cacheMembers(String interfaceName, Map<String, dynamic> info) {
    final members = <String>{};
    for (final entry in info.entries) {
      final key = entry.key;
      if (key.startsWith('_')) continue;
      final val = entry.value as Map<String, dynamic>? ?? {};
      final compat = val['__compat'] as Map<String, dynamic>? ?? {};
      final status = compat['status'] as Map<String, dynamic>? ?? {};
      final standardTrack = status['standard_track'] as bool? ?? false;
      final experimental = status['experimental'] as bool? ?? false;
      if (standardTrack && !experimental) {
        // BCD stores event handlers as `eventName_event`; IDL uses `onEventName`
        String idlName;
        if (key.endsWith('_event')) {
          idlName = 'on${key.substring(0, key.length - '_event'.length)}';
        } else {
          idlName = key;
        }
        members.add(idlName);
      }
    }
    if (members.isNotEmpty) {
      _includedMembers[interfaceName] = members;
    }
  }

  /// Whether the interface with [name] should be generated.
  bool shouldGenerateInterface(String name) => _includedInterfaces.contains(name);

  /// Whether [name] is an interface that was excluded by BCD filtering
  /// (i.e. it appears in the BCD `api` section but does not pass the
  /// `standardTrack && !experimental` gate).
  bool isFilteredOutInterface(String name) =>
      _bcdInterfaceNames.contains(name) && !_includedInterfaces.contains(name);

  /// Whether the member [name] on [interfaceName] should be generated.
  ///
  /// Returns `true` for event handlers whose compat data is on the
  /// bubbling target (e.g. `click` on `Element` is stored as
  /// `click_event` on `Element` but also bubbles to `Window`/`Document`).
  bool shouldGenerateMember(String interfaceName, String memberName) {
    final interfaceMembers = _includedMembers[interfaceName];
    if (interfaceMembers != null && interfaceMembers.contains(memberName)) {
      return true;
    }
    // Event handler fallback: if the member is an `onX` handler and
    // the underlying event (`X_event`) is supported on any generated
    // interface, assume it can bubble up.
    // BCD stores `click_event` but _cacheMembers normalizes to `onclick`,
    // so we check both forms.
    if (memberName.startsWith('on') && memberName.length > 2) {
      final eventName = '${memberName.substring(2)}_event';
      for (final entry in _includedMembers.entries) {
        if (entry.value.contains(memberName) || entry.value.contains(eventName)) return true;
      }
    }
    return false;
  }
}