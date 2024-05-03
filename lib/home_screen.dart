import 'package:flutter/material.dart';
import 'todo.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final listKey = GlobalKey<AnimatedListState>();
  final todoList = Todo.todoList();
  final todoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(222, 76, 63, 1),
          title: const Text('Todo App', style: TextStyle(color: Colors.white)),
        ),
        backgroundColor: const Color.fromRGBO(45, 45, 60, 1),
        body: Stack(children: [
          Container(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 70),
            child: AnimatedList(
              key: listKey,
              initialItemCount: todoList.length,
              itemBuilder: (context, index, animation) {
                return buildItem(todoList[index], animation, index);
              },
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  searchTextField(),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 10, right: 20, bottom: 20),
                    child: searchButton(),
                  ),
                ],
              ))
        ]));
  }

  Widget buildItem(Todo todo, Animation<double> animation, int index) {
    return SizeTransition(
      sizeFactor: animation,
      child: Opacity(
          opacity: todo.isDone ? 0.65 : 1.0,
          child: Card(
            margin: const EdgeInsets.only(bottom: 12),
            color: const Color.fromRGBO(55, 55, 72, 1),
            child: ListTile(
              leading: IconButton(
                icon: todo.isDone
                    ? const Icon(Icons.check_circle_rounded)
                    : const Icon(Icons.circle_outlined),
                color: const Color.fromRGBO(222, 76, 63, 1),
                onPressed: () => markItem(todo),
              ),
              title: Text(todo.title,
                  style: TextStyle(
                      color: Colors.white,
                      decoration:
                          todo.isDone ? TextDecoration.lineThrough : null,
                      decorationThickness: 2,
                      decorationColor: Colors.white)),
              trailing: IconButton(
                iconSize: 20.0,
                icon: const Icon(Icons.close_rounded, color: Colors.white),
                onPressed: () => removeItem(index),
              ),
            ),
          )),
    );
  }

  void addItem(String item) {
    final index = todoList.length;

    setState(() {
      todoList.add(Todo(id: index, title: item));
    });

    listKey.currentState?.insertItem(index);
    todoController.clear();

    // print(todoList.length);
  }

  void removeItem(int index) {
    final removedItem = todoList[index];

    setState(() {
      todoList.removeAt(index);
    });

    listKey.currentState!.removeItem(
      index,
      (context, animation) => buildItem(removedItem, animation, index),
    );

    // print(todoList.length);
  }

  void markItem(Todo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  Widget searchTextField() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(left: 20, bottom: 20),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.25),
              offset: Offset(
                2.0,
                2.0,
              ),
              blurRadius: 7.0,
              spreadRadius: 2.0,
            ),
          ],
        ),
        child: TextField(
          controller: todoController,
          style: const TextStyle(color: Color.fromRGBO(45, 45, 60, 1)),
          decoration: const InputDecoration(
              hintText: 'Add a new todo item', border: InputBorder.none),
        ),
      ),
    );
  }

  Widget searchButton() {
    return ElevatedButton(
      onPressed: () {
        todoController.text.isNotEmpty ? addItem(todoController.text) : null;
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 10,
        backgroundColor: const Color.fromRGBO(222, 76, 63, 1),
      ),
      child: const Text(
        '+',
        style: TextStyle(
            color: Color.fromRGBO(45, 45, 60, 1),
            fontWeight: FontWeight.w500,
            fontSize: 35.0),
      ),
    );
  }
}
