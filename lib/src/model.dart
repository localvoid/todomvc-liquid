part of todomvc;

/// Just a todo item. Nothing special.
class TodoItem {
  /// Unique counter for children reconciliation.
  ///
  /// Just read [this React article](http://facebook.github.io/react/docs/reconciliation.html)
  /// if you are not familiar with this idea. It is really the most awesome
  /// part of React innovation. Everything else is nothing compared to
  /// this :)
  static int __nextId = 0;

  final id;
  String title;
  bool completed;

  TodoItem(this.title, [this.completed = false]) : id = __nextId++;

  void toggle() {
    completed = !completed;
  }
}

/// This is our poor man's "Flux" architecture :) Just mixed in one object
/// for simplicity.
///
/// Application state:
/// - [items] list of todo items
/// - [showItems] which items to display ([showAll], [showActive]
/// or [showCompleted])
///
/// To listen when the application state is changes, we are using [changes]
/// stream.
///
/// Everyting else is our "Flux" actions.
class TodoModel {
  static const int showAll = 0;
  static const int showActive = 1;
  static const int showCompleted = 2;

  final List<TodoItem> items = new List<TodoItem>();
  int showItems = showAll;

  bool _notifying = false;
  final StreamController _changesController = new StreamController.broadcast();
  Stream get changes => _changesController.stream;

  /// Change state of [showItems]
  void show(int newValue) {
    if (showItems != newValue) {
      showItems = newValue;
      _notify();
    }
  }

  /// Add new Todo Item
  void addTodo(String title) {
    if (title.trim().isNotEmpty) {
      items.add(new TodoItem(title));
      _notify();
    }
  }

  /// Update title of Todo item
  void updateTodoTitle(int id, String newTitle) {
    if (newTitle.trim().isEmpty) {
      removeTodoItem(id);
    } else {
      final item = items.firstWhere((i) => i.id == id);
      item.title = newTitle;
      _notify();
    }
  }

  /// Remove Todo item
  void removeTodoItem(int id) {
    for (var i = 0; i < items.length; i++) {
      if (items[i].id == id) {
        items.removeAt(i);
        break;
      }
    }
    _notify();
  }

  /// Toggle completed flag of Todo item
  void toggleTodoCompleted(int id, bool checked) {
    final item = items.firstWhere((i) => i.id == id);
    item.completed = checked;
    _notify();
  }

  /// Toggle completed flag for all Todo items
  void toggleAll(bool checked) {
    for (final i in items) {
      i.completed = checked;
    }
    _notify();
  }

  /// Remove all Todo items this has completed status
  void clearCompleted() {
    items.removeWhere((i) => i.completed);
    _notify();
  }

  /// Simple optimization to prevent sending multiple events
  void _notify() {
    if (_changesController.hasListener) {
      if (!_notifying) {
        _notifying = true;
        scheduleMicrotask(_notifyFinish);
      }
    }
  }

  void _notifyFinish() {
    _notifying = false;
    _changesController.add(null);
  }
}