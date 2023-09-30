import 'package:flutter/material.dart';
import 'package:todo_app/fetch_todos.dart';

import 'main.dart';

class ToDoPageWithAPI extends StatefulWidget {
  const ToDoPageWithAPI({super.key, required this.title});

  final String title;

  @override
  State<ToDoPageWithAPI> createState() => _ToDoPageWithAPIState();
}

class _ToDoPageWithAPIState extends State<ToDoPageWithAPI> {
  final TextEditingController _textEditingController = TextEditingController();
  late Future<List<Todo>> futureTodo;

  @override
  void initState() {
    super.initState();
    futureTodo = fetchTodos().then((value) {
      debugPrint(value[0].toJson());
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Todo>>(
        future: futureTodo,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
                children: snapshot.data!
                    .asMap()
                    .map((index, item) => MapEntry(
                          index,
                          ToDoCardItem(
                            name: item.title,
                            checked: item.completed,
                            onChanged: (prev) {
                              setState(() {
                                snapshot.data![index].completed =
                                    prev != null && prev;
                              });
                            },
                          ),
                        ))
                    .values
                    .toList());
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
