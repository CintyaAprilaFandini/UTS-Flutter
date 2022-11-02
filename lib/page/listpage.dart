import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_listview/page/updateTask.dart';

import '../models/task.dart';
import '../service/tasklist.dart';

class MyListPage extends StatefulWidget {
  const MyListPage({super.key});

  @override
  State<MyListPage> createState() => _MyListPageState();
}

class _MyListPageState extends State<MyListPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<Tasklist>().fetchTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dynamic Listview dengan provider"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: context.watch<Tasklist>().taskList.length,
                itemBuilder: (context, index) {
                  var task = context.watch<Tasklist>().taskList[index];
                  return Dismissible(
                    key: UniqueKey(),
                    background: Container(
                  color: Colors.purple,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: const <Widget>[
                        Icon(Icons.folder_open, color: Colors.white),
                        Text(' Edit Task', style: TextStyle(color: Colors.white)), //untuk nomor nambah edit task sweep up kanan 4 
                      ],
                    ),
                  ),
                ),
                secondaryBackground: Container(
                  color: Colors.orange,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const <Widget>[
                        Icon(Icons.delete, color: Colors.white),
                        Text('Hapus Task', style: TextStyle(color: Colors.white)), // untuk nomor nambah hapus task sweep up kiri 3
                      ],
                    ),
                  ),
                ),
                 onDismissed: (DismissDirection direction) {
                  if (direction == DismissDirection.startToEnd) {
                     Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditTaskPage(model: task),
                          ),
                        ).then((value) {
                          context.read<Tasklist>().fetchTaskList();
                        });
                  } else {
                     context.read<Tasklist>().deleteTask(task).then((value) {
                          context.read<Tasklist>().fetchTaskList();
                        });
                  }         
                },
                child: ListTile(
                      title:
                          Text(context.watch<Tasklist>().taskList[index].name),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // context.read<Tasklist>().addTask();
                      await Navigator.pushNamed(context, "/addTask");
                      // if (!context.mounted) return;
                      if (!mounted) return;
                      context.read<Tasklist>().fetchTaskList();
                    },
                    child: const Text("Halaman Tambah"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}