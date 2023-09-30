import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List<Todo>> fetchTodos() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return (jsonDecode(response.body) as List)
        .map((e) => Todo.fromMap(e))
        .toList();

  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load todos');
  }
}

class Todo {
  final int userId;
  final int id;
  final String title;
  bool completed;

  Todo({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  Todo copyWith({
    int? userId,
    int? id,
    String? title,
    bool? completed,
  }) =>
      Todo(
        userId: userId ?? this.userId,
        id: id ?? this.id,
        title: title ?? this.title,
        completed: completed ?? this.completed,
      );

  factory Todo.fromJson(String str) => Todo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Todo.fromMap(Map<String, dynamic> json) => Todo(
    userId: json["userId"],
    id: json["id"],
    title: json["title"],
    completed: json["completed"],
  );

  Map<String, dynamic> toMap() => {
    "userId": userId,
    "id": id,
    "title": title,
    "completed": completed,
  };
}
