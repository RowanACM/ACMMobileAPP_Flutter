import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingUtils{
  final  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  static  FirebaseMessagingUtils firebaseMessagingUtils;
  _FirebaseMessagingUtils(){
  }
  void setup(){
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.configure();
    subscribe('general');
  }
  void subscribe(String topic){
    _firebaseMessaging.subscribeToTopic(topic);
  }
  static FirebaseMessagingUtils getInstance(){
    if(firebaseMessagingUtils == null){
      firebaseMessagingUtils = new FirebaseMessagingUtils();
    }
    return firebaseMessagingUtils;
  }
}