part of todomvc;

/// Header Component.
///
/// Components explanation in "lib/src/views/app.dart" file.
class Header extends Component {
  @property
  TodoModel model;
  String _input = '';

  /// Components constructor explanation in "lib/src/views/app.dart" file.
  Header(Context context) : super(context);

  void create() {
    element = new Element.tag('header')
      ..onInput.matches('#new-todo').listen(_handleInput)
      ..onKeyDown.matches('#new-todo').listen(_handleKeyDown);
  }

  void _handleKeyDown(KeyboardEvent e) {
    if (e.keyCode == KeyCode.ENTER) {
      final title = _input.trim();
      if (title.isNotEmpty) {
        model.addTodo(title);
      }
      _input = '';
      invalidate();
      e.stopPropagation();
      e.preventDefault();
    }
  }

  void _handleInput(Event e) {
    if ((e.target as Element).matches('#new-todo')) {
      _input = (e.target as InputElement).value;
    }
  }

  /// build method explanation in "lib/src/views/app.dart" file.
  VRoot build() {
    return vRoot()([
        vdom.h1(0)('todos'),
        new TextInput(1,
            value: _input,
            attributes: const {
              'id': 'new-todo',
              'placeholder': 'What needs to be done',
              'autofocus': 'true'
            }
        )
    ]);
  }
}

final vHeader = vComponentFactory(Header);
