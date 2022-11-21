import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapps/common.dart';
import 'package:todoapps/common/navigation.dart';
import 'package:todoapps/data/model/to_do.dart';
import 'package:todoapps/data/preferences/preferences.dart';
import 'package:todoapps/firebase_options.dart';
import 'package:todoapps/provider/db_provider.dart';
import 'package:todoapps/provider/preferences_provider.dart';
import 'package:todoapps/provider/scheduling_provider.dart';
import 'package:todoapps/ui/done_todo_page.dart';
import 'package:todoapps/ui/login_page.dart';
import 'package:todoapps/ui/register_page.dart';
import 'package:todoapps/ui/settings_page.dart';
import 'package:todoapps/ui/todo_add_updated.dart';
import 'package:todoapps/utils/background_service.dart';
import 'package:todoapps/utils/notification_helper.dart';
import 'package:todoapps/widgets/flag_icon_widgets.dart';
import 'provider/localizations_provider.dart';
import 'ui/to_do_list_page.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();
  await AndroidAlarmManager.initialize();
  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final NotificationHelper _notificationHelper = NotificationHelper();

  @override
  void initState() {
    super.initState();
    _notificationHelper
        .configureSelectNotificationSubject(ToDoAddUpdated.routeName);
    getFCMToken();
    FirebaseMessaging.onMessage.listen(showFlutterNotification);
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DbProvider()),
        ChangeNotifierProvider(
            create: (context) => PreferencesProvider(
                preferencesHelper: PreferencesHelper(
                    sharedPreferences: SharedPreferences.getInstance()))),
        ChangeNotifierProvider(create: (context) => SchedullingProvider()),
        ChangeNotifierProvider(create: (context) => LocalizationProvider()),
      ],
      child: Builder(builder: (context) {
        final provider = Provider.of<LocalizationProvider>(context);
        return MaterialApp(
          locale: provider.locale,
          title: AppLocalizations.of(context)?.titleAppBar ?? 'Text',
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          navigatorKey: navigatorKey,
          theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity),
          home: Scaffold(
            // body: const Center(child: ToDoListPage()),
            body: const LoginPage(),
            bottomNavigationBar: Builder(builder: (context) {
              return BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: 'home'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.done), label: 'done'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.settings), label: 'Settings')
                ],
                currentIndex: 0,
                onTap: (index) {
                  switch (index) {
                    case 0:
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ToDoListPage()));
                      break;
                    case 1:
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return DoneToDoPage();
                        },
                      ));
                      // final NotificationHelper notificationHelper =
                      //     NotificationHelper();
                      // notificationHelper.showNotification(
                      //     flutterLocalNotificationsPlugin,
                      //     Todo(id: 2, title: "title", detail: "detail"));
                      break;
                    case 2:
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingsPage()));
                      break;
                  }
                },
              );
            }),
          ),
        );
      }),
    );
  }

  void showFlutterNotification(RemoteMessage event) {
    debugPrint("Message Data => $event");
    debugPrint("Title => {$event.notification?.title??}");
  }
}

Future<void> getFCMToken() async {
  final token = await FirebaseMessaging.instance.getToken();
  debugPrint(token);
}
