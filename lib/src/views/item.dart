part of todomvc;

/// TodoItemView Component.
///
/// Components explanation in "lib/src/views/app.dart" file.
final vTodoItemView = v.componentFactory(TodoItemView);
class TodoItemView extends Component<LIElement> {
  @property TodoItem item;

  v.VTextInput _input;

  // state
  bool _isEditing = false;
  bool get isEditing => _isEditing;

  String _editingTitle = null;
  String get editingTitle => _editingTitle;
  set editingTitle(String newValue) {
    if (_editingTitle != newValue) {
      _editingTitle = newValue;
      invalidate();
    }
  }

  void create() {
    element = new LIElement()
      ..dataset['key'] = item.id.toString();
  }

  /// Action that changes state, it is called outside of Scheduler execution
  /// context, so we should use `invalidate()` method to mark it dirty.
  void startEdit() {
    _isEditing = true;
    _editingTitle = item.title;

    // Here is a special case when we need to perform some action
    // after view is rendered. It will be called immediately after
    // read/write phases in UpdateLoop.
    domScheduler.nextFrame.after().then((_) {
      if (isAttached) {
        final InputElement e = _input.ref;
        final length = item.title.length;
        e.focus();
        e.setSelectionRange(length, length);
      }
    });
    invalidate();
  }

  /// Same as `startEdit()`
  void stopEdit() {
    _isEditing = false;
    _editingTitle = null;
    invalidate();
  }

  /// build method explanation in "lib/src/views/app.dart" file.
  build() {
    final checkBox = v.checkbox(
        checked: item.completed,
        attributes: const {'class': 'toggle'});

    final label = v.label()(item.title);
    final button = v.button(classes: ['destroy']);

    final view = v.div(classes: ['view'])([checkBox, label, button]);

    var children;

    if (_isEditing) {
      _input = v.textInput(
          attributes: const {'class': 'edit'},
          value: _editingTitle);

      children = [view, _input];
    } else {
      children = [view];
    }

    final classes = [];
    if (_isEditing) classes.add('editing');
    if (item.completed) classes.add('completed');

    return v.root(classes: classes)(children);
  }
}
