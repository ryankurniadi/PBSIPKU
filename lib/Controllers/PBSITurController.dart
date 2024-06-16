import 'dart:html';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../Models/Turnamen.dart';
import './LoadingController.dart';
import './AuthController.dart';

class PBSITurController extends GetxController {
  final db = FirebaseFirestore.instance;
  final Rx<Uint8List?> imageBytes = Uint8List(0).obs;
  var id = "".obs;
  var img = "".obs;
  var ket = "".obs;
  var level = "Level A".obs;
  var link = "".obs;
  var nama = "".obs;
  var kontak = "".obs;
  var status = "".obs;
  var table = 'turnamen';
  var lokasi = "".obs;
  var totalTur = 0.obs;
  var ajutotalTur = 0.obs;
  var limit = 0.obs;
  var tipe = "Publik".obs;
  var pbsi = "".obs;
  var dataTurnamen = [].obs;
  var dataTurnamen2 = [].obs;
  var date = DateTime.now().obs;
  var date2 = DateTime.now().obs;
  var dateShow = "".obs;
  var tipeRadio = "Publik".obs;
  var dateShow2 = "".obs;
  var statusupload = true.obs;

  var turID = "".obs;
  var dataSatuTur = [].obs;
  var isEditImg = false.obs;

  final loadC = Get.find<LoadingController>();
  final authC = Get.find<AuthController>();

  initPBSI() {
    pbsi.value = authC.authpbsi.value;
  }

  getData() async {
    ket.value = "";
    final ref = db.collection(table).withConverter(
        fromFirestore: Turnamen.fromFirestore,
        toFirestore: (Turnamen turnamen, _) => turnamen.toFirestore());
    try {
      final docSnap = await ref
          .where('pbsi'.toString(), isEqualTo: authC.authpbsi.value)
          .orderBy('date', descending: true)
          .get();
      if (docSnap.docs.isNotEmpty) {
        dataTurnamen.clear();
        totalTur.value = docSnap.docs.length;
        for (var i = 0; i < docSnap.docs.length; i++) {
          dataTurnamen.add(Turnamen(
            id: docSnap.docs[i].id,
            nama: docSnap.docs[i].data().nama,
            img: docSnap.docs[i].data().img,
            ket: docSnap.docs[i].data().ket,
            status: docSnap.docs[i].data().status,
            date: docSnap.docs[i].data().date,
            level: docSnap.docs[i].data().level,
            batas: docSnap.docs[i].data().batas,
            pbsi: docSnap.docs[i].data().pbsi,
            tipe: docSnap.docs[i].data().tipe,
            limit: docSnap.docs[i].data().limit,
            lokasi: docSnap.docs[i].data().lokasi,
          ));
        }
      } else {
        dataTurnamen.clear();
        totalTur.value = 0;
      }
      update();
    } catch (e) {
      print(e);
    }
  }

  addData(Uint8List image) async {
    statusupload.value = true;
    final ref = db.collection(table).withConverter(
        fromFirestore: Turnamen.fromFirestore,
        toFirestore: (Turnamen turnamen, _) => turnamen.toFirestore());
    try {
      await uploadImg(image);
      if (!statusupload.value) {
        throw Exception('No Image');
      }
      String? stat;

      if (tipe.value == "Publik") {
        stat = "Pending";
      } else {
        stat = "Disetujui";
      }
      await ref.add(
        Turnamen(
          nama: nama.value,
          date: date.value,
          status: stat,
          ket: ket.value,
          level: level.value,
          tipe: tipeRadio.value,
          img: link.value,
          kontak: kontak.value,
          pbsi: pbsi.value,
          limit: limit.value,
          batas: date2.value,
          lokasi: lokasi.value,
        ),
      );
      loadC.changeLoading(false);
      Get.back();
      Get.snackbar("Berhasil", "Pengajuan Berhasil Didaftarkan",
          backgroundColor: Colors.green);
      //await getData();
      imageBytes.value = Uint8List(0);
    } catch (e) {
      loadC.changeLoading(false);
      Get.snackbar("Gagal", "Data Gagal Di Tambah",
          backgroundColor: Colors.red);
    }
  }

  uploadImg(Uint8List imageData) async {
    try {
      if (imageBytes.value != null && imageBytes.value!.isNotEmpty) {
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('/Turnamen')
            .child(DateTime.now().microsecondsSinceEpoch.toString() + ".png");
        await ref.putData(imageData);
        if (isEditImg.value) {
          Reference re = FirebaseStorage.instance.refFromURL(link.value);
          await re.delete();
        }
        String downloadURL = await ref.getDownloadURL();
        link.value = downloadURL;
      } else {
        statusupload.value = false;
        throw Exception('No Image');
      }
    } catch (e) {
      Get.snackbar("Gagal", "Gambar Gagal Di Upload",
          backgroundColor: Colors.red);
    }
  }

  changeTipe(String tip) {
    tipeRadio.value = tip;
    update();
  }

  void setDate(DateTime tgl) {
    date.value = tgl;
    showDate(tgl);
    update();
  }

  void setDate2(DateTime tgl) {
    date2.value = tgl;
    showDate2(tgl);
    update();
  }

  void showDate(DateTime tgl) {
    dateShow.value = "${DateFormat("EEEE, dd MMMM yyyy", "id").format(tgl)}";
    update();
  }

  void showDate2(DateTime tgl) {
    dateShow2.value = "${DateFormat("EEEE, dd MMMM yyyy", "id").format(tgl)}";
    update();
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
    initPBSI();
    getData();
    showDate(DateTime.now());
    showDate2(DateTime.now());
    super.onInit();
  }
}
