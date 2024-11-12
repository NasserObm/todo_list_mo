// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list_mo/user.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User user = User('', '', '', '');
  List<Map<String, dynamic>> tasks = [];
  final TextEditingController _taskController = TextEditingController();
  String? editingTaskId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    user = await getShared();
    setState(() {});
    await _fetchTasks();
  }

  Future<User> getShared() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String nom = preferences.getString('name') ?? '';
    String email = preferences.getString('email') ?? '';
    String password = preferences.getString('password') ?? '';
    String accessToken = preferences.getString('accessToken') ?? '';
    print('AccessToken récupéré: $accessToken');
    return User(nom, email, password, accessToken);
  }

  Future<void> _fetchTasks() async {
    final url =
        Uri.parse('https://todolist-api-production-1e59.up.railway.app/task');
    if (user.accessToken.isEmpty) {
      print("Aucun Token trouvé");
      return;
    }
    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${user.accessToken}'
      });
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        setState(() {
          tasks = data.map((task) => task as Map<String, dynamic>).toList();
        });
        print('Tâches récupérées: $tasks');
      } else {
        print('Erreur de récupération des tâches : ${response.statusCode}');
      }
    } catch (e) {
      print("Erreur de requête : $e");
    }
  }

  Future<void> _addTask(String taskName) async {
    final url =
        Uri.parse('https://todolist-api-production-1e59.up.railway.app/task');
    final body = jsonEncode({'contenu': taskName});
    if (user.accessToken.isEmpty) {
      print("Aucun Token trouvé");
      return;
    }
    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${user.accessToken}'
          },
          body: body);
      if (response.statusCode == 201) {
        _fetchTasks();
        _taskController.clear();
      } else {
        print('Erreur d\'ajout de la tâche : ${response.statusCode}');
      }
    } catch (e) {
      print("Erreur de requête : $e");
    }
  }

  Future<void> _updateTask(String taskId, String newContent) async {
    final url = Uri.parse(
        'https://todolist-api-production-1e59.up.railway.app/task/$taskId');
    final body = jsonEncode({'contenu': newContent});

    if (user.accessToken.isEmpty) {
      print("Aucun Token trouvé");
      return;
    }

    try {
      final response = await http.put(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${user.accessToken}'
          },
          body: body);

      if (response.statusCode == 200) {
        _fetchTasks();
        setState(() {
          editingTaskId = null;
          _taskController.clear();
        });
      } else {
        print('Erreur de mise à jour de la tâche : ${response.statusCode}');
      }
    } catch (e) {
      print("Erreur de requête : $e");
    }
  }

  Future<void> _deleteTask(String taskId) async {
    final url = Uri.parse(
        'https://todolist-api-production-1e59.up.railway.app/task/$taskId');
    if (user.accessToken.isEmpty) {
      print("Aucun Token trouvé");
      return;
    }
    try {
      final response = await http.delete(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${user.accessToken}'
      });
      if (response.statusCode == 200) {
        _fetchTasks();
      } else {
        print('Erreur de suppression de la tâche : ${response.statusCode}');
      }
    } catch (e) {
      print("Erreur de requête : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To-Do List"),
        backgroundColor: const Color(0xffba7264),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user.nom),
              accountEmail: Text(user.email),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child:
                    Text(user.nom.isNotEmpty ? user.nom[0].toUpperCase() : "?"),
              ),
              decoration: const BoxDecoration(color: Color(0xffba7264)),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Paramètres"),
              onTap: () => context.go("/parametre"),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Déconnexion"),
              onTap: () => context.go("/connection"),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nom de la tâche',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (editingTaskId != null) {
                  _updateTask(editingTaskId!, _taskController.text);
                } else {
                  _addTask(_taskController.text);
                }
              },
              style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 5),
                  backgroundColor: const Color(0xffba7264),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
              child: Text(
                editingTaskId != null ? 'Mettre à jour' : 'Enregistrer',
                style: const TextStyle(color: Color(0xffffffff), fontSize: 30),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    child: ListTile(
                      leading:
                          const Icon(Icons.circle_outlined, color: Colors.grey),
                      title: Text(
                        task['contenu'] ?? '',
                        style: const TextStyle(fontSize: 18),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              setState(() {
                                editingTaskId = task['id'];
                                _taskController.text = task['contenu'] ?? '';
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteTask(task['id']),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
