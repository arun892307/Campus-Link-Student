import 'dart:async';
import 'package:alarm/alarm.dart';
import 'package:alarm/service/notification.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:campus_link_student/Registration/database.dart';
import 'package:campus_link_student/push_notification/helper_notification.dart';
import 'package:campus_link_student/push_notification/temp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'Connection.dart';


const fetchBackground = "fetchBackground";
@pragma('vm:entry-point')
callbackDispatcher() async {

  try{
    GeoPoint current_location=const GeoPoint(0, 0);
    print(".......Starting workmanager executeTask  1.....");
    Workmanager().executeTask((taskName, inputData) async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();

      print(".......Starting asking For Location Always Permission .....");
      await CurrentLocationManager().askForLocationAlwaysPermission();
      print(".......complete asking For Location Always Permission .....");
      print(".......Starting Location  .....");
      CurrentLocationManager().start();

      print("....... Location started .....");
      print("....... fetching current Location  .....");
      current_location=await database().getloc();
      CurrentLocationManager().stop();
      // current_location=await CurrentLocationManager().getCurrentLocation();
      print(".......  current Location  fetched ${current_location.longitude} .....");
      print("....... Uploading location to firebase  .....");
      await FirebaseFirestore.instance
          .collection("Students")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .update({
        "Location": GeoPoint(double.parse(current_location.latitude.toStringAsPrecision(21)), double.parse(current_location.longitude.toStringAsPrecision(21))),
        "Active": true
          }).whenComplete(() {
        print("Start()");
        CurrentLocationManager().stop();

          }
      );
      print("....... location uploaded to firebase  .....");
      Workmanager().cancelByUniqueName("${inputData?["Stamp"]}");
      return Future.value(true);
    });

  }catch (e){
    print("..........error.........\n.........$e........");
  }
}
@pragma('vm:entry-point')
callbackDispatcherfordelevery() async {

  try{
    print(".......Starting workmanager executeTask   2.....");
    Workmanager().executeTask((taskName, inputData) async {
      try{
        WidgetsFlutterBinding.ensureInitialized();
        await Firebase.initializeApp();
        print(".............doc ${inputData?["channel"]}");
        print(".............stamp ${inputData?["stamp"]}");
        await FirebaseFirestore.instance.collection("Messages").doc(inputData?["channel"]).collection("Messages_Detail").doc("Messages_Detail").update(
            {
              "${inputData?["Email"]}_${inputData?["Stamp"]}_Delevered" : FieldValue.arrayUnion([
                {
                  "Email" : FirebaseAuth.instance.currentUser?.email,
                  "Stamp" : DateTime.now()
                }
              ])
            }
        );
      }
      catch (e){
        print("fucking error............................. $e ");
      }
      return Future.value(true);
    });

  }catch (e){
    print("..........error.........\n.........$e........");
  }
}
@pragma('vm:entry-point')
callbackDispatcherforreminder() async {
  try{
    print(".......Starting workmanager executeTask   3.....");
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    Workmanager().executeTask((taskName, inputData) async {
      try{
        int hours=0,minutes=0 ;
        try{


          await FirebaseFirestore.instance.collection('Students').doc(FirebaseAuth.instance.currentUser?.email).get().then((value){
            hours= value.data()?['Study_hours'];
            minutes=value.data()?['Study_minute'];
            // if(value.data()?['Study_section'] == "pm"){
            //   hours+=12;
            // }
          });
        }catch (e) {
          minutes = inputData?['Minute'];
          hours = inputData?['Hour'];
          print('error on -> reminder -> try -> try');
        }
        print("taskname .........: $taskName");
        try{
          bool send=false;
          final now= DateTime.utc(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute,DateTime.now().second,DateTime.now().millisecond,DateTime.now().microsecond);
          final study= DateTime.utc(DateTime.now().year,DateTime.now().month,DateTime.now().day,hours,minutes,0,0,0);
          send = now.difference(study).isNegative ? true : false ;
          print("Difference : ${now.difference(study).isNegative}");
          await AndroidAlarmManager.initialize();
          if(send){

            print("Alarm initialized");
            print(DateTime.now().hour);
            await AndroidAlarmManager.oneShotAt(
                DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                    hours,
                    minutes,
                    0,0,0

                ),
                2,
                firealarm,
                rescheduleOnReboot: true,
                wakeup: true,
                exact: true,
                allowWhileIdle: true,
                alarmClock: true

            );
            print("Alarm one shot ready");
          }
          else{
            int day=DateTime.now().day ;
            int year=DateTime.now().year;
            int month=DateTime.now().month;
            if(database().getDaysInMonth(DateTime.now().year, DateTime.now().month) == day){
              day=1;
              if(month==12){
                month=1;
                year++;
              }
              else{
                month++;
              }

            }
            await AndroidAlarmManager.oneShotAt(
                DateTime(
                    year,
                   month,
                   day,
                    hours,
                    minutes,
                    0,0,0

                ),
                2,
                firealarm,
                rescheduleOnReboot: true,
                wakeup: true,
                exact: true,
                allowWhileIdle: true,
                alarmClock: true

            );

          }
        }catch (e){
          print("error from best  : $e");
        }
        print("...........>>>>>>>>>> alarm set");
      }
      catch (e){
        print("fucking error from alarm............................. $e ");
        return Future.value(false);
      }
      return Future.value(true);
    });

  }catch (e){
    print("..........error.........\n.........$e........");
  }
}

