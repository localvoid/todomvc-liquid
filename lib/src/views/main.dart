part of todomvc;

/// Creates a factory method for [Main] Component Virtual Dom Nodes.
final vMain = v.componentFactory(Main);

/// Main Component.
///
/// Components explanation in "lib/src/views/app.dart" file.
///
/// This application is for demonstration purposes, so it isn't written in
/// the best possible way, like for example in this case I want to show
/// how to access children Components from the parent.
class Main extends Component<Element> {
  @property() List<TodoItem> shownTodos;
  @property() int activeCount;
  @property() TodoModel model;

  List<v.VComponent> _todoItems;

  void create() {
    element = new Element.tag('section');
    // Here we are assigning id directly, because it will never change
    // in build() method. So it is just a matter of preference
    element.id = 'main';
  }

  void init() {
    // Registering event callbacks
    element
      ..onKeyDown.matches('.edit')
        .where((e) => e.keyCode == KeyCode.ENTER ||
                      e.keyCode == KeyCode.ESC)
        .map(_extractKey)
        .listen(_itemKeyDown)

      ..onInput.matches('.edit')
        .map(_extractKey)
        .listen(_itemInput)

      ..onDoubleClick.matches('label')
        .map(_extractKey)
        .listen(_itemStartEdit)

      ..onClick.matches('.destroy')
        .map(_extractKey)
        .listen(_itemRemove);

    element.onChange
      ..matches('.toggle')
        .map(_extractKey)
        .listen(_itemToggle)

      ..matches('#toggle-all')
        .listen(_toggleAll);

    element
      ..onBlur.capture(_handleBlur); // blur doesn't propagate

  }

  /// Extract key value from ancestor
  Tuple2 _extractKey(Event e) =>
      new Tuple2(e, int.parse(closest(e.target, 'li').dataset['key']));

  TodoItemView _findComponentByKey(Object key) {
    return _todoItems.firstWhere((i) => i.key == key).component;
  }

  /// Cancel or update on esc/enter
  void _itemKeyDown(Tuple2<KeyboardEvent, int> data) {
    final event = data.i1;
    final key = data.i2;
    final component = _findComponentByKey(key);
    if (event.keyCode == KeyCode.ENTER){
      model.updateTodoTitle(key, component.editingTitle);
    }
    component.editing = false;
    component.editingTitle = null;
    component.invalidate();
    event.stopPropagation();
  }

  /// Update input
  void _itemInput(Tuple2<KeyboardEvent, int> data) {
    final event = data.i1;
    final key = data.i2;
    final newTitle = (event.target as InputElement).value;
    final component = _findComponentByKey(key);
    component.editingTitle = newTitle;
    event.stopPropagation();
  }

  /// Edit item
  void _itemStartEdit(Tuple2<MouseEvent, int> data) {
    final event = data.i1;
    final key = data.i2;
    final component = _findComponentByKey(key);
    component.editing = true;
    component.editingTitle = component.item.title;
    component.focus();
    component.invalidate();
    event.preventDefault();
    event.stopPropagation();
  }

  /// Remove item
  void _itemRemove(Tuple2<KeyboardEvent, int> data) {
    final event = data.i1;
    final key = data.i2;
    model.removeTodoItem(key);
    event.preventDefault();
    event.stopPropagation();
  }

  /// Togle one item
  void _itemToggle(Tuple2<Event, int> data) {
    final event = data.i1;
    final key = data.i2;
    final checked = (event.target as CheckboxInputElement).checked;
    model.toggleTodoCompleted(key, checked);
    event.stopPropagation();
  }

  /// Toggle all items
  void _toggleAll(Event e) {
    final checked = (e.target as CheckboxInputElement).checked;
    model.toggleAll(checked);
    e.stopPropagation();
  }

  void _handleBlur(FocusEvent e) {
    if ((e.target as Element).matches('.edit')) {
      final key = _extractKey(e).i2;
      final c = _findComponentByKey(key);
      if (c.editing) {
        model.updateTodoTitle(key, c.editingTitle);
        c.editing = false;
        c.editingTitle = null;
        c.invalidate();
      }
      e.stopPropagation();
    }
  }

  /// build method explanation in "lib/src/views/app.dart" file.
  build() {
    _todoItems = shownTodos.map((i) => vTodoItemView(key: i.id, item: i)).toList();

    return v.root()([
        v.checkbox(id: 'toggle-all', checked: activeCount == 0),
        v.ul(id: 'todo-list')(_todoItems)
    ]);
  }
}
