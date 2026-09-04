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
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool isDarkMode = false;
  bool isAddingTask = false;

  // ================= ADD TASK =================

  Future<void> addTask() async {
    String taskName = taskNameController.text.trim();
    String description = descriptionController.text.trim();

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    if (taskName.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter task name and description"),
        ),
      );
      return;
    }

    setState(() {
      isAddingTask = true;
    });

    try {
      await FirebaseFirestore.instance.collection("tasks").doc().set({
        'taskName': taskName,
        'description': description,
        'userId': user.uid,
      });

      taskNameController.clear();
      descriptionController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Task added successfully 🎉"),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to add task: $e"),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isAddingTask = false;
        });
      }
    }
  }

  // ================= DELETE TASK =================

  Future<void> deleteTask(String taskId) async {
    try {
      await FirebaseFirestore.instance
          .collection("tasks")
          .doc(taskId)
          .delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Task deleted"),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to delete task: $e"),
          ),
        );
      }
    }
  } 

  // ================= LOGOUT =================

  Future<void> logoutUser() async {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Authwrapper(),
      ),
    );
  }

  // ================= DISPOSE =================

  @override
  void dispose() {
    taskNameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // ================= TEXT FIELD =================

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // ================= TASK CARD =================

  Widget taskCard(DocumentSnapshot task) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.task_alt_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task['taskName'],
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    task['description'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            IconButton(
              tooltip: "Delete task",
              onPressed: () => deleteTask(task.id),
              icon: const Icon(
                Icons.delete_outline_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Theme(
      data: isDarkMode
          ? ThemeData(
              brightness: Brightness.dark,
              colorSchemeSeed: Colors.deepPurple,
              useMaterial3: true,
            )
          : ThemeData(
              brightness: Brightness.light,
              colorSchemeSeed: Colors.deepPurple,
              useMaterial3: true,
            ),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.check_circle_outline_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Text(
                    "TaskNova",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              actions: [
                IconButton(
                  tooltip: isDarkMode
                      ? "Light mode"
                      : "Dark mode",
                  onPressed: () {
                    setState(() {
                      isDarkMode = !isDarkMode;
                    });
                  },
                  icon: Icon(
                    isDarkMode
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                  ),
                ),

                IconButton(
                  tooltip: "Logout",
                  onPressed: logoutUser,
                  icon: const Icon(
                    Icons.logout_rounded,
                  ),
                ),

                const SizedBox(width: 8),
              ],
            ),

            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 900,
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            // ================= GREETING =================

                            Text(
                              "Welcome back 👋",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              user?.email ?? "User",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),

                            const SizedBox(height: 28),

                            // ================= ADD TASK =================

                            Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(24),
                                side: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .outlineVariant,
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.add_task_rounded,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                        const SizedBox(width: 10),
                                        const Text(
                                          "Create New Task",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 20),

                                    buildTextField(
                                      controller:
                                          taskNameController,
                                      label: "Task Name",
                                      hint:
                                          "Enter your task name",
                                      icon: Icons
                                          .task_alt_rounded,
                                    ),

                                    const SizedBox(height: 14),

                                    buildTextField(
                                      controller:
                                          descriptionController,
                                      label: "Description",
                                      hint:
                                          "Describe your task",
                                      icon: Icons
                                          .description_outlined,
                                      maxLines: 3,
                                    ),

                                    const SizedBox(height: 18),

                                    SizedBox(
                                      width: double.infinity,
                                      height: 52,
                                      child: ElevatedButton.icon(
                                        onPressed: isAddingTask
                                            ? null
                                            : addTask,
                                        icon: isAddingTask
                                            ? const SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                ),
                                              )
                                            : const Icon(
                                                Icons
                                                    .add_rounded,
                                              ),
                                        label: Text(
                                          isAddingTask
                                              ? "Adding..."
                                              : "Add Task",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),

                            // ================= TASK HEADER =================

                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "My Tasks",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore
                                      .instance
                                      .collection("tasks")
                                      .where(
                                        "userId",
                                        isEqualTo: user?.uid,
                                      )
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const SizedBox();
                                    }

                                    return Container(
                                      padding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer,
                                        borderRadius:
                                            BorderRadius.circular(
                                          20,
                                        ),
                                      ),
                                      child: Text(
                                        "${snapshot.data!.docs.length}",
                                        style: TextStyle(
                                          fontWeight:
                                              FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // ================= TASK LIST =================

                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("tasks")
                                  .where(
                                    "userId",
                                    isEqualTo: user?.uid,
                                  )
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.all(40),
                                      child:
                                          CircularProgressIndicator(),
                                    ),
                                  );
                                }

                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text(
                                      "Something went wrong.\nPlease try again.",
                                      textAlign:
                                          TextAlign.center,
                                    ),
                                  );
                                }

                                if (!snapshot.hasData ||
                                    snapshot.data!.docs.isEmpty) {
                                  return Center(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.all(40),
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons
                                                .checklist_rounded,
                                            size: 70,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline,
                                          ),
                                          const SizedBox(height: 16),
                                          const Text(
                                            "No tasks yet",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight:
                                                  FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            "Create your first task above.",
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }

                                final tasks =
                                    snapshot.data!.docs;

                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics:
                                      const NeverScrollableScrollPhysics(),
                                  itemCount: tasks.length,
                                  itemBuilder:
                                      (context, index) {
                                    return taskCard(
                                      tasks[index],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}