part of todomvc;

/// TodoItemView Component.
///
/// Components explanation in "lib/src/views/app.dart" file.
class TodoItemView extends Component<LIElement> {
  @property
  TodoItem item;

  TextInput _input;

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

  /// Components constructor explanation in "lib/src/views/app.dart" file.
  TodoItemView(Context context) : super(context);

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
  VRoot build() {
    final checkBox = new CheckBox(#toggleButton,
        checked: item.completed,
        attributes: const {'class': 'toggle'});

    final label = vdom.label(#title)(item.title);
    final button = vdom.button(#destroyButton, classes: ['destroy']);

    final view = vdom.div(#view, classes: ['view'])([checkBox, label, button]);

    var children;

    if (_isEditing) {
      _input = new TextInput(#input,
          attributes: const {'class': 'edit'},
          value: _editingTitle);

      children = [view, _input];
    } else {
      children = [view];
    }

    final classes = [];
    if (_isEditing) classes.add('editing');
    if (item.completed) classes.add('completed');

    return vRoot(classes: classes)(children);
  }
}

final vTodoItemView = vComponentFactory(TodoItemView);
