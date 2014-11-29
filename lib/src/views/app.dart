part of todomvc;

/// Top-level Application Component.
class TodoApp extends Component<DivElement> {
  TodoModel _model;

  /// When we create our Components, we need to pass [context] in which
  /// this [Component] is created. [context] is used to determine its depth
  /// relative to other contexts. To create root-level Component, use `null`
  /// value for the [context].
  ///
  /// Depth is used in our Scheduler to sort write tasks, so that Components
  /// with the lowest depth have higher priority.
  TodoApp(Context context, this._model) : super(context);

  /// This method is invoked when Component is attached to the DOM, so we can start
  /// to listen events from the data model.
  void attached() {
    super.attached();
    /// Listen to changes from the data model
    ///
    /// When model is changed, we are invalidating this component,
    /// and on the next frame Scheduler will update this Component.
    _model.changes.listen((_) => invalidate());
  }

  /// Here we are building virtual DOM, nothing interesting here.
  ///
  /// But it is also important to remember that it is always executed in
  /// Scheduler:write phase. So when we create other Components and passing
  /// properties in "Data-Flow" style, we can update this Components
  /// immediately, instead of calling `invalidate()`.
  ///
  /// Most of the time this isn't important, but it is quite important to know
  /// when you start writing low-level Components.
  VRootElement<DivElement> build() {
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

    final children = [new VHeader(#header, _model)];

    if (shownTodos.isNotEmpty) {
      children.add(new VMain(#main, shownTodos, activeCount, _model));
    }
    if (activeCount > 0 || completedCount > 0) {
      children.add(new VFooter(#footer,
                               activeCount,
                               completedCount,
                               _model.showItems,
                               _clearCompleted));
    }

    return new VRootElement(children);
  }

  /// Callback for clear button in Footer component, passed in data-flow style.
  void _clearCompleted() {
    _model.clearCompleted();
  }
}
