import 'package:react_web/react_web.dart';

import '../styles/todo.module.dart';
import 'todos_contract.dart' show TodoItem;
import 'todos_actions.client.g.dart' show listTodosAction, toggleTodoAction;

@reactComponent
ReactNode TodoApp(({String title}) props) {
  final (todos, setTodos) = useState(<TodoItem>[]);
  final (loading, setLoading) = useState(true);
  final (error, setError) = useState<String?>(null);

  // Load initial data on mount
  useEffect(() {
    listTodosAction(completedFilter: null)
        .then((result) {
          setTodos(result.items);
          setLoading(false);
        })
        .catchError((e) {
          setError(e.toString());
          setLoading(false);
        });
  }, []);

  Future<void> handleToggle(TodoItem item) async {
    try {
      final result = await toggleTodoAction(
        todoId: item.id,
        completed: !item.completed,
      );
      setTodos(todos.map((t) => t.id == item.id ? result : t).toList());
    } catch (e) {
      setError(e.toString());
    }
  }

  if (loading) {
    return section(
      className: TodoModuleStyles.panel,
      children: [
        div(
          key: 'loading',
          className: TodoModuleStyles.loading,
          children: [const Text('Loading tasks…')],
        ),
      ],
    );
  }

  if (error != null) {
    return section(
      className: TodoModuleStyles.panel,
      children: [
        div(
          key: 'error',
          className: TodoModuleStyles.error,
          children: [Text('Error: $error')],
        ),
      ],
    );
  }

  return section(
    className: TodoModuleStyles.panel,
    children: [
      div(
        key: 'header',
        className: TodoModuleStyles.panelHeader,
        children: [
          div(
            key: 'heading',
            children: [
              div(
                key: 'kicker',
                className: TodoModuleStyles.kicker,
                children: [const Text('SERVER ACTIONS')],
              ),
              h2(key: 'title', children: [Text(props.title)]),
            ],
          ),
          span(
            key: 'count',
            className: TodoModuleStyles.count,
            children: [Text('${todos.length} open')],
          ),
        ],
      ),
      div(
        key: 'list',
        className: TodoModuleStyles.list,
        children: [
          ...todos.map(
            (t) => label(
              key: t.id,
              className: TodoModuleStyles.row,
              children: [
                input(
                  key: 'checkbox',
                  type: 'checkbox',
                  checked: t.completed,
                  onChange: (_) => handleToggle(t),
                ),
                span(
                  key: 'todo-title',
                  className: t.completed
                      ? TodoModuleStyles.completedTitle
                      : TodoModuleStyles.title,
                  children: [Text(t.title)],
                ),
                span(
                  key: 'todo-state',
                  className: TodoModuleStyles.state,
                  children: [Text(t.completed ? 'DONE' : 'TODO')],
                ),
              ],
            ),
          ),
        ],
      ),
      div(
        key: 'footer',
        className: TodoModuleStyles.footer,
        children: [
          span(
            key: 'transport',
            children: [const Text('Changes are persisted by a typed RPC')],
          ),
          span(
            key: 'pulse',
            className: TodoModuleStyles.pulse,
            children: [const Text('●')],
          ),
        ],
      ),
    ],
  );
}
