import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class UserTodos extends StatefulWidget {
  final int userId;

  UserTodos({required this.userId});

  @override
  _UserTodosState createState() => _UserTodosState();
}

class _UserTodosState extends State<UserTodos> {
  List<dynamic> todos = [];

  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos?userId=${widget.userId}'));

    if (response.statusCode == 200) {
      setState(() {
        todos = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load todos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todos'),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          final bool isCompleted = todo['completed'];

          return Card(
            elevation: 3.0,
            margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: ListTile(
              title: Text(
                todo['title'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),
              tileColor: isCompleted ? Colors.green[100] : Colors.grey[400],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          );
        },
      ),
    );
  }
}