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
  }

  void init() {
    // Event listener to clear button using Event delegation
    element.onClick.matches('#clear-completed').listen((_) { clearCompleted(); });
  }

  /// build method explanation in "lib/src/views/app.dart" file.
  VRoot build() {
    final activeTodoWord = 'item';
    const selected = const ['selected'];

    final filters = vUl(attributes: {'id': 'filters'})([
        vLi()(
          vA(attributes: {'href': '#/'},
             classes: showItem == TodoModel.showAll ? selected : null)('All')),
        vText(' '),
        vLi()(
          vA(attributes: {'href': '#/active'},
             classes: showItem == TodoModel.showActive ? selected : null)('Active')),
        vText(' '),
        vLi()(
          vA(attributes: {'href': '#/completed'},
             classes: showItem == TodoModel.showCompleted ? selected : null)('Completed'))
    ]);

    final counter = vSpan(id: 'todo-count')([
        vStrong()('$activeCount'),
        vText(' ${pluralize(activeCount, 'item')} left')
    ]);

    final children = [counter, filters];
    if (completedCount > 0) {
      children.add(
          vButton(id: 'clear-completed')('Clear completed ($completedCount)')
      );
    }

    return vRoot()(children);
  }
}
