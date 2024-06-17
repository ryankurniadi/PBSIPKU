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
            "type": "service_account",
            "project_id": "pbsi-pku",
            "private_key_id": "ab6f9e88b325cf0bc4e893cc444b7683c4b542e6",
            "private_key":
                "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCj/BmSGJV5RYaS\ngypqrtdJNY0K97jKQbKdFcIbm3f05M3Pq7kgyBOp2ndoEispTQAqTEfYyUMmp+H9\nuFCPQ7svGRMwMxSX23cVlBgIcdnTzapJIrsSbQXOXIT4As9azcVg5tfESzgqopKr\n+ZWurFvReJw1g/SDRcTRFzPznpJtLtPUXiKoz4pMbIlO3pCee8t+7GdMFpx72jBH\nCRthEf0EWRKdT47F7l0TJ/KGE5/DV73v5uys+3lJJ5e5vNHOhDT24FqpqGyiPVfH\nGXbXge9zgQLVgsm/ifO9mUeXdRKIY80l1PWmotckV5AtWhs4+alA1XoJoXhNxrj/\nOUmrv/wHAgMBAAECggEAF3SRu8Hkb2owa3hzcrr7dC9Cs1Tni5aGE83u67/7En4/\nqfqoCjZUCbGD7tDad5fZ9DLg+/MdtcPBoWbhrvxDI+N0SSqlQWtUxzNdlKekPpVm\nS/u5wlLxx6iYJFlSi2xvVQLvzdXsfLywOgUDEe75WybjQQxUxwoNstKczbXav979\n/mjySJiQB/4w3kxQMovQjL7yAGIf6zzsQ6JLnxS86XJR/BC2NLQL1WFSMl7aN5SJ\nuwwiWSr66La+BqwvmVfKDvIPp2eTtZa550UI178B3RSpViM5aWBN8xtTuFf3Psua\nQfDHmVKlAgd1oWiEnmAIpOYTg8yPEx1iAtlLs4kIcQKBgQDfDo3/itxIUHu7930l\nLhTJ8l/CQXvEuVM7AhnA000Zq4GgSPe3LImraiQoisBwlvc8NP/kGmDn+saBudkG\n6mL32unIRYi8gtm2qf41GJcp6OAJABQlh0tq2F4Gst5q1/azB9e+E6eeC4e9ToNI\nP4qqIbuLE0rRrmHfs/Jgy4sIKwKBgQC8NB45QBBoQcrfdidKluiWXvTIc/Y2YK5o\nHj/T/TyrB5bZAMG9x8IT/YiiZCpCK0OT0gKT+tXhxL+ciuPI/gk4/iNJ3xeu45+5\na1mg+vKXxKy1J9ZSKlL7EMhd55njh+4jajWKwZ6UdNUTkgpiRUgib0M22C/K9AqI\nV5XRv8wxlQKBgFEFW2TQDpWhzmAHVIi1xU1ZYZkQ6iEZ4/aSG8KjveSuHGaZOolp\nfxQpeLrVM3NyEpnm8m/rePmqaIJkfEV7y7kV5kcdor4+lVA5TSICLZ5GfWIniinb\ni/RiZTzvqcSLb4u2NJJRV1gb/hEwPJV4pyiHGjU5K7sgKWL1XPv10ymDAoGBAJN2\narAE6FYoJuNMWqDw+TDJGhbt9V7KBh2ChhR9+Ukw2xsQor0mhYTQRHyo6wuJhpuO\nE4MLKQaK+G+Zy7yyf1tulQvOh2n65C2OVV3zAp2z9nbCzgT3MKmTjss1KrjCyu5o\ny6b66lv75vA8n3I8QrboYsvYPCpTaOVHaxY7p6y5AoGBAJLINaAD64Srf7OHfDGV\nrOvUr808Y1hurUmhSwzsy/qFEeMu9MRbclt5wpW+PZoGAYXeDxk2/uvvmCzRKT2T\nKDSD39TWA4aZ/OQiez/hd2+s9DPguir6Pfj0wj7wMLPfKjpF37Zcr2giV998vQh1\nrprCiky18lBhkSyZlenErHTw\n-----END PRIVATE KEY-----\n",
            "client_email":
                "firebase-adminsdk-5uzo7@pbsi-pku.iam.gserviceaccount.com",
            "client_id": "106192959516975331513",
            "auth_uri": "https://accounts.google.com/o/oauth2/auth",
            "token_uri": "https://oauth2.googleapis.com/token",
            "auth_provider_x509_cert_url":
                "https://www.googleapis.com/oauth2/v1/certs",
            "client_x509_cert_url":
                "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-5uzo7%40pbsi-pku.iam.gserviceaccount.com",
            "universe_domain": "googleapis.com"
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
