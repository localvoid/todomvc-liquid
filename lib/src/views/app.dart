part of todomvc;

/// Top-level Application Component.
class TodoApp extends Component {
  @property TodoModel model;

  /// This method is invoked when Component is attached to the document,
  /// so we can start to listen events from the data model.
  void attached() {
    super.attached();
    /// Listen to changes from the data model
    ///
    /// When model is changed, we are invalidating this component,
    /// and on the next frame Scheduler will update this Component.
    model.changes.listen((_) => invalidate());
  }

  /// Here we are building virtual DOM to update real DOM.
  build() {
    final shownTodos = model.items.where((i) {
      switch (model.showItems) {
        case TodoModel.showActive:
          return !i.completed;
        case TodoModel.showCompleted:
          return i.completed;
        default:
          return true;
      }
    }).toList();

    final activeCount = model.items.fold(0, (acc, i) {
      return i.completed ? acc : acc + 1;
    });

    final completedCount = model.items.length - activeCount;

    final children = [vHeader(key: #header, model: model)];

    if (shownTodos.isNotEmpty) {
      children.add(vMain(key:         #main,
                         shownTodos:  shownTodos,
                         activeCount: activeCount,
                         model:       model));
    }
    if (activeCount > 0 || completedCount > 0) {
      children.add(vFooter(key:            #footer,
                           activeCount:    activeCount,
                           completedCount: completedCount,
                           showItem:       model.showItems,
                           clearCompleted: _clearCompleted));
    }

    return vRoot()(children);
  }

  /// Callback for clear button in Footer component, passed in data-flow style.
  void _clearCompleted() {
    model.clearCompleted();
  }
}
