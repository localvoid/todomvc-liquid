part of todomvc;

/// Creates a factory method for [Main] Component Virtual Dom Nodes
final vMain = vComponentFactory(Main);

/// Main Component.
///
/// Components explanation in "lib/src/views/app.dart" file.
///
/// This application is for demonstration purposes, so it isn't written in
/// a best possible way, like for example in this case I want to demonstrate
/// how to access children Components from the parent.
class Main extends Component {
  @property List<TodoItem> shownTodos;
  @property int activeCount;
  @property TodoModel model;

  List<VComponent> _todoItems;

  void create() {
    element = new Element.tag('section');
    // Here we are assigning id directly, because it will never change
    // in build() method. So it is just a matter of preference
    element.id = 'main';
  }

  void init() {
    // Registering event callbacks
    element
        ..onKeyDown.matches('.edit').listen(_editKeyDown)
        ..onInput.matches('.edit').listen(_editInput)
        ..onDoubleClick.matches('label').listen(_labelDoubleClick)
        ..onClick.matches('.destroy').listen(_destroyClick)
        ..onBlur.capture(_handleBlur); // blur doesn't propagate

    element.onChange
        ..matches('.toggle').listen(_toggleItem)
        ..matches('#toggle-all').listen(_toggleAll);
  }

  TodoItemView findByKey(Object key) {
    return _todoItems.firstWhere((i) => i.key == key).component;
  }

  /// Find key value from one of its children elements
  int _findKey(Element e) {
    // `closest(element, selector)` is a simple helper, that will
    // search for ancestor that matches this selector.
    final itemElement = closest(e, 'li');
    final key = int.parse(itemElement.dataset['key']);
    return key;
  }

  /// Toggle all items
  void _toggleAll(Event e) {
    final checked = (e.target as CheckboxInputElement).checked;
    model.toggleAll(checked);
    e.stopPropagation();
  }

  /// Togle one item
  void _toggleItem(Event e) {
    final key = _findKey(e.target);
    final checked = (e.target as CheckboxInputElement).checked;
    model.toggleTodoCompleted(key, checked);
    e.stopPropagation();
  }

  /// Remove item
  void _destroyClick(MouseEvent e) {
    final key = _findKey(e.target);
    model.removeTodoItem(key);
    e.preventDefault();
    e.stopPropagation();
  }

  void _handleBlur(FocusEvent e) {
    if ((e.target as Element).matches('.edit')) {
      final key = _findKey(e.target);

      // Here we are using `findByKey` method that will return child component
      // with this key.
      //
      // It is useful when Components are stateful, like in this example.
      final c = findByKey(key);
      if (c.isEditing) {
        model.updateTodoTitle(key, c.editingTitle);
        c.stopEdit();
      }
      e.stopPropagation();
    }
  }

  /// Cancel or update on esc/enter
  void _editKeyDown(KeyboardEvent e) {
    if (e.keyCode == KeyCode.ENTER || e.keyCode == KeyCode.ESC) {
      final key = _findKey(e.target);
      final c = findByKey(key);
      if (e.keyCode == KeyCode.ENTER){
        model.updateTodoTitle(key, c.editingTitle);
      }
      c.stopEdit();
      e.stopPropagation();
    }
  }

  /// Update input
  void _editInput(Event e) {
    final key = _findKey(e.target);
    final newTitle = (e.target as InputElement).value;
    final c = findByKey(key);
    c.editingTitle = newTitle;
    e.stopPropagation();
  }

  /// Edit item
  void _labelDoubleClick(MouseEvent e) {
    final key = _findKey(e.target);
    final c = findByKey(key);
    c.startEdit();
    e.preventDefault();
    e.stopPropagation();
  }

  /// build method explanation in "lib/src/views/app.dart" file.
  VRoot build() {
    final checkBox = vCheckbox(
        checked: activeCount == 0,
        attributes: const {'id': 'toggle-all'});

    _todoItems = shownTodos.map((i) => vTodoItemView(key: i.id, item: i)).toList();
    final todoListContainer = vUl(id: 'todo-list')(_todoItems);

    return vRoot()([checkBox, todoListContainer]);
  }
}
