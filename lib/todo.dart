class Todo {
  int id;
  String title;
  bool isDone;

  Todo({required this.id, required this.title, this.isDone = false});

  static List<Todo> todoList() {
    return [
      Todo(id: 0, title: 'CS427 Final Project', isDone: true),
      Todo(id: 1, title: 'Orlando flight check-in'),
      Todo(
        id: 2,
        title: 'Find Summer Internship',
      ),
    ];
  }
}
