import 'dart:html';
import 'package:route_hierarchical/client.dart';
import 'package:liquid/liquid.dart';
import 'package:todomvc_liquid/todomvc.dart';

/// Initialize router rules. Nothing special, we are using
/// `route_hierarchical` package here.
void initRouter(TodoModel model) {
  final router = new Router(useFragment: true);
  router.root
    ..addRoute(name: 'showCompleted', path: '/completed',
        enter: (_) { model.show(TodoModel.showCompleted); })
    ..addRoute(name: 'showActive', path: '/active',
        enter: (_) { model.show(TodoModel.showActive); })
    ..addRoute(name: 'showAll', path: '/', defaultRoute: true,
        enter: (_) { model.show(TodoModel.showAll); });
  router.listen();
}

void main() {
  /// Creating app state, flux, whatever...
  final model = new TodoModel(); // "lib/src/model.dart"
  initRouter(model);

  final app = new TodoApp()..model = model; // "lib/src/views/app.dart"
  injectComponent(app, querySelector('#todoapp'));
}
