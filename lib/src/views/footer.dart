part of todomvc;

/// Footer Component
///
/// Components explanation in "lib/src/views/app.dart" file.
class Footer extends Component {
  @property
  int activeCount;

  @property
  int completedCount;

  @property
  int showItem;

  @property
  Function clearCompleted;

  /// Components constructor explanation in "lib/src/views/app.dart" file.
  Footer(Context context) : super(context);

  void create() {
    element = new Element.tag('footer')
      ..id = 'footer';

    // Event listener to clear button using Event delegation
    element.onClick.matches('#clear-completed').listen((_) { clearCompleted(); });
  }

  /// build method explanation in "lib/src/views/app.dart" file.
  VRoot build() {
    final activeTodoWord = 'item';

    final counter = vdom.span(#counter, attributes: const {'id': 'todo-count'})([
        vdom.strong(0)('$activeCount'),
        vdom.text(1, ' ${pluralize(activeCount, 'item')} left')
    ]);

    final allFilter = vdom.li(#allFilter)(
        vdom.a(null,
            attributes: {'href': '#/'},
            classes: showItem == TodoModel.showAll ? ['selected'] : null)('All')
    );

    final activeFilter = vdom.li(#activeFilter)(
        vdom.a(null,
            attributes: {'href': '#/active'},
            classes: showItem == TodoModel.showActive ? ['selected'] : null)('Active')
    );

    final completedFilter = vdom.li(#completedFilter)(
        vdom.a(null,
            attributes: {'href': '#/completed'},
            classes: showItem == TodoModel.showCompleted ? ['selected'] : null)('Completed')
    );

    final filters = vdom.ul(#filters, attributes: {'id': 'filters'})([
        allFilter,
        vdom.text(0, ' '),
        activeFilter,
        vdom.text(1, ' '),
        completedFilter
    ]);

    final children = [counter, filters];
    if (completedCount > 0) {
      children.add(
          vdom.button(#clearButton, attributes: const {'id': 'clear-completed'})(
              'Clear completed ($completedCount)'
          )
      );
    }

    return vRoot()(children);
  }
}

final vFooter = vComponentFactory(Footer);
