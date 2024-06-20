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
  var biaya = 0.obs;
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
            biaya: docSnap.docs[i].data().biaya,
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

      if (tipeRadio.value == "Publik") {
        stat = "Pending";
      } else {
        limit.value = 9999;
        stat = "Disetujui";
        tipeRadio.value = authC.authpbsi.value;
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
          biaya: biaya.value,
          limit: limit.value,
          batas: date2.value,
          lokasi: lokasi.value,
        ),
      );
      loadC.changeLoading(false);
      Get.back();
      Get.snackbar("Berhasil", "Pengajuan Berhasil Didaftarkan",
          backgroundColor: Colors.green);
      await getData();
      imageBytes.value = Uint8List(0);
    } catch (e) {
      loadC.changeLoading(false);
      Get.snackbar("Gagal", "Data Gagal Di Tambah",
          backgroundColor: Colors.red);
    }
  }

  editData(Uint8List? image) async {
    loadC.changeLoading(true);
    Turnamen data = dataSatuTur[0];
    statusupload.value = true;
    final ref = db.collection(table).withConverter(
        fromFirestore: Turnamen.fromFirestore,
        toFirestore: (Turnamen turnamen, _) => turnamen.toFirestore());
    link.value = data.img!;
    //print(image);
    if (isEditImg.value) {
      //print("Kesini");
      try {
        await uploadImg(image!);
        if (!statusupload.value) {
          throw Exception('No Image');
        }
      } catch (e) {
        print(e);
        loadC.changeLoading(false);
        Get.snackbar("Gagal", "Error Pada Gambar", backgroundColor: Colors.red);
      }
    }

    try {
      await ref.doc(turID.value).update({
        'nama': nama.value,
        'date': date.value,
        'ket': ket.value,
        'kontak':kontak.value,
        'biaya':biaya.value,
        'img': link.value,
        'limit':limit.value,
        'batas': date2.value,
        'lokasi': lokasi.value,
      });
      loadC.changeLoading(false);
      Get.back();
      Get.snackbar("Berhasil", "Data Berhasil Di Perbaharui",
          backgroundColor: Colors.green);
      await getData();
      imageBytes.value = Uint8List(0);
      isEditImg.value = false;
    } catch (e) {
      isEditImg.value = false;
      loadC.changeLoading(false);
      Get.snackbar("Gagal", "Data Gagal Di Perbaharui",
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

  setDate(DateTime tgl) {
    date.value = tgl;
    showDate(tgl);
    update();
  }

  setDate2(DateTime tgl) {
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

  getSingleTur() async {
    final ref = db.collection(table).withConverter(
        fromFirestore: Turnamen.fromFirestore,
        toFirestore: (Turnamen turnamen, _) => turnamen.toFirestore());
    try {
      dataSatuTur.clear();
      final docSnap = await ref.doc(turID.value).get();
      await setDate(docSnap['date'].toDate());
      await setDate2(docSnap['batas'].toDate());
      dataSatuTur.add(Turnamen(
        nama: docSnap['nama'],
        level: docSnap['level'],
        biaya: docSnap['biaya'],
        lokasi: docSnap['lokasi'],
        img: docSnap['img'],
        tipe: docSnap['tipe'],
        limit: docSnap['limit'],
        batas: docSnap['batas'].toDate(),
        date: docSnap['date'].toDate(),
        ket: docSnap['ket'],
        kontak: docSnap['kontak'],
        pbsi: docSnap['pbsi'],
        status: docSnap['status'],
      ));
      update();
    } catch (e) {
      print(e);
    }
  }

  editImgchange(bool val) {
    isEditImg.value = val;
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
