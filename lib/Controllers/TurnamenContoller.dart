import 'dart:html';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../Models/Turnamen.dart';
import './LoadingController.dart';

class TurnamenController extends GetxController {
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
  var tipe = "".obs;
  var pbsi = "".obs;
  var dataTurnamen = [].obs;
  var dataTurnamen2 = [].obs;
  var date = DateTime.now().obs;
  var biaya = 0.obs;
  var date2 = DateTime.now().obs;
  var dateShow = "".obs;
  var dateShow2 = "".obs;
  var statusupload = true.obs;

  var turID = "".obs;
  RxList dataSatuTur = [].obs;
  var isEditImg = false.obs;

  final loadC = Get.find<LoadingController>();

  @override
  void onInit() {
    getData();
    getData2();
    showDate(DateTime.now());
    showDate2(DateTime.now());
    super.onInit();
  }

  getData() async {
    ket.value = "";
    final ref = db.collection(table).withConverter(
        fromFirestore: Turnamen.fromFirestore,
        toFirestore: (Turnamen turnamen, _) => turnamen.toFirestore());
    try {
      final docSnap = await ref.where('status'.toString(),isEqualTo: "Disetujui").where('tipe'.toString(), isEqualTo: "Publik").orderBy('date', descending: true).get();
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
            biaya: docSnap.docs[i].data().biaya,
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
  getData2() async {
    ket.value = "";
    final ref = db.collection(table).withConverter(
        fromFirestore: Turnamen.fromFirestore,
        toFirestore: (Turnamen turnamen, _) => turnamen.toFirestore());
    try {
      final docSnap = await ref.where('status'.toString(),isEqualTo: "Pending").orderBy('date', descending: true).get();
      if (docSnap.docs.isNotEmpty) {
        dataTurnamen2.clear();
        ajutotalTur.value = docSnap.docs.length;
        for (var i = 0; i < docSnap.docs.length; i++) {
          dataTurnamen2.add(Turnamen(
            id: docSnap.docs[i].id,
            nama: docSnap.docs[i].data().nama,
            img: docSnap.docs[i].data().img,
            biaya: docSnap.docs[i].data().biaya,
            ket: docSnap.docs[i].data().ket,
            status: docSnap.docs[i].data().status,
            date: docSnap.docs[i].data().date,
            level: docSnap.docs[i].data().level,
            batas: docSnap.docs[i].data().batas,
            pbsi: docSnap.docs[i].data().pbsi,
            limit: docSnap.docs[i].data().limit,
            tipe: docSnap.docs[i].data().tipe,
            lokasi: docSnap.docs[i].data().lokasi,
          ));
        }
      } else {
        dataTurnamen2.clear();
        ajutotalTur.value = 0;
      }
      update();
    } catch (e) {
      print(e);
    }
  }

  void addData(Uint8List image) async {
    statusupload.value = true;
    final ref = db.collection(table).withConverter(
        fromFirestore: Turnamen.fromFirestore,
        toFirestore: (Turnamen turnamen, _) => turnamen.toFirestore());
    try {
      await uploadImg(image);
      if (!statusupload.value) {
        throw Exception('No Image');
      }

      if(pbsi.value == ""){
        pbsi.value = "PBSI Pusat";
      }
      await ref.add(
        Turnamen(
          nama: nama.value,
          date: date.value,
          status: "Disetujui",
          ket: ket.value,
          level: level.value,
          tipe: "Publik",
          img: link.value,
          biaya: biaya.value,
          kontak: kontak.value,
          pbsi: pbsi.value,
          limit: limit.value,
          batas: date2.value,
          lokasi: lokasi.value,
        ),
      );
      loadC.changeLoading(false);
      Get.back();
      Get.snackbar("Berhasil", "Data Berhasil Di tambah",
          backgroundColor: Colors.green);
      await getData();
      imageBytes.value = Uint8List(0);
    } catch (e) {
      loadC.changeLoading(false);
      Get.snackbar("Gagal", "Data Gagal Di Tambah",
          backgroundColor: Colors.red);
    }
  }

  pengajuanTur(String stat)async{
    loadC.changeLoading(true);
    final ref = db.collection(table).withConverter(
        fromFirestore: Turnamen.fromFirestore,
        toFirestore: (Turnamen turnamen, _) => turnamen.toFirestore());
    try {
      await ref.doc(turID.value).update({
        "status": stat,
      });
      loadC.changeLoading(false);
      Get.snackbar("Berhasil", "Data Berhasil $stat",
          backgroundColor: Colors.green);
      await getData();
      await getData2();
    } catch (e) {
      loadC.changeLoading(false);
      print(e);
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
        'level': level.value,
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

  deleteData(String id, String img) async {
    try {
      Reference ref = FirebaseStorage.instance.refFromURL(img);
      await db.collection(table).doc(id).delete();
      await ref.delete();
      Get.back();
      Get.snackbar("Berhasil", "Data Berhasil Di Hapus",
          backgroundColor: Colors.green);
      getData();
    } catch (e) {
      Get.snackbar("Gagal", "Data Gagal Di Hapus", backgroundColor: Colors.red);
    }
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
      setDate(docSnap['date'].toDate());
      setDate2(docSnap['batas'].toDate());

      date.value = docSnap['date'].toDate();
      date2.value = docSnap['batas'].toDate();
      dataSatuTur.add(Turnamen(
        nama: docSnap['nama'],
        level: docSnap['level'],
        biaya: docSnap['biaya'],
        lokasi: docSnap['lokasi'],
        img: docSnap['img'],
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
}
