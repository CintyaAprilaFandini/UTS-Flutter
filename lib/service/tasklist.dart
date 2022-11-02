import 'package:flutter/material.dart';
import '../models/task.dart';
import 'database_service.dart';
import 'validation.dart';

class Tasklist with ChangeNotifier {

  final DatabaseService _databaseService = DatabaseService();

  List<Task> _taskList = [];
  //String _taskName = "";

  bool _isActive = true;

  

  get taskList => _taskList;
  get taskName => _taskName;
  get isActive => _isActive;

  Validation _taskName = Validation(null, null);

  // validation untuk nomor 1
  void setTaskName(String? taskName) {
    // validate if input null
    if (taskName == "") {
      _taskName = Validation(null, "Task Name harus diisi");
      _isActive = false;
    } else if (taskName!.length <= 3) {
      _taskName = Validation(null, "Task Name harus lebih dari 3 huruf");
      _isActive = false;
    } else {
      // if input is correct
      _taskName = Validation(taskName, null);
    }

    notifyListeners();
  }
//fitur validasi pada edit task nomor 6
  void onTaskNameChange(String? value) {
    if (value != "" && value!.length > 3) {
      _isActive = true;
    }
    clear();
    notifyListeners();
  }

  void clear() {
    _taskName = Validation(null, null);
  }

  bool isValidated() {
    return (_taskName.value != null && _taskName.value!.length >= 3)
        ? true
        : false;
  }

  void addNewTask(String taskName) async {
    await _databaseService.insertTask(
      Task(name: taskName, status: 0),
    );
    notifyListeners();
   
  }

  void changeTaskName(String taskName) {
    taskName = taskName;
    notifyListeners();
  }

  Future<void> fetchTaskList() async {
    _taskList = await _databaseService.taskList();
    notifyListeners();
  }

  Future<void> addTask() async {
    await _databaseService.insertTask(
      Task(name: taskName, status: 0),
    );
    notifyListeners();
  }

   Future<void> editTask(Task task, String before ) async {
    await _databaseService.editTask(task, before);
    notifyListeners();
   }

  Future<void> deleteTask(Task task) async {
    print("Delete Task ${task.name}");
    await _databaseService.deleteTask(task.name);
    fetchTaskList();
    notifyListeners();
  }
}