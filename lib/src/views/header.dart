part of todomvc;

/// Header Component.
///
/// Components explanation in "lib/src/views/app.dart" file.
final vHeader = v.componentFactory(Header);
class Header extends Component {
  @property TodoModel model;

  String _input = '';

  void create() { element = new Element.tag('header'); }

  void init() {
    element
      ..onKeyDown
        .matches('#new-todo')
        .where((e) => e.keyCode == KeyCode.ENTER)
        .listen(_submit)

      ..onInput
        .matches('#new-todo')
        .listen(_updateInput);
  }

  void _submit(KeyboardEvent e) {
    final title = _input.trim();
    if (title.isNotEmpty) {
      model.addTodo(title);
    }
    _input = '';
    invalidate();
    e.stopPropagation();
    e.preventDefault();
  }

  void _updateInput(Event e) {
    _input = (e.target as InputElement).value;
  }

  /// build method explanation in "lib/src/views/app.dart" file.
  build() =>
    v.root()([
        v.h1()('todos'),
        v.textInput(
            id: 'new-todo',
            value: _input,
            attributes: const {
              'placeholder': 'What needs to be done',
              'autofocus': 'true'
            }
        )
    ]);
}
