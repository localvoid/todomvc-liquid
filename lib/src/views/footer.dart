part of todomvc;

/// Footer Component
///
/// Components explanation in "lib/src/views/app.dart" file.
class Footer extends Component {
  // properties
  int activeCount;
  int completedCount;
  int showItem;
  Function clearCompleted;

  /// Components constructor explanation in "lib/src/views/app.dart" file.
  Footer(Context context, this.activeCount, this.completedCount,
      this.showItem, this.clearCompleted)
      : super(context);

  void create() {
    element = new Element.tag('footer')
      ..id = 'footer';

    // Event listener to clear button using Event delegation
    element.onClick.matches('#clear-completed').listen((_) { clearCompleted(); });
  }

  /// build method explanation in "lib/src/views/app.dart" file.
  VRootElement build() {
    final activeTodoWord = 'item';

    final counter = vdom.span(#counter,
        [vdom.strong(0, [vdom.t('$activeCount')]),
         vdom.text(1, ' ${pluralize(activeCount, 'item')} left')],
         attributes: const {'id': 'todo-count'});

    final allFilter = vdom.li(#allFilter, [vdom.a(0, [vdom.t('All')],
        attributes: {'href': '#/'},
        classes: showItem == TodoModel.showAll ? ['selected'] : null)]);
    final activeFilter = vdom.li(#activeFilter, [vdom.a(0, [vdom.t('Active')],
        attributes: {'href': '#/active'},
        classes: showItem == TodoModel.showActive ? ['selected'] : null)]);
    final completedFilter = vdom.li(#completedFilter, [vdom.a(0, [vdom.t('Completed')],
        attributes: {'href': '#/completed'},
        classes: showItem == TodoModel.showCompleted ? ['selected'] : null)]);

    final filters = vdom.ul(#filters,
        [allFilter,
         vdom.text(0, ' '),
         activeFilter,
         vdom.text(1, ' '),
         completedFilter],
        attributes: {'id': 'filters'});

    final children = [counter, filters];
    if (completedCount > 0) {
      children.add(vdom.button(#clearButton,
          [vdom.t('Clear completed ($completedCount)')],
          attributes: const {'id': 'clear-completed'}));
    }

    return new VRootElement(children);
  }

  /// updateProperties method convention explanation in
  /// "lib/src/views/main.dart" file.
  void updateProperties(int newActiveCount, int newCompletedCount, int newShowItem) {
    if (activeCount == newActiveCount &&
        completedCount == newCompletedCount &&
        showItem == newShowItem) {
      return;
    }
    activeCount = newActiveCount;
    completedCount = newCompletedCount;
    showItem = newShowItem;
    update();
  }
}

class VFooter extends VComponentBase<Footer, Element> {
  int activeCount;
  int completedCount;
  int showItem;
  Function clearCompleted;

  VFooter(Object key, this.activeCount, this.completedCount,
      this.showItem, this.clearCompleted) : super(key);

  void create(Context context) {
    component = new Footer(context, activeCount, completedCount,
        showItem, clearCompleted);
    ref = component.element;
  }

  void update(VFooter other, Context context) {
    super.update(other, context);
    component.updateProperties(other.activeCount,
        other.completedCount,
        other.showItem);
  }
}
