import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapps/provider/db_provider.dart';
import 'package:todoapps/ui/todo_add_updated.dart';

import '../widgets/flag_icon_widgets.dart';

class ToDoListPage extends StatelessWidget {
  static const routeName = '/todo_list';

  final _firestore = FirebaseFirestore.instance;
  ToDoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("To Do Apps"),
        actions: [
          const FlagIconWidget(),
          IconButton(
              onPressed: () {
                AppSettings.openDeviceSettings();
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: Consumer<DbProvider>(builder: (context, provider, child) {
        final arrToDo = provider.todos;
        return ListView.builder(
          itemCount: arrToDo.length,
          itemBuilder: (context, index) {
            final todo = arrToDo[index];
            return Dismissible(
                key: Key(todo.id.toString()),
                background: Container(color: Colors.red),
                onDismissed: (direction) {
                  provider.deleteTodo(todo.id!);
                },
                child: Card(
                  child: ListTile(
                    title: Text(todo.id!.toString()),
                    subtitle: Text(todo.detail),
                    trailing: ElevatedButton(
                        onPressed: () {
                          _firestore.collection("todo").add({
                            'id': todo.id,
                            'title': todo.title,
                            'detail': todo.detail,
                            'dateCreated': Timestamp.now(),
                          });
                        },
                        child: const Text("Done")),
                    onTap: () async {
                      // final navigator = Navigator.of(context);
                      final selectedTodo = await provider.getTodoById(todo.id!);
                      // navigator.push(MaterialPageRoute(
                      //     builder: (context) => ToDoAddUpdated(
                      //           todo: selectedTodo,
                      //         )));
                      // Navigation.intentWithData(
                      //     ToDoAddUpdated.routeName.selectedTodo);
                    },
                  ),
                ));
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ToDoAddUpdated()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
