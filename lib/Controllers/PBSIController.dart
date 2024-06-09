import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/PBSI.dart';

class PBSIController extends GetxController {
  final db = FirebaseFirestore.instance;
  var dataPBSI = [].obs;
  var totalPBSI = 0.obs;
  var nama = "".obs;
  var id = "".obs;

  void getData() async {
    try {
      final ref = db.collection("pbsi").withConverter(
          fromFirestore: PBSI.fromFirestore,
          toFirestore: (PBSI pbsi, _) => pbsi.toFirestore());
      final docSnap = await ref.orderBy('nama').get();
      if (docSnap.docs.isNotEmpty) {
        totalPBSI.value = docSnap.docs.length;
        dataPBSI.clear();
        for (var i = 0; i < docSnap.docs.length; i++) {
          dataPBSI.add(
              PBSI(nama: docSnap.docs[i].data().nama, id: docSnap.docs[i].id));
        }
      } else {
        totalPBSI.value = 0;
        dataPBSI.clear();
      }
      update();
    } catch (e) {
      print(e);
    }
  }

  void addData() async {
    final pbsi = PBSI(nama: nama.value);
    final ref = db.collection("pbsi").withConverter(
        fromFirestore: PBSI.fromFirestore,
        toFirestore: (PBSI pbsi, _) => pbsi.toFirestore());
    try {
      await ref.add(pbsi);
      getData();
      Get.back();
      Get.snackbar("Berhasil", "Data Berhasil Di tambah",
          backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar("Gagal", "Data Gagal Di Tambah",
          backgroundColor: Colors.red);
    }
  }

  void deleteData(String id) async {
    try {
      await db.collection('pbsi').doc(id).delete();
      getData();
      Get.back();
      Get.snackbar("Berhasil", "Data Berhasil Di Hapus",
          backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar("Gagal", "Data Gagal Di Hapus", backgroundColor: Colors.red);
    }
  }

  void editData(String id) async {
    try {
      await db.collection('pbsi').doc(id).update({
        'nama': nama.value,
      });
      getData();
      Get.back();
      Get.snackbar("Berhasil", "Data Berhasil Di Rubah",
          backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar("Gagal", "Data Gagal Di Rubah", backgroundColor: Colors.red);
    }
  }

  @override
  void onInit() {
    getData();
    super.onInit();
  }
}
