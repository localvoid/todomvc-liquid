part of todomvc;

/// TodoItemView Component.
///
/// Components explanation in "lib/src/views/app.dart" file.
///
/// It is an example of stateful Component.
class TodoItemView extends VComponent {
  /// Sometimes it useful to access raw DOM, here we are using it
  /// to set focus on it.
  VRef _editField = new VRef<TextInputComponent>();

  // properties
  String _title;
  bool _isCompleted;

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
  TodoItemView(ComponentBase parent, TodoItem item)
      : _title = item.title,
        _isCompleted = item.completed,
        super('li', parent, key: item.id) {
    element.dataset['key'] = key.toString();
  }

  /// Action that changes state, it can be called in any time,
  /// so we should use `invalidate()` method to mark it dirty.
  void startEdit() {
    _isEditing = true;
    _editingTitle = _title;

    // Here is a special case when we need to perform some action
    // after view is rendered. It will be called immediately after
    // read/write phases in UpdateLoop.
    Scheduler.after().then((_) {
      if (isAttached) {
        InputElement e = _editField.get.element;
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
  v.Element build() {
    final checkBox = CheckBoxComponent.virtual(#toggleButton,
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
      final input = TextInputComponent.virtual(#input,
          attributes: const {'class': 'edit'},
          value: _editingTitle,
          ref: _editField);

      children = [view, input];
    } else {
      children = [view];
    }

    final classes = [];
    if (_isEditing) classes.add('editing');
    if (_isCompleted) classes.add('completed');

    return vdom.li(null, children, classes: classes);
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

  /// virtual static function convention explanation in
  /// "lib/src/views/main.dart" file.
  static VDomComponent virtual(Object key, TodoItem item) {
    return new VDomComponent(key, (component, context) {
      if (component == null) {
        return new TodoItemView(context, item);
      }
      component.updateProperties(item);
    });
  }
}
