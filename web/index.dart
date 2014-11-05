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

  /// All Components should be children of other Components.
  /// So here are some special Component that can live without any
  /// parents.
  ///
  /// It is always mounted on top of existing HtmlElement. You can mount
  /// any number of root components as you wish.
  final root = new RootComponent.mount(querySelector('#todoapp'));

  /// And now we create our top-level App Component and append it to the
  /// Root Component.
  ///
  /// There is a simple convention that the first parameter is a reference
  /// to the parent Component.
  ///
  /// But you are free to choose whatever you want. It is always possible to
  /// create factories, that will automaticaly inject parents.
  final app = new TodoApp(root, model); // "lib/src/views/app.dart"
  root.append(app);
}
