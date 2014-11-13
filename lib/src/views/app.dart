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

  /// Whenever we create our Components, we need to pass unique [key] and
  /// [context] in which this [Component] is created. [context] is used to
  /// determine its depth relative to other contexts.
  ///
  /// Depth is used in our Scheduler to sort write tasks, so that Components
  /// with the lowest depth have higher priority.
  ///
  /// It is important to understand how Scheduler works, for example
  /// Component constructors are always executed in Scheduler:write phase,
  /// so we can do any DOM write operations here, there is nothing wrong with
  /// this. Except for DOM read operations, to read from the DOM, we need to
  /// use `readDOM()` method that returns Future, and this Future will be
  /// completed when Scheduler:read phase starts.
  TodoApp(Object key, Context context, this._model) : super(key, 'div', context);

  /// This method is invoked when Component is attached to the DOM, so we can start
  /// to listening for the events from data model.
  void attached() {
    super.attached();
    /// Listen to changes from our Data model
    ///
    /// `attached` method is executed in the Scheduler zone, so if we want to
    /// execute something outside of the Scheduler zone, like in this example,
    /// we need to run it in different zone, for example in the ROOT zone.
    ///
    /// In this case, when model is changed, we are invalidating this component,
    /// and on the next frame Scheduler will update this Component.
    Zone.ROOT.run(() {
      _model.changes.listen((_) => invalidate());
    });
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

    final children = [Header.virtual(#header, _model)];

    if (shownTodos.isNotEmpty) {
      children.add(Main.virtual(#main, shownTodos, activeCount, _model));
    }
    if (activeCount > 0 || completedCount > 0) {
      children.add(Footer.virtual(#footer,
                                  activeCount,
                                  completedCount,
                                  _model.showItems,
                                  _clearCompleted));
    }

    return vdom.div(0, children);
  }

  /// Callback for clear button in Footer component, passed in data-flow style.
  void _clearCompleted() {
    _model.clearCompleted();
  }
}
