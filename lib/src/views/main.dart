part of todomvc;

/// Main Component.
///
/// Components explanation in "lib/src/views/app.dart" file.
///
/// This application is for demonstration purposes, so it isn't written in
/// a best possible way, like for example in this case I want to demonstrate
/// how to access children Components from the parent.
class Main extends Component {
  List<TodoItem> shownTodos;
  int activeCount;
  TodoModel _model;
  List<VTodoItemView> _todoItems;

  Main(Context context, this.shownTodos, this.activeCount, this._model)
      : super(context);

  void create() {
    element = new Element.tag('section');

    // Here we are assigning id directly, because it will never change
    // in build() method. So it is just a matter of preference
    element.id = 'main';

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
    _model.toggleAll(checked);
    e.stopPropagation();
  }

  /// Togle one item
  void _toggleItem(Event e) {
    final key = _findKey(e.target);
    final checked = (e.target as CheckboxInputElement).checked;
    _model.toggleTodoCompleted(key, checked);
    e.stopPropagation();
  }

  /// Remove item
  void _destroyClick(MouseEvent e) {
    final key = _findKey(e.target);
    _model.removeTodoItem(key);
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
        _model.updateTodoTitle(key, c.editingTitle);
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
        _model.updateTodoTitle(key, c.editingTitle);
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
  VRootElement build() {
    final activeTodoCount = 0;
    final checkBox = new CheckBox(0,
        checked: activeCount == 0,
        attributes: const {'id': 'toggle-all'});

    _todoItems = shownTodos.map((i) => new VTodoItemView(i.id, i)).toList();
    final todoListContainer = vdom.ul(1, _todoItems,
        attributes: const {'id': 'todo-list'});

    return new VRootElement([checkBox, todoListContainer]);
  }

  /// Update properties and update view if it is changed.
  ///
  /// It is not necessary to create such method, it is just a convention.
  ///
  /// This method should be called only from Scheduler:write phase, so we
  /// can check if properties are changed and update view if necessary.
  void updateProperties(List<TodoItem> newShownTodos, int newActiveCount) {
    shownTodos = newShownTodos;
    activeCount = newActiveCount;
    update();
  }
}

class VMain extends VComponentBase<Main, Element> {
  List<TodoItem> shownTodos;
  int activeCount;
  TodoModel model;

  VMain(Object key, this.shownTodos, this.activeCount, this.model) : super(key);

  void create(Context context) {
    component = new Main(context, shownTodos, activeCount, model);
    ref = component.element;
  }

  void update(VMain other, Context context) {
    super.update(other, context);
    component.updateProperties(other.shownTodos, other.activeCount);
  }
}
