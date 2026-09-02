import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/AuthWrapper.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController TaskNameController = TextEditingController();
  TextEditingController TaskDateController = TextEditingController();
  TextEditingController TaskTimeController = TextEditingController();

  Future<void> addTask() async {
    String taskName = TaskNameController.text.trim();
    String taskDate = TaskDateController.text.trim();
    String taskTime = TaskTimeController.text.trim();

    if (taskName.isEmpty || taskDate.isEmpty || taskTime.isEmpty) {
      print("Please fill in all fields");
      return;
    }
    await FirebaseFirestore.instance.collection("tasks").doc().set({
      'taskName': taskName,
      'taskDate': taskDate,
      'taskTime': taskTime,
    });
    // Here you can add the logic to save the task to a database or perform any other action
    print("Task added: $taskName, Date: $taskDate, Time: $taskTime");

    // Clear the text fields after adding the task
    TaskNameController.clear();
    TaskDateController.clear();
    TaskTimeController.clear();
  }
  Future<void> logoutUser() async {
  await FirebaseAuth.instance.signOut();
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const Authwrapper()),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            Text('Welcome to the Homepage!'),
            TextFormField(
              controller: TaskNameController,
              decoration: InputDecoration(
                labelText: 'Task Name',
                border: OutlineInputBorder(),
              ),
            ),
            TextFormField(
              controller: TaskDateController,
              decoration: InputDecoration(
                labelText: 'Task Date',
                border: OutlineInputBorder(),
              ),
            ),
            TextFormField(
              controller: TaskTimeController,
              decoration: InputDecoration(
                labelText: 'Task Time',
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
              onPressed: addTask,
               child: Text('Add Task'),
                ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: logoutUser,
            child: const Text("Logout"),
          ),
        ),
      )
      
    );
  }
}