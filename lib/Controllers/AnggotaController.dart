import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/User.dart';
import './AuthController.dart';
import './LoadingController.dart';

class AnggotaController extends GetxController {
  final authC = Get.find<AuthController>();
   final loadC = Get.find<LoadingController>();
  final db = FirebaseFirestore.instance;
  var pbsi = ''.obs;
  var pbsinama = ''.obs;
  var dataUser = [].obs;
  var totalUser = 0.obs;


    var defaultimg =
      "https://firebasestorage.googleapis.com/v0/b/pbsi-pku.appspot.com/o/Users%2Fdefault.png?alt=media&token=640e9911-8829-4370-9a0c-227496d07284";
  var nama = "".obs;
  var level = "".obs;
  var username = "".obs;
  var email = "".obs;
  var isActive = false.obs;
  var isPickUsername = false.obs;
  var skill = "Level D".obs;
  var hp = 0.obs;

  getAnggotaPBSI(String namaPBSI, String DisplayPBSI) async {
    pbsi.value = namaPBSI;
    pbsinama.value = DisplayPBSI;
    final ref = db.collection("users").withConverter(
        fromFirestore: User.fromFirestore,
        toFirestore: (User user, _) => user.toFirestore());



    try {
      final docSnap = await ref
          .where('pbsi'.toString().toLowerCase(), isEqualTo: namaPBSI).orderBy('level')
          .get();
      if (docSnap.docs.isNotEmpty) {
        totalUser.value = docSnap.docs.length;
        dataUser.clear();
        for (var i = 0; i < docSnap.docs.length; i++) {
          dataUser.add(User(
            id: docSnap.docs[i].id,
            nama: docSnap.docs[i].data().nama,
            token: docSnap.docs[i].data().token,
            hp: docSnap.docs[i].data().hp,
            email: docSnap.docs[i].data().email,
            img: docSnap.docs[i].data().img,
            isActive: docSnap.docs[i].data().isActive,
            isPickUsername: docSnap.docs[i].data().isPickUsername,
            username: docSnap.docs[i].data().username,
            level: docSnap.docs[i].data().level,
            pbsi: docSnap.docs[i].data().pbsi,
            skill: docSnap.docs[i].data().skill,
          ));
        }
      } else {
        totalUser.value = 0;
        dataUser.clear();
      }
      update();
    } catch (e) {
      print(e);
    }
  }


  addAnggota()async{

  loadC.changeLoading(true);
    final _user = User(
      nama: nama.value,
      img: defaultimg,
      token: "",
      username: "null",
      email: email.value,
      hp: hp.value,
      isActive: isActive.value,
      isPickUsername: isPickUsername.value,
      level: "Anggota PBSI",
      pbsi: pbsi.value,
      skill: skill.value,
    );
    try {
      if (await authC.checkEmail(email.value)) {
        throw Exception();
      } else {
        await authC.registerUser(email.value);
        if (authC.isLoginFail.value) {
          throw Exception();
        }
        final ref = db.collection("users").withConverter(
            fromFirestore: User.fromFirestore,
            toFirestore: (User user, _) => user.toFirestore());
        await ref.add(_user);
        final userlog = <String, String>{
          "email": email.value,
          "username": "null",
        };
        await db.collection("userlogs").add(userlog);
        getAnggotaPBSI(pbsi.value, pbsinama.value);
        loadC.changeLoading(false);
        Get.back();
        Get.snackbar("Berhasil", "Data Berhasil Di tambah",
            backgroundColor: Colors.green);
      }
    } catch (e) {
      loadC.changeLoading(false);
      Get.snackbar("Gagal", "Data Gagal Di Tambah",
          backgroundColor: Colors.red);
    }
  }

    deleteUser(String id, String emails) async {
    try {
      await db.collection('users').doc(id).delete();
      getAnggotaPBSI(pbsi.value, pbsinama.value);
            final log = await db
          .collection('userlogs')
          .where('email'.toString().toLowerCase(),
              isEqualTo: emails.toLowerCase())
          .get();
      log.docs.forEach((doc) {
        doc.reference.delete();
      });
      Get.back();
      Get.snackbar("Berhasil", "Data Berhasil Di Hapus",
          backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar("Gagal", "Data Gagal Di Hapus", backgroundColor: Colors.red);
    }
  }


  @override
  void onInit() {
    getAnggotaPBSI(authC.authpbsi.value, authC.authpbsinama.value);
    super.onInit();
  }
}
