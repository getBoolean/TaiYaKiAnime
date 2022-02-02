import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../Pages/discovery_page/action.dart';

const AndroidNotificationDetails _androidNotificationDetails =
    AndroidNotificationDetails(
  '48',
  'taiyaki.android.notification',
  'Released episodes',
  enableLights: true,
  ledColor: Color(0xff8405c3),
  ledOnMs: 2500,
  ledOffMs: 2500,
  color: Color(0xff8405c3),
);

const IOSNotificationDetails _iosNotificationDetails = IOSNotificationDetails();

const NotificationDetails platformChannelSpecifics = NotificationDetails(
  android: _androidNotificationDetails,
  iOS: _iosNotificationDetails,
);

class NotificationHandler {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static showNotification(
      NotificationData data, StyleInformation? styleInformation,
      {IOSNotificationAttachment? attachement}) async {
    if (styleInformation != null || attachement != null) {
      final _newPlat = NotificationDetails(
        android: AndroidNotificationDetails(
            '48', 'taiyaki.android.notification', 'Released episodes',
            enableLights: true,
            ledColor: const Color(0xff8405c3),
            ledOnMs: 2500,
            ledOffMs: 2500,
            color: const Color(0xff8405c3),
            styleInformation: styleInformation),
        iOS: IOSNotificationDetails(attachments: [attachement!]),
      );
      await NotificationHandler.flutterLocalNotificationsPlugin.show(
          data.animeID, data.title, data.message, _newPlat,
          payload: data.animeID.toString());
    } else {
      await NotificationHandler.flutterLocalNotificationsPlugin.show(
          data.animeID, data.title, data.message, platformChannelSpecifics,
          payload: data.animeID.toString());
    }
  }

  static init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
      'app_icon',
    );
    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    const MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false);
    final InitializationSettings initializationSettings =
        const InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS);
    await NotificationHandler.flutterLocalNotificationsPlugin
        .initialize(initializationSettings);
  }
}
