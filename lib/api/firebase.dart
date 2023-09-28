import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:neapolis_car/main.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async{
  print('Title${message.notification?.title}');
  print('Body${message.notification?.body}');
  print('Payload${message.data}');

}
class FirebaseApi{
  final _firebaseMessaging= FirebaseMessaging.instance;
  Future<void> initNotifications() async{
    await _firebaseMessaging.requestPermission();
    final fCMToken= await _firebaseMessaging.getToken();
    print('Token$fCMToken');
    const String apiUrl = '$ip/polls/InsertClientToken';
    final Map<String, dynamic> requestData = {
      'token': fCMToken,
    };
    final headers = {
      'Content-Type': 'application/json',
    };
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(requestData),
      );
      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        final message = responseJson['message'];
        if (message=="secc"){
          FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
        }
        else{
          FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
        }
      } else {
      }
    } catch (e) {
      print('Error sending FCM token to the server: $e');
    }
  }
}