import 'dart:convert';

import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/googleapis_auth.dart';

class SendNotif {
  var url = Uri.parse(
      'https://fcm.googleapis.com/v1/projects/pbsi-pku/messages:send');

  String firebaseMassageScape =
      "https://www.googleapis.com/auth/firebase.messaging";

  sendNotif(String token, String title, String isi) async {
    try {
      //test
    } catch (e) {
      print(e);
    }
  }
}
