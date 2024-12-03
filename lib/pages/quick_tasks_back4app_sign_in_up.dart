import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:quicktask_cpad_laks/utils/quick_tasks_widgets.dart';
import 'package:intl/intl.dart';

class QuickTasksBack4AppSignInUp extends StatefulWidget {
  const QuickTasksBack4AppSignInUp({super.key});

  @override
  State<QuickTasksBack4AppSignInUp> createState() => _SignInUpHomePageState();
}

class _SignInUpHomePageState extends State<QuickTasksBack4AppSignInUp> {
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerEmail = TextEditingController();
  bool isLoggedIn = false;

  final _controllerNewQuickTask = TextEditingController();
  List quickTasksList = [];
  String quickTaskName = '';
  int quickTaskId = 0;
  DateTime quickTaskDateTime = DateTime.now();

  final QueryBuilder<ParseObject> quickTasksBack4AppLaks =
      QueryBuilder<ParseObject>(ParseObject('QuickTasksBack4AppLaks'));

  void checkBoxChanged(int index) {
    setState(() {
      quickTasksList[index][1] = !quickTasksList[index][1];
    });
  }

  Future<void> _updateQuickTaskData() async {
    setState(() {
      quickTasksList.add([quickTaskName, false, quickTaskDateTime]);
    });
    final quickTaskObject = ParseObject('QuickTasksBack4AppLaks')
      ..set('message',
          'QuickTasksWithBaaSBack4App Back4App Parser is now connected!🙂')
      ..set('quickTaskId', ++quickTaskId)
      ..set('quickTaskItem', _controllerNewQuickTask.text)
      ..set('quickTaskCompleted', false) //newly created tasks
      ..set('quickTaskDateTime', quickTaskDateTime);
    await quickTaskObject.save();

    // Save the updated object
    var response = await quickTaskObject.save();

    if (response.success) {
      showSuccess("QuickTasks added to back4app!");
    } else {
      showError(response.error!.message);
    }

    setState(() {
      _controllerNewQuickTask.clear();
    });
  }

  void addNewDueDateTime() {
    setState(() {
      quickTasksList.add([quickTaskName, false, quickTaskDateTime]);
      _controllerNewQuickTask.clear();
    });
  }

  void deleteTask(int index) {
    setState(() {
      quickTasksList.removeAt(index);
    });
  }

  void logoutTask() {
    setState(() {
      isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return !isLoggedIn //Not Logged In state
        ? Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('QuickTasks',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                ],
              ),
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 200,
                      child: Image.asset('images/AppLogo.jpg'),
                    ),
                    Center(
                      child: const Text('with BaaS/Back4App',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextField(
                      controller: controllerUsername,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.none,
                      autocorrect: false,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          labelText: 'Username'),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextField(
                      controller: controllerEmail,
                      keyboardType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.none,
                      autocorrect: false,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          labelText: 'E-mail'),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextField(
                      controller: controllerPassword,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.none,
                      autocorrect: false,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          labelText: 'Password'),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 50,
                          child: TextButton(
                            child: const Text('Sign Up',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            onPressed: () => doQuickTasksUserSignUp(),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          height: 50,
                          child: TextButton(
                            child: const Text('Sign In',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            onPressed: () => doQuickTasksUserSignIn(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ))
        //isLogin = true
        : Scaffold(
            backgroundColor: Colors.white12,
            appBar: AppBar(
              title: const Text(
                'Quick Tasks - CPAD - WILP Laks',
              ),
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            body: ListView.builder(
              itemCount: quickTasksList.length,
              itemBuilder: (BuildContext context, index) {
                return QuickTasksWidgets(
                  taskId: index,
                  taskName: quickTasksList[index][0],
                  taskCompleted: quickTasksList[index][1],
                  taskDateTime: quickTasksList[index][2],
                  onChanged: (value) => checkBoxChanged(index),
                  deleteFunction: (contex) => deleteTask(index),
                );
              },
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controllerNewQuickTask,
                      decoration: InputDecoration(
                        hintText: 'Add todo with due',
                        filled: true,
                        fillColor: Colors.yellowAccent,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black38,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.lightGreen,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  FloatingActionButton(
                    child: const Icon(Icons.alarm),
                    onPressed: () async {
                      final choosenDate = await pickDate();
                      if (choosenDate == null) return; //pressed 'cancel'

                      final newDateTime = DateTime(
                        choosenDate.year,
                        choosenDate.month,
                        choosenDate.day,
                        quickTaskDateTime.hour,
                        quickTaskDateTime.minute,
                      );
                      setState(() => quickTaskDateTime = newDateTime);

                      final choosenTime = await pickTime();
                      if (choosenTime == null) return; //pressed 'cancel'

                      final newDateTime2 = DateTime(
                        quickTaskDateTime.year,
                        quickTaskDateTime.month,
                        quickTaskDateTime.day,
                        choosenTime.hour,
                        choosenTime.minute,
                      );
                      setState(() => quickTaskDateTime = newDateTime2);
                      quickTaskName = _controllerNewQuickTask.text;
                      _controllerNewQuickTask.text =
                          _controllerNewQuickTask.text +
                              " " +
                              DateFormat('dd-MMM-yyyy – kk:mm')
                                  .format(newDateTime2);
                    },
                  ),
                  FloatingActionButton(
                    onPressed: () async {
                      await _updateQuickTaskData();
                    },
                    child: const Icon(Icons.add),
                  ),
                  FloatingActionButton(
                    onPressed: logoutTask,
                    child: const Icon(Icons.logout_rounded),
                  ),
                ],
              ),
            ),
          );
  }

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: quickTaskDateTime,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );

  Future<TimeOfDay?> pickTime() => showTimePicker(
        context: context,
        initialTime: TimeOfDay(
            hour: quickTaskDateTime.hour, minute: quickTaskDateTime.minute),
      );
  void showSuccess(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success!"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    controllerUsername.text = '';
    controllerUsername.text = '';
    controllerEmail.text = '';
    controllerPassword.text = '';
  }

  void showError(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error!"),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    controllerUsername.text = '';
    controllerEmail.text = '';
    controllerPassword.text = '';
  }

  void doQuickTasksUserSignUp() async {
    //Signup code here
    final username = controllerUsername.text.trim();
    final email = controllerEmail.text.trim();
    final password = controllerPassword.text.trim();

    if (username == '' || password == '') {
      showError('Enter valid username and Password');
    } else {
      final user = ParseUser.createUser(username, password, email);

      var response = await user.signUp();

      if (response.success) {
        showSuccess("QuickTasks $username User Created!");
      } else {
        showError(response.error!.message);
      }
    }
  }

  void doQuickTasksUserSignIn() async {
    //Sigup code here
    final username = controllerUsername.text.trim();
    //final email = controllerEmail.text.trim();
    final password = controllerPassword.text.trim();
    if (username == '' || password == '') {
      showError('Enter valid username and Password');
    } else {
      final parseResponseQuickTasks = ParseUser(username, password, null);

      var response = await parseResponseQuickTasks.login();

      if (response.success) {
        showSuccess("QuickTasks $username User Welcome!");
        setState(() {
          isLoggedIn = true;
        });
      } else {
        showError(response.error!.message);
      }
    }
  } //doUserSignIn
} //_SignInUpHomePageState
