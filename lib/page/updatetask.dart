import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../service/tasklist.dart';

class EditTaskPage extends StatefulWidget {
  const EditTaskPage({super.key, this.model});

  final Task? model;

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}
// fitur edit task
class _EditTaskPageState extends State<EditTaskPage> {
  TextEditingController? controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.model?.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Task Baru"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "Masukkan Task Baru",
              ),
             onChanged: (value) {
                context.read<Tasklist>().onTaskNameChange(value);
              },
              ),
            const SizedBox(
              height: 50,
            ),
            Row(
              children: [
                Expanded( //untuk nambah fitur disable nomor 7 
                  child: ElevatedButton(
                    onPressed: context.watch<Tasklist>().isActive
                        ? () {
                      final model = Task.fromMap({
                        'name': controller?.text,
                        'status': 0,
                      });
                          context
                          .read<Tasklist>()
                          .setTaskName(controller?.text);
                      if (context.read<Tasklist>().isValidated()) {
                          context
                          .read<Tasklist>()
                          .editTask(model, widget.model!.name)
                          .then((value) {
                          Navigator.pop(context);
                          } );
                      }
                    }
                    : null,
                    child: const Text("Edit Task"),
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