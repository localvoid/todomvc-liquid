part of todomvc;

/// Top-level Application Component.
///
/// There are two types of Components for now:
/// - [Component] is a pure raw DOM Components
/// - [VComponent] is a Component that use virtual DOM to render its contents
///
/// In this application we will use [VComponent]'s only.
class TodoApp extends VComponent {
  TodoModel _model;

  /// Whenever we create our components, it is necessary to pass
  /// reference to the parent Component.
  ///
  /// It is also quite important to understand our UpdateLoop, for example
  /// Component constructors are always executed in UpdateLoop:write phase,
  /// so we can do any DOM operations here, there is nothing wrong with this.
  /// Except for DOM read operations, reading properly isn't an easy task.
  /// UpdateLoop supports read/write batching.
  TodoApp(Object key, ComponentBase parent, this._model) : super(key, 'div', parent);

  /// When Component is attached to the DOM, we start listening to the events
  /// from data model.
  void attached() {
    super.attached();
    /// Listen to changes from our Data model
    ///
    /// Whenever something is changed, and we aren't in the UpdateLoop:write
    /// phase we don't update view immediately, we are just marking it as
    /// dirty with `invalidate()` method.
    Zone.ROOT.run(() {
      _model.changes.listen((_) => invalidate());
    });
  }

  /// Here we are building virtual DOM, nothing interesting here.
  ///
  /// But it is also important to remember that it is always executed in
  /// UpdateLoop:write phase. So when we create other Components and passing
  /// properties in "Data-Flow" style, we can update this Components
  /// immediately, instead of calling `invalidate()`.
  v.Element build() {
    final shownTodos = _model.items.where((i) {
      switch (_model.showItems) {
        case TodoModel.showActive:
          return !i.completed;
        case TodoModel.showCompleted:
          return i.completed;
        default:
          return true;
      }
    }).toList();

    final activeCount = _model.items.fold(0, (acc, i) {
      return i.completed ? acc : acc + 1;
    });

    final completedCount = _model.items.length - activeCount;

    final children = [component(0, Header.init(_model))];

    if (shownTodos.isNotEmpty) {
      children.add(component(1, Main.init(shownTodos, activeCount, _model)));
    }
    if (activeCount > 0 || completedCount > 0) {
      children.add(component(2, Footer.init(activeCount,
                                            completedCount,
                                            _model.showItems,
                                            _clearCompleted)));
    }

    return vdom.div(0, children);
  }

  /// Callback for clear button in Footer component, passed in data-flow style.
  void _clearCompleted() {
    _model.clearCompleted();
  }
}
