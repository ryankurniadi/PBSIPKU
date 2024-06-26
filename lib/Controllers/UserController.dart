import 'dart:html';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../Models/User.dart';
import './AuthController.dart';
import './LoadingController.dart';

class UserController extends GetxController {
  final db = FirebaseFirestore.instance;
  final Rx<Uint8List?> imageBytes = Uint8List(0).obs;
  final authC = Get.find<AuthController>();
  final loadC = Get.find<LoadingController>();
  String tabel = "users";

  var dataUser = [].obs;
  var totalUser = 0.obs;

  //data imputan
  var defaultimg =
      "https://firebasestorage.googleapis.com/v0/b/pbsi-pku.appspot.com/o/Users%2Fdefault.png?alt=media&token=640e9911-8829-4370-9a0c-227496d07284";
  var nama = "".obs;
  var level = "".obs;
  var username = "".obs;
  var email = "".obs;
  var isActive = false.obs;
  var isPickUsername = false.obs;
  var pbsi = "".obs;
  var skill = "Level D".obs;
  var hp = 0.obs;
  var pbsiname = "".obs;
  var statusupload = true.obs;
  var img = ''.obs;

  var nik = 0.obs;
  var tgl = DateTime.now().obs;
  var dateShow = "".obs;
  var lahir = "".obs;
  var alamat = "".obs;
  var changeUsername = "".obs;

  var idUser = "".obs;

  var isRoot = true.obs;
  User? userProfil;

