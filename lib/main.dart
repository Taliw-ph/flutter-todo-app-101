import 'package:flutter/material.dart';
import 'package:todo_app/todo_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      // home: const MyHomePage(title: 'Todo App with Flutter'),
      home: const ToDoPageWithAPI(title: 'Todo App with Flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textEditingController = TextEditingController();
  final List<Map<String, dynamic>> _todoList = [
    {'name': 'Learn Dart', 'checked': false}
  ];

  void onCheckboxChanged(int index, bool? prev) {
    setState(() {
      _todoList[index]['checked'] = prev != null && prev;
    });
  }

  void addToDoItem() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.deepOrange.shade50,
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Todo name',
                  ),
                  controller: _textEditingController,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  child: const Text('Add'),
                  onPressed: () {
                    if (_textEditingController.text != "") {
                      setState(() {
                        _todoList.add({
                          'name': _textEditingController.text,
                          'checked': false,
                        });
                      });
                    }
                    _textEditingController.text = '';
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: _todoList
            .asMap()
            .map((index, item) => MapEntry(
                  index,
                  ToDoCardItem(
                    name: item['name'],
                    checked: item['checked'],
                    onChanged: (prev) => onCheckboxChanged(index, prev),
                  ),
                ))
            .values
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addToDoItem,
        tooltip: 'Add new to do item',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ToDoCardItem extends StatelessWidget {
  final String name;
  final bool checked;
  final void Function(bool?) onChanged;

  const ToDoCardItem({
    super.key,
    required this.name,
    required this.checked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!checked),
      child: Card(
        child: Row(
          children: [
            Checkbox(value: checked, onChanged: onChanged),
            Expanded(child: Text(name, overflow: TextOverflow.ellipsis)),
          ],
        ),
      ),
    );
  }
}
