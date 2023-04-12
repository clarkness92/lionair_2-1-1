import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final AwesomeNotifications awesomeNotifications = 
    AwesomeNotifications(
      backgroundColor: Colors.blue,
      onNotificationClick: (notification) {
        print('Clicked');
      },
      androidSettings: AndroidSettings(
        channelId: 'my_channel',
        channelName: 'My Channel',
        channelDescription: 'App notification channel',
      ),
    );
  
  await awesomeNotifications.initialize();
  
  runApp(MyApp(awesomeNotifications));
}

class MyApp extends StatelessWidget {
  final AwesomeNotifications awesomeNotifications;

  const MyApp(this.awesomeNotifications);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: () async {
           // make a request to the SOAP API
            final response = await http.get(
              'url of the SOAP API',
            );

            // Parse the JSON response
            // Get the required fields for the notification
            final title = 'title from the response';
            final body = 'body from the response';
            final icon = 'icon from the response';

            // show notification
            await awesomeNotifications.show(
              NotificationDetails(
                id: 1,
                title: title,
                body: body,
                icon: icon,
                payload: {},
              ),
            );
        }),
      ),
    );
  }
}