  getUserData() async {
    final ref = db.collection("users").withConverter(
        fromFirestore: User.fromFirestore,
        toFirestore: (User user, _) => user.toFirestore());
        
    try {
      final docSnap = await ref.orderBy('nama').get();
      
      if (docSnap.docs.isNotEmpty) {
        totalUser.value = docSnap.docs.length;
        dataUser.clear();
        
        for (var i = 0; i < docSnap.docs.length; i++) {

          String? namas = docSnap.docs[i].data().pbsi;
          if (namas != "") {
            final snap = await db.collection('pbsi').doc(docSnap.docs[i]['pbsi']).get();
                          
            if (snap != null) {
              
              namas = snap.data()!['nama'];
            }
          } else {
            namas = "Admin Pusat";
          }
          
          dataUser.add(User(
            id: docSnap.docs[i].id,
            nama: docSnap.docs[i].data().nama,
            hp: docSnap.docs[i].data().hp,
            email: docSnap.docs[i].data().email,
            img: docSnap.docs[i].data().img,
            isActive: docSnap.docs[i].data().isActive,
            isPickUsername: docSnap.docs[i].data().isPickUsername,
            username: docSnap.docs[i].data().username,
            token: docSnap.docs[i].data().token,
            level: docSnap.docs[i].data().level,
            pbsi: namas,
            skill: docSnap.docs[i].data().skill,
            nik: docSnap.docs[i].data().nik,
            alamat: docSnap.docs[i].data().alamat,
            lahir: docSnap.docs[i].data().lahir,
            tgl: docSnap.docs[i].data().tgl,
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

  addUser() async {
    loadC.changeLoading(true);
    final _user = User(
      nama: nama.value,
      token: "",
      img: defaultimg,
      username: "null",
      email: email.value,
      hp: hp.value,
      isActive: isActive.value,
      isPickUsername: isPickUsername.value,
      level: level.value,
      pbsi: pbsi.value,
      skill: skill.value,
      alamat: alamat.value,
      lahir: lahir.value,
      tgl: tgl.value,
      nik: nik.value,
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
        getUserData();
        loadC.changeLoading(false);
        pbsi.value = "";
        level.value = "";
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
      final log = await db
          .collection('userlogs')
          .where('email'.toString().toLowerCase(),
              isEqualTo: emails.toLowerCase())
          .get();

      log.docs.forEach((doc) {
        //print(doc.id);
        doc.reference.delete();
      });

      await getUserData();
      Get.back();
      Get.snackbar("Berhasil", "Data Berhasil Di Hapus",
          backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar("Gagal", "Data Gagal Di Hapus", backgroundColor: Colors.red);
    }
  }

  levelUserChanger(bool value) {
    isRoot.value = value;
    update();
  }

  getPBName(String userEmail) async {
    final ref = db.collection("users").withConverter(
        fromFirestore: User.fromFirestore,
        toFirestore: (User user, _) => user.toFirestore());
    try {
      final data =
          await ref.where('email'.toString(), isEqualTo: userEmail).get();
      final snap = await db.collection('pbsi').doc(data.docs[0]['pbsi']).get();
      if (snap != null) {
        String nama = snap.data()!['nama'];
        return nama;
      }
    } catch (e) {
      return "No Data";
    }
  }

  getSingelUSerForEdit(String id) async {
    final ref = db.collection("users").withConverter(
        fromFirestore: User.fromFirestore,
        toFirestore: (User user, _) => user.toFirestore());
    try {
      final data = await ref.doc(id).get();

      nama.value = data.data()!.nama!;
      nik.value = data.data()!.nik!;
      tgl.value = data.data()!.tgl!;
      lahir.value = data.data()!.lahir!;
      level.value = data.data()!.level!;
      alamat.value = data.data()!.alamat!;
      pbsi.value = data.data()!.pbsi!;
      hp.value = data.data()!.hp!;
      skill.value = data.data()!.skill!;
      idUser.value = id;

      if (level.value != "Root") {
        isRoot.value = false;
      } else {
        isRoot.value = true;
      }

      final pbsis = await db.collection('pbsi').doc(data.data()!.pbsi).get();
      pbsiname.value = pbsis.data()!['nama'];

      showDate(tgl.value);
      update();
    } catch (e) {
      print(e);
    }
  }

  editUser(String id) async {
    loadC.changeLoading(true);
    final ref = db.collection("users").withConverter(
        fromFirestore: User.fromFirestore,
        toFirestore: (User user, _) => user.toFirestore());
    try {
      await ref.doc(id).update({
        "nama": nama.value,
        "hp": hp.value,
        "level": level.value,
        "pbsi": pbsi.value,
        "tgl": tgl.value,
        "nik": nik.value,
        "alamat": alamat.value,
        "lahir": lahir.value,
      });

      await getUserData();
      loadC.changeLoading(false);
      Get.back();
      Get.snackbar("Berhasil", "Data Berhasil Di perbaharui",
          backgroundColor: Colors.green);
    } catch (e) {
      loadC.changeLoading(false);
      Get.snackbar("Gagal", "Data Gagal Di perbaharui",
          backgroundColor: Colors.red);
    }
  }

  getSingleUser() async {
    try {
      print(authC.authEmail.value);
      final ref = db.collection("users").withConverter(
          fromFirestore: User.fromFirestore,
          toFirestore: (User user, _) => user.toFirestore());
      final data = await ref
          .where('email'.toString().toLowerCase(),
              isEqualTo: authC.authEmail.value.toLowerCase())
          .get();

      userProfil = User(
        id: data.docs[0].id,
        nama: data.docs[0]['nama'],
        level: data.docs[0]['level'],
        username: data.docs[0]['username'],
        email: data.docs[0]['email'],
        hp: data.docs[0]['hp'],
        img: data.docs[0]['img'],
        isActive: data.docs[0]['isActive'],
        isPickUsername: data.docs[0]['isPickUsername'],
        pbsi: data.docs[0]['pbsi'],
        skill: data.docs[0]['skill'],
        alamat: data.docs[0]['alamat'],
        lahir: data.docs[0]['lahir'],
        nik: data.docs[0]['nik'],
        tgl: data.docs[0]['tgl'].toDate(),
        token: data.docs[0]['token'],
      );
      print("done");
      final snap = await db.collection('pbsi').doc(userProfil!.pbsi).get();
      if (snap != null) {
        pbsiname.value = snap.data()!['nama'];
        //print(use.data()!['nama']);
      }
      update();
    } catch (e) {
      print("error Get Data User");
      print(e);
    }
  }

  void setDate(DateTime tgls) {
    tgl.value = tgls;
    showDate(tgls);
    update();
  }

  void showDate(DateTime tgl) {
    dateShow.value = "${DateFormat("EEEE, dd MMMM yyyy", "id").format(tgl)}";
    update();
  }

  changeUser(String userID) async {
    loadC.changeLoading(true);
    final ref = db.collection("users").withConverter(
        fromFirestore: User.fromFirestore,
        toFirestore: (User user, _) => user.toFirestore());

    try {
      final data = await ref
          .where('username'.toString().toLowerCase(),
              isEqualTo: changeUsername.value.toLowerCase())
          .get();

      if (data.docs.length >= 1) {
        throw Exception("Udah ada");
      }

      final us = await db
          .collection('userlogs')
          .where('email'.toString().toLowerCase(),
              isEqualTo: authC.authEmail.value.toLowerCase())
          .get();
      String logID = us.docs[0].id;

      await ref.doc(userID).update({
        "username": changeUsername.value,
      });
      await db.collection('userlogs').doc(logID).update({
        "username": changeUsername.value,
      });

      await getSingleUser();
      Get.snackbar("Berhasil", "Username Berhasil DiGanti",
          backgroundColor: Colors.green);
      update();
    } catch (e) {
      Get.snackbar("Gagal", "Gagal, Username Sudah Di Gunakan",
          backgroundColor: Colors.red);
    }

    loadC.changeLoading(false);
  }

  changePic(Uint8List? image) async {
    loadC.changeLoading(true);
    statusupload.value = true;
    final ref = db.collection("users").withConverter(
        fromFirestore: User.fromFirestore,
        toFirestore: (User user, _) => user.toFirestore());
    try {
      final data = await ref.doc(authC.authUserID.value).get();
      String? imgLink = data.data()!.img;
      
      if (image != null) {
        await uploadImg(image!, imgLink!);
        if (!statusupload.value) {
          throw Exception('No Image');
        }
        await ref.doc(authC.authUserID.value).update({
        "img": img.value,
      });
      await getSingleUser();
      await authC.loginCheck();
        Get.snackbar("Berhasil", "Data Berhasil Di Perbaharui",
          backgroundColor: Colors.green);
      }
      imageBytes.value = Uint8List(0);
    } catch (e) {
      print(e);
    }
    loadC.changeLoading(false);
  }

  uploadImg(Uint8List imageData, String link) async {
    try {
      if (imageBytes.value != null && imageBytes.value!.isNotEmpty) {
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('/Users')
            .child(DateTime.now().microsecondsSinceEpoch.toString() + ".png");
        await ref.putData(imageData);
        if (link != defaultimg) {
          Reference re = FirebaseStorage.instance.refFromURL(link);
          await re.delete();
        }
        String downloadURL = await ref.getDownloadURL();
        img.value = downloadURL;
      } else {
        statusupload.value = false;
        throw Exception('No Image');
      }
    } catch (e) {
      Get.snackbar("Gagal", "Gambar Gagal Di Upload",
          backgroundColor: Colors.red);
    }
  }

  Future<void> pickImage() async {
    final FileUploadInputElement input = FileUploadInputElement();
    input..accept = 'image/*';
    input.click();
    input.onChange.listen((e) {
      final File file = input.files!.first;
      final FileReader reader = FileReader();

      reader.onLoadEnd.listen((e) {
        imageBytes.value = reader.result as Uint8List?;
      });

      reader.readAsArrayBuffer(file);
    });
    update();
  }

  @override
  void onInit() {
    getUserData();
    showDate(DateTime.now());
    super.onInit();
  }
}
