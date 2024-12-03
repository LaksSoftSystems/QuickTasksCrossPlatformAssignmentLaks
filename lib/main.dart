import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:quicktask_cpad_laks/pages/quick_tasks_back4app_sign_in_up.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const keyApplicationId = 'zkejEhDDI5JUEXJfU6PUWeQjr0tMrqvJVaTMMVbV';
  const keyClientKey = 'laz0lO1avCptqhYQyPnnRPpxRiRqdAZlcH9OMso0';
  const keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(
    keyApplicationId,
    keyParseServerUrl,
    clientKey: keyClientKey,
    autoSendSessionId: true,
    debug: false,
  );
  runApp(QuickTasksApp());
}

class QuickTasksApp extends StatefulWidget {
  @override
  _QuickTasksAppState createState() => _QuickTasksAppState();
}

class _QuickTasksAppState extends State<QuickTasksApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: QuickTasksBack4AppSignInUp(),
    );
  }
}
