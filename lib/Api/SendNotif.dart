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
      final client = await clientViaServiceAccount(
          ServiceAccountCredentials.fromJson({
           
          }),
          [firebaseMassageScape]);

      final accesToken = client.credentials.accessToken.data;

      final isiBody = jsonEncode({
        "message": {
          "token": "$token",
          "notification": {"title": "$title", "body": "$isi"},
          "data": {
            "value": "msg",
          }
        }
      });
      var response = await http.post(url,
          headers: {
            "Authorization": "Bearer $accesToken",
            "Content-Type": "application/json"
          },
          body: isiBody);

      if (response.statusCode == 200) {
        print("berhasil dikirim");
      }
    } catch (e) {
      print(e);
    }
  }
}
