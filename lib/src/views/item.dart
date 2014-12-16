part of todomvc;

/// TodoItemView Component.
///
/// Components explanation in "lib/src/views/app.dart" file.
final vTodoItemView = v.componentFactory(TodoItemView);
class TodoItemView extends Component {
  @property() TodoItem item;

  bool editing = false;
  String editingTitle;

  v.VTextInput _input;

  void create() {
    element = new LIElement()
      ..dataset['key'] = item.id.toString();
  }

  void focus() {
    // Here is a special case when we need to perform some action
    // after view is rendered. It will be called immediately after
    // read/write phases in domScheduler.
    domScheduler.nextFrame.after().then((_) {
      if (_input != null && isAttached) {
        final InputElement e = _input.ref;
        final length = editingTitle.length;
        e.focus();
        e.setSelectionRange(length, length);
      }
    });
  }

  /// build method explanation in "lib/src/views/app.dart" file.
  build() {
    final view = v.div(classes: ['view'])([
        v.checkbox(
          checked: item.completed,
          classes: ['toggle']),
        v.label()(item.title),
        v.button(classes: ['destroy'])
    ]);

    var children = [view];
    if (editing) {
      _input = v.textInput(
          attributes: {'class': 'edit'},
          value: editingTitle);

      children.add(_input);
    } else {
      _input = null;
    }

    final classes = [];
    if (editing) classes.add('editing');
    if (item.completed) classes.add('completed');

    return v.root(classes: classes)(children);
  }
}
