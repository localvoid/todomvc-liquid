part of todomvc;

/// Header Component.
///
/// Components explanation in "lib/src/views/app.dart" file.
class Header extends VComponent {
  final TodoModel _model;
  String _input = '';

  /// Components constructor explanation in "lib/src/views/app.dart" file.
  Header(ComponentBase parent, this._model)
      : super('header', parent) {

    Zone.ROOT.run(() {
      element
         ..onInput.matches('#new-todo').listen(_handleInput)
         ..onKeyDown.matches('#new-todo').listen(_handleKeyDown);
    });
  }

  void _handleKeyDown(KeyboardEvent e) {
    if (e.keyCode == KeyCode.ENTER) {
      final title = _input.trim();
      if (title.isNotEmpty) {
        _model.addTodo(title);
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
  v.Element build() {
    return vdom.header(0, [vdom.h1(0, [vdom.t('todos')]),
            TextInputComponent.virtual(1,
              value: _input,
              attributes: const {
              'id': 'new-todo',
              'placeholder': 'What needs to be done',
              'autofocus': 'true'
            })]);
  }

  /// virtual static function convention explanation in
  /// "lib/src/views/main.dart" file.
  static VDomComponent virtual(Object key, TodoModel model) {
    return new VDomComponent(key, (component, context) {
      if (component == null) {
        return new Header(context, model);
      }
    });
  }
}
