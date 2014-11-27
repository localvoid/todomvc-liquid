part of todomvc;

/// TodoItemView Component.
///
/// Components explanation in "lib/src/views/app.dart" file.
class TodoItemView extends Component<LIElement> {
  // properties
  String _title;
  bool _isCompleted;

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
  TodoItemView(Context context, TodoItem item)
      : _title = item.title,
        _isCompleted = item.completed,
        super(new LIElement(), context) {
    element.dataset['key'] = item.id.toString();
  }

  /// Action that changes state, it is called outside of Scheduler execution
  /// context, so we should use `invalidate()` method to mark it dirty.
  void startEdit() {
    _isEditing = true;
    _editingTitle = _title;

    // Here is a special case when we need to perform some action
    // after view is rendered. It will be called immediately after
    // read/write phases in UpdateLoop.
    domScheduler.nextFrame.after().then((_) {
      if (isAttached) {
        final InputElement e = _input.ref;
        final length = _title.length;
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
  VRootElement build() {
    final checkBox = new CheckBox(#toggleButton,
        checked: _isCompleted,
        attributes: const {'class': 'toggle'});

    final label = vdom.label(#title, [vdom.t(_title)]);
    final button = vdom.button(#destroyButton, const [], classes: ['destroy']);

    final view = vdom.div(#view, [checkBox, label, button], classes: ['view']);

    var children;

    if (_isEditing) {
      // Here we are using Component that supports passing VRefs to virtual
      // constructors, so it will assign real dom element to it when it is
      // constructed.
      _input = new TextInput(#input,
          attributes: const {'class': 'edit'},
          value: _editingTitle);

      children = [view, _input];
    } else {
      children = [view];
    }

    final classes = [];
    if (_isEditing) classes.add('editing');
    if (_isCompleted) classes.add('completed');

    return new VRootElement(children, classes: classes);
  }

  /// updateProperties method convention explanation in
  /// "lib/src/views/main.dart" file.
  void updateProperties(TodoItem item) {
    if (_title == item.title &&
        _isCompleted == item.completed) {
      return;
    }

    _title = item.title;
    _isCompleted = item.completed;
    update();
  }
}

class VTodoItemView extends VComponentBase<TodoItemView, LIElement> {
  TodoItem item;

  VTodoItemView(Object key, this.item) : super(key);

  void create(Context context) {
    component = new TodoItemView(context, item);
    ref = component.element;
  }

  void update(VTodoItemView other, Context context) {
    super.update(other, context);
    component.updateProperties(other.item);
  }
}
