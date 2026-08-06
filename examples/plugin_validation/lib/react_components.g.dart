// GENERATED CODE — DO NOT EDIT

import 'package:plugin_validation/hook_errors.react.g.dart' as hookInConditional;
import 'package:plugin_validation/hook_errors.react.g.dart' as hookInLoop;
import 'package:plugin_validation/hook_errors.react.g.dart' as hookAfterReturn;
import 'package:plugin_validation/hook_errors.react.g.dart' as hookCorrect;
import 'package:plugin_validation/ssr_errors.react.g.dart' as ssrBadRead;
import 'package:plugin_validation/ssr_errors.react.g.dart' as ssrGoodRead;
import 'package:plugin_validation/ssr_errors.react.g.dart' as ssrClientOnly;
import 'package:plugin_validation/ssr_errors.react.g.dart' as ssrDocumentRead;
import 'package:plugin_validation/valid_component.react.g.dart' as greeting;
import 'package:plugin_validation/valid_component.react.g.dart' as card;

/// Registers all generated React components.
void registerReactComponents() {
  hookInConditional.registerHookInConditional();
  hookInLoop.registerHookInLoop();
  hookAfterReturn.registerHookAfterReturn();
  hookCorrect.registerHookCorrect();
  ssrBadRead.registerSsrBadRead();
  ssrGoodRead.registerSsrGoodRead();
  ssrClientOnly.registerSsrClientOnly();
  ssrDocumentRead.registerSsrDocumentRead();
  greeting.registerGreeting();
  card.registerCard();
}
