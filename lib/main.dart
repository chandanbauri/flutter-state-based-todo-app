import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'SUFU DO',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        initialRoute: '/login',
        routes: {
          '/': (context) => const HomePage(),
          '/login': (context) => const LoginPage()
        });
  }
}

class Task {
  String title;
  bool state = false;

  Task({required this.title});

  // Mark task as done
  markDone() {
    state = true;
  }
}

class FormBackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    var path = Path();
    path.moveTo(10, 50);
    path.lineTo(10, size.height - 50);
    path.quadraticBezierTo(10, size.height, 50, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 10);
    path.lineTo(50, 10);
    path.quadraticBezierTo(10, 10, 10, 50);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}

// Pages

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> tasks =
      List.of([Task(title: 'My First Task'), Task(title: 'My Second Task')]);
  TextEditingController newTaskInputField =
      TextEditingController(text: 'New task name');

  void addTask() {
    String text = newTaskInputField.text;
    Task newTask = Task(title: text);
    setState(() {
      tasks.add(newTask);
    });
  }

  void markTaskDone(Task task) {
    setState(() {
      task.markDone();
    });
  }

  void removeTask(Task task) {
    setState(() {
      tasks.remove(task);
    });
  }

  @override
  Widget build(BuildContext context) {
    final int taskListLength = tasks.length;
    return Scaffold(
      appBar: AppBar(
        title: const Text('SUFU DO'),
      ),
      body: Center(
        child: Material(
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                child: Text('My tasks'),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10.0, 10, 0),
                child: TextField(
                  controller: newTaskInputField,
                ),
              ),
              ElevatedButton(onPressed: addTask, child: const Text('Add Task')),
              Expanded(
                child: Hero(
                  tag: 'background',
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: taskListLength,
                      scrollDirection: Axis.vertical,
                      itemBuilder: ((context, index) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(tasks[index].title),
                                Row(
                                  children: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: tasks[index].state
                                                ? Colors.grey
                                                : Colors.amber),
                                        onPressed: () =>
                                            markTaskDone(tasks[index]),
                                        child: Text(tasks[index].state
                                            ? 'Done'
                                            : 'Mark Done')),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red),
                                        onPressed: () =>
                                            removeTask(tasks[index]),
                                        child: const Text('Remove')),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      })),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();
  String _phone = '';
  String _passwod = '';

  @override
  Widget build(BuildContext context) {
    void onLogin() {
      print(_phone + '-' + _passwod);
      if (_loginFormKey.currentState != null &&
          _loginFormKey.currentState?.validate() == true) {
        Navigator.of(context).pushNamed('/');
      }
    }

    return Scaffold(
        appBar: null,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  'SUFU Do',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 34,
                  ),
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              Form(
                key: _loginFormKey,
                child: ClipPath(
                  clipper: FormBackgroundClipper(),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Column(children: [
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Phone'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please fill the field';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _phone = value;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please fill the field';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _passwod = value;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Hero(
                          tag: 'background',
                          child: Material(
                            type: MaterialType.transparency,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white),
                                onPressed: onLogin,
                                child: const Text('Login',
                                    style: TextStyle(
                                        fontSize: 24, color: Colors.amber))),
                          ),
                        )
                      ]),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
