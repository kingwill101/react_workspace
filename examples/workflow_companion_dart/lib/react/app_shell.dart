import 'package:react_core/react.dart';

import '../contexts/tenant_context.dart';
import '../contexts/theme_context.dart';

/// Application provider boundary.
///
/// Keeping providers in their own component means the generated `App` node is
/// mounted below both contexts rather than executing context hooks in the
/// browser entrypoint.
@reactComponent
// ignore: non_constant_identifier_names
ReactNode AppShell(({List<ReactNode> children}) props) =>
    ThemeProvider((children: [TenantProvider((children: props.children))]));
