part of todomvc;

/// Footer Component
///
/// Components explanation in "lib/src/views/app.dart" file.
final vFooter = v.componentFactory(Footer);
class Footer extends Component {
  @property() int activeCount;
  @property() int completedCount;
  @property() int showItem;
  @property() Function clearCompleted;

  void create() {
    element = new Element.tag('footer')
      ..id = 'footer';
  }

  void init() {
    element.onClick
      .matches('#clear-completed')
      .listen((_) { clearCompleted(); });
  }

  /// build method explanation in "lib/src/views/app.dart" file.
  build() {
    final activeTodoWord = 'item';
    const selected = const ['selected'];

    final filters = v.ul(id: 'filters')([
        v.li()(
          v.link(href: '#/',
             classes: showItem == TodoModel.showAll ? selected : null)('All')),
        v.text(' '),
        v.li()(
          v.link(href: '#/active',
             classes: showItem == TodoModel.showActive ? selected : null)('Active')),
        v.text(' '),
        v.li()(
          v.link(href: '#/completed',
             classes: showItem == TodoModel.showCompleted ? selected : null)('Completed'))
    ]);

    final counter = v.span(id: 'todo-count')([
        v.strong()('$activeCount'),
        v.text(' ${pluralize(activeCount, 'item')} left')
    ]);

    final children = [counter, filters];
    if (completedCount > 0) {
      children.add(
          v.button(id: 'clear-completed')('Clear completed ($completedCount)')
      );
    }

    return v.root()(children);
  }
}