@pragma('vm:entry-point')
Future<void> firealarm()  async {
  print("Alarm fired");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  List<dynamic> notifications=[];
  await FirebaseFirestore.instance.collection("Students").doc(FirebaseAuth.instance.currentUser?.email)
      .get().then((value){
        notifications=value
        .data()?['Notifications'];
     print("Notifications:  $notifications");
  });
  for(int i=0;i<notifications.length;i++){

    NotificationServices.display(
        RemoteMessage(
            data: {
              "title" : notifications[i]['title'],
              "body" : notifications[i]['body'],
              "route" : ""
            }
        ),
        '$i'
    );
  }
  // print("initializing alarm");
  // await Alarm.init(showDebugLogs: true);
  //
  // print("Alarm initialized");
  // print("setting alarm");
  // final alarmSettings = AlarmSettings(
  //   id: 42,
  //   dateTime: DateTime.now(),
  //   assetAudioPath: 'assets/ringtones/male version.mp3',
  //   loopAudio: true,
  //   vibrate: true,
  //   volumeMax: true,
  //   fadeDuration: 3.0,
  //   stopOnNotificationOpen: true,
  //   androidFullScreenIntent: true,
  //   notificationTitle: 'This is the title',
  //   notificationBody: 'This is the body',
  //   enableNotificationOnKill: true,
  //
  // );
  // print("launching alarm");
  // Future(()=> Alarm.set(alarmSettings: alarmSettings));
}
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("Handling a background message");
  }

  print(".............from background handler.............");

  //NotificationServices.display(message);

  if(message.data["body"]=="Attendance Initialized"){

    try{
      Workmanager().initialize(
        callbackDispatcher,
      );
      String stamp=DateTime.now().toString();
      await Workmanager().registerOneOffTask(stamp, "Attendance",inputData: {"Stamp":stamp});

    }catch(e){
      print("........Error from background handler.........");
    }
  }
  if(message.data['body'].toString().split(' ')[0] == "Assignment"){
    try{
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      print("...........>>>>>>>>>> inside firebaseMessagingBackgroundHandler assignment condition");
      Workmanager().initialize(
        callbackDispatcherforreminder,
      );
      print("...........>>>>>>>>>> workmanager initialize");
      int hours=8,minutes=0 ;
      await FirebaseFirestore.instance.collection('Students').doc(FirebaseAuth.instance.currentUser?.email).get().then((value){
        hours= value.data()?['Study_hours'];
        minutes=value.data()?['Study_minute'];
        if(value.data()?['Study_section'] == "pm"){
          hours+=12;
        }
      });
      print("...........>>>>>>>>>> hours and titme loaded for input data");
      print("...........>>>>>>>>>> registring perioding task");
      await Workmanager().registerPeriodicTask(
          "${message.data['title'].toString().split(' ')[1]} Assignment ${message.data['body'].toString().split(' ')[1]}",
          "${message.data['title'].toString().split(' ')[1]} Assignment ${message.data['body'].toString().split(' ')[1]}",
          frequency: const Duration(days: 1 ),
        inputData: {
            "Hour" : hours,
          "Minute" : minutes
        }
      );
      print("...........>>>>>>>>>> perioding task registered");
    }catch(e){
      print("........Error from background handler.........");
    }
  }
  print(message.data["msg"]);
  if(message.data["msg"]=="true"){
    try{
      Workmanager().initialize(
        callbackDispatcherfordelevery,
      );
      print(".......workmanager");
      await Workmanager().registerOneOffTask("Develered", "Delevery",inputData: {
        "channel" :message.data["channel"],
        "Stamp" : message.data["stamp"],
        "Email" : message.data["Email"]
      });
    }catch(e){
      print("........Error from background handler.........");
    }
  }
}
@pragma('vm:entry-point')
Future<void> firebaseMessagingonmessageHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("Handling a onmessage message");
  }

  print(".............From onmessage.............");

  NotificationServices.display(message,"campuslink");

  if(message.data["body"]=="Attendance Initialized"){
    print("error before enter");
    try{
      GeoPoint current_location=await database().getloc();
      await FirebaseFirestore.instance
          .collection("Students")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .update({
        "Location": current_location,
        "Active":true
      });
    }catch(e){
      print("........Error from onmessage handler.........");
    }
  }
  if(message.data['body'].toString().split(' ')[0] == "Assignment"){
    try{
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      print("...........>>>>>>>>>> inside firebaseMessagingBackgroundHandler assignment condition");
      Workmanager().initialize(
        callbackDispatcherforreminder,
      );
      print("...........>>>>>>>>>> workmanager initialize");
      int hours=8,minutes=0 ;
      await FirebaseFirestore.instance.collection('Students').doc(FirebaseAuth.instance.currentUser?.email).get().then((value){
        hours= value.data()?['Study_hours'];
        minutes=value.data()?['Study_minute'];
        if(value.data()?['Study_section'] == "pm"){
          hours+=12;
        }
      });
      print("...........>>>>>>>>>> hours and titme loaded for input data");
      print("...........>>>>>>>>>> registring perioding task");
      await Workmanager().registerPeriodicTask(
          "${message.data['title'].toString().split(' ')[1]} Assignment ${message.data['body'].toString().split(' ')[1]}",
          "${message.data['title'].toString().split(' ')[1]} Assignment ${message.data['body'].toString().split(' ')[1]}",
          frequency: const Duration(days: 1),
          inputData: {
            "Hour" : hours,
            "Minute" : minutes
          }
      );
      print("...........>>>>>>>>>> perioding task registered");
    }catch(e){
      print("........Error from background handler.........");
    }
  }
  if(message.data["msg"]=="true"){
    await FirebaseFirestore.instance.collection("Messages").doc(message.data["channel"]).collection("Messages_Detail").doc("Messages_Detail").update(
        {
          "${message.data["Email"]}_${message.data["stamp"]}_Delevered" : FieldValue.arrayUnion([
            {
              "Email" : FirebaseAuth.instance.currentUser?.email,
              "Stamp" : DateTime.now()
            }
          ])
        }
    );
  }
}
@pragma('vm:entry-point')
Future<void> firebaseMessagingonmessageOpenedAppHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("Handling a onmessage message");
  }

  print(".............From onmessage.............");

  NotificationServices.display(message,"campuslink");

  if(message.data["body"]=="Attendance Initialized"){
    print("error before enter");
    try{
      GeoPoint current_location=await database().getloc();
      await FirebaseFirestore.instance
          .collection("Students")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .update({
        "Location": current_location,
        "Active":true
      });
    }catch(e){
      print("........Error from onmessage handler.........");
    }
  }
  if(message.data['body'].toString().split(' ')[0] == "Assignment"){
    try{
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      print("...........>>>>>>>>>> inside firebaseMessagingBackgroundHandler assignment condition");
      Workmanager().initialize(
        callbackDispatcherforreminder,
      );
      print("...........>>>>>>>>>> workmanager initialize");
      int hours=8,minutes=0 ;
      await FirebaseFirestore.instance.collection('Students').doc(FirebaseAuth.instance.currentUser?.email).get().then((value){
        hours= value.data()?['Study_hours'];
        minutes=value.data()?['Study_minute'];
        if(value.data()?['Study_section'] == "pm"){
          hours+=12;
        }
      });
      print("...........>>>>>>>>>> hours and titme loaded for input data");
      print("...........>>>>>>>>>> registring perioding task");
      await Workmanager().registerPeriodicTask(
          "${message.data['title'].toString().split(' ')[1]} Assignment ${message.data['body'].toString().split(' ')[1]}",
          "${message.data['title'].toString().split(' ')[1]} Assignment ${message.data['body'].toString().split(' ')[1]}",
          frequency: const Duration(days: 1),
          inputData: {
            "Hour" : hours,
            "Minute" : minutes
          }
      );
      print("...........>>>>>>>>>> perioding task registered");
    }catch(e){
      print("........Error from background handler.........");
    }
  }
  if(message.data["msg"]=="true"){
    await FirebaseFirestore.instance.collection("Messages").doc(message.data["channel"]).collection("Messages_Detail").doc("Messages_Detail").update(
        {
          "${message.data["Email"]}_${message.data["stamp"]}_Delevered" : FieldValue.arrayUnion([
            {
              "Email" : FirebaseAuth.instance.currentUser?.email,
              "Stamp" : DateTime.now()
            }
          ])
        }
    );
  }
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Workmanager().initialize(
  //       callbackDispatcher,
  //     );
  // Permission.ignoreBatteryOptimizations.request();
  // Permission.reminders.request();

  // await Alarm.init();
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

enum LocationStatus { UNKNOWN, INITIALIZED, RUNNING, STOPPED }



class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    NotificationServices.initialize(context);

    FirebaseMessaging.onMessage.listen(firebaseMessagingonmessageHandler);

    FirebaseMessaging.onBackgroundMessage.call(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(firebaseMessagingonmessageOpenedAppHandler);

  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: const Color.fromRGBO(213, 97, 132, 1),
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home:Checkconnection(),
      builder: InAppNotifications.init(),
    );
  }
}

