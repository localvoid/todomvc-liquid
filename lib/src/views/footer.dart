part of todomvc;

/// Footer Component
///
/// Components explanation in "lib/src/views/app.dart" file.
class Footer extends VComponent {
  // properties
  int activeCount;
  int completedCount;
  int showItem;
  Function clearCompleted;

  /// Components constructor explanation in "lib/src/views/app.dart" file.
  Footer(Context context, this.activeCount, this.completedCount,
      this.showItem, this.clearCompleted)
      : super('footer', context) {
    element.id = 'footer';

    // Event listener to clear button using Event delegation
    element.onClick.matches('#clear-completed').listen((_) { clearCompleted(); });
  }

  /// build method explanation in "lib/src/views/app.dart" file.
  v.Element build() {
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

    return vdom.footer(0, children);
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

  /// virtual static function convention explanation in
  /// "lib/src/views/main.dart" file.
  static VDomComponent virtual(Object key, int activeCount, int completedCount,
              int showItem, Function clearCompleted) {
    return new VDomComponent(key, (component, context) {
      if (component == null) {
        return new Footer(context, activeCount, completedCount,
            showItem, clearCompleted);
      }
      component.updateProperties(activeCount, completedCount, showItem);
    });
  }
}
