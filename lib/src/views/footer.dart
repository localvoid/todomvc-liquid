part of todomvc;

/// Footer Component
///
/// Components explanation in "lib/src/views/app.dart" file.
final vFooter = vComponentFactory(Footer);
class Footer extends Component {
  @property int activeCount;
  @property int completedCount;
  @property int showItem;
  @property Function clearCompleted;

  void create() {
    element = new Element.tag('footer')
      ..id = 'footer';

    // Event listener to clear button using Event delegation
    element.onClick.matches('#clear-completed').listen((_) { clearCompleted(); });
  }

  /// build method explanation in "lib/src/views/app.dart" file.
  VRoot build() {
    final activeTodoWord = 'item';

    final allFilter = vdom.li()(
        vdom.a(attributes: {'href': '#/'},
               classes: showItem == TodoModel.showAll ? ['selected'] : null)('All')
    );

    final activeFilter = vdom.li()(
        vdom.a(attributes: {'href': '#/active'},
               classes: showItem == TodoModel.showActive ? ['selected'] : null)('Active')
    );

    final completedFilter = vdom.li()(
        vdom.a(attributes: {'href': '#/completed'},
               classes: showItem == TodoModel.showCompleted ? ['selected'] : null)('Completed')
    );

    final filters = vdom.ul(key: #filters, attributes: {'id': 'filters'})([
        allFilter,
        vdom.text(' '),
        activeFilter,
        vdom.text(' '),
        completedFilter
    ]);

    final counter = vdom.span(key: #counter, attributes: const {'id': 'todo-count'})([
        vdom.strong()('$activeCount'),
        vdom.text(' ${pluralize(activeCount, 'item')} left')
    ]);

    final children = [counter, filters];
    if (completedCount > 0) {
      children.add(
          vdom.button(key: #clearButton, attributes: const {'id': 'clear-completed'})(
              'Clear completed ($completedCount)'
          )
      );
    }

    return vRoot()(children);
  }
}
