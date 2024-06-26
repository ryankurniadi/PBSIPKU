import 'dart:html';
import 'dart:ui_web';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './AuthController.dart';
import './LoadingController.dart';
import '../Models/Berita.dart';

class BeritaController extends GetxController {
  final db = FirebaseFirestore.instance;
  final authC = Get.find<AuthController>();
  final loadC = Get.find<LoadingController>();
  final Rx<Uint8List?> imageBytes = Uint8List(0).obs;
  String imgDefault =
      "https://firebasestorage.googleapis.com/v0/b/pbsi-pku.appspot.com/o/Berita%2Fdefault.png?alt=media&token=b0a55b89-53f0-4682-ac11-a449b8b2ca3d";
  var id = "".obs;

  var statusupload = true.obs;
  String table = 'berita';

  var dataBeritaAdmin = [].obs;
  var totalBeritaAdmin = 0.obs;
  var detailBerita = Berita().obs();

  var dataPerAdmin = [].obs;
  var totalDataPerAdmin = 0.obs;

  var img = "".obs;
  var judul = "".obs;
  var isi = "".obs;
  var penulis = "".obs;
  var isImg = false.obs;

  var isNewImg = false.obs;

  var idBerita = "".obs;
  Future<void> pickImage() async {
    try {
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
        isNewImg.value = true;
      });
    } catch (e) {
      print(e);
    }
    update();
  }

  getData() async {
    final ref = db.collection(table).withConverter(
        fromFirestore: Berita.fromFirestore,
        toFirestore: (Berita berita, _) => berita.toFirestore());

    try {
      var data = await ref.orderBy('date', descending: true).limit(7).get();
      if (authC.authpbsi.value != "") {
        data = await ref
            .where('penulis'.toString(),
                whereIn: ['${authC.authpbsi.value}', 'PBSI Pusat'])
            .orderBy('date', descending: true)
            .limit(7)
            .get();
      }
      if (data.docs.isNotEmpty) {
        totalBeritaAdmin.value = data.docs.length;
        dataBeritaAdmin.clear();
        for (var i = 0; i < totalBeritaAdmin.value; i++) {
          String? author = data.docs[i].data().penulis;
          if (data.docs[i].data().penulis == "") {
            author = "PBSI Pusat";
          } else {
            if (author != "PBSI Pusat") {
              final dataPBSI = await db.collection('pbsi').doc(author).get();
              if (dataPBSI != null) {
                author = "${dataPBSI.data()!['nama']}";
              }
            }
          }

          dataBeritaAdmin.add(Berita(
            judul: data.docs[i].data().judul,
            date: data.docs[i].data().date,
            id: data.docs[i].data().id,
            img: data.docs[i].data().img,
            isi: data.docs[i].data().isi,
            penulis: author,
          ));
        }
      } else {
        totalBeritaAdmin.value = 0;
      }
      update();
    } catch (e) {
      print(e);
    }
  }

  addBerita(Uint8List? image) async {
    statusupload.value = true;
    final ref = db.collection(table).withConverter(
        fromFirestore: Berita.fromFirestore,
        toFirestore: (Berita berita, _) => berita.toFirestore());
    img.value = imgDefault;
    try {
      if (isImg.value) {
        try {
          await uploadImg(image!);
          if (!statusupload.value) {
            throw Exception('No Image');
          }
        } catch (e) {
          print(e);
          loadC.changeLoading(false);
          Get.snackbar("Gagal", "Error Pada Gambar",
              backgroundColor: Colors.red);
        }
      }

      if (authC.authpbsi.value == "") {
        penulis.value = "PBSI Pusat";
      } else {
        penulis.value = authC.authpbsi.value;
      }

      await ref.add(
        Berita(
          judul: judul.value,
          isi: isi.value,
          img: img.value,
          penulis: penulis.value,
          date: DateTime.now(),
        ),
      );
      loadC.changeLoading(false);
      Get.back();
      Get.snackbar("Berhasil", "Data Berhasil Di tambah",
          backgroundColor: Colors.green);
      imageBytes.value = Uint8List(0);
      getData();
      getBeritaPerAdmin();
      isi.value = "";
    } catch (e) {
      loadC.changeLoading(false);
      print(e);
    }
  }

  editBerita(String id, Uint8List? image) async {
    statusupload.value = true;
    final ref = db.collection(table).withConverter(
        fromFirestore: Berita.fromFirestore,
        toFirestore: (Berita berita, _) => berita.toFirestore());
    try {
      if (isImg.value) {
        try {
          await uploadImg(image!);
          if (!statusupload.value) {
            throw Exception('No Image');
          }
        } catch (e) {
          print(e);
          loadC.changeLoading(false);
          Get.snackbar("Gagal", "Error Pada Gambar",
              backgroundColor: Colors.red);
        }
      }
      await ref.doc(id).update({
        "judul" : judul.value,
        "isi" : isi.value,
        "img" : img.value,
      });

      loadC.changeLoading(false);
      Get.back();
      Get.snackbar("Berhasil", "Data Berhasil Di tambah",
          backgroundColor: Colors.green);
      imageBytes.value = Uint8List(0);
      getData();
      getBeritaPerAdmin();
      isi.value = "";
    } catch (e) {
      loadC.changeLoading(false);
      print(e);
    }
  }

  getDetailBerita(String id)async{

    final ref = db.collection(table).withConverter(
        fromFirestore: Berita.fromFirestore,
        toFirestore: (Berita berita, _) => berita.toFirestore());
    try {
      final data = await ref.doc(id).get();
      if(data != null){
        detailBerita = data.data()!;
        update();
      }
    } catch (e) {
      print(e);
    }
  }

  uploadImg(Uint8List imageData) async {
    try {
      if (imageBytes.value != null && imageBytes.value!.isNotEmpty) {
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('/Berita')
            .child("${DateTime.now().microsecondsSinceEpoch}.png");
        await ref.putData(imageData);
        if (isNewImg.value) {
          if (img.value != imgDefault) {
            Reference refs = FirebaseStorage.instance.refFromURL(img.value);
            await refs.delete();
          }
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

  editImgChanger(bool isImgChange) {
    isImg.value = isImgChange;
    update();
  }

  getBeritaPerAdmin() async {
    final ref = db.collection(table).withConverter(
        fromFirestore: Berita.fromFirestore,
        toFirestore: (Berita berita, _) => berita.toFirestore());

    String author = authC.authpbsi.value;
    if (author == "") {
      author = "PBSI Pusat";
    }

    try {
      final data = await ref
          .where('penulis'.toString(), isEqualTo: author)
          .orderBy('date', descending: true)
          .get();
      if (data.docs.isNotEmpty) {
        dataPerAdmin.clear();
        totalDataPerAdmin.value = data.docs.length;

        for (var i = 0; i < totalDataPerAdmin.value; i++) {
          dataPerAdmin.add(Berita(
            judul: data.docs[i].data().judul,
            date: data.docs[i].data().date,
            id: data.docs[i].data().id,
            img: data.docs[i].data().img,
            isi: data.docs[i].data().isi,
            penulis: author,
          ));
        }
      }

      update();
    } catch (e) {
      print(e);
    }
  }

  deleteBerita(String id, String img) async {
    final ref = db.collection(table).withConverter(
        fromFirestore: Berita.fromFirestore,
        toFirestore: (Berita berita, _) => berita.toFirestore());

    try {
      if (img != imgDefault) {
        Reference refs = FirebaseStorage.instance.refFromURL(img);
        await refs.delete();
      }
      await ref.doc(id).delete();
      await getData();
      await getBeritaPerAdmin();
      
      Get.back();
      Get.snackbar("Berhasil", "Data Berhasil Di Hapus",
          backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar("Gagal", "Data Gagal Di Hapus", backgroundColor: Colors.red);
      print(e);
    }
  }

  getSingleBerita(String id) async {
    final ref = db.collection(table).withConverter(
        fromFirestore: Berita.fromFirestore,
        toFirestore: (Berita berita, _) => berita.toFirestore());
    try {
      final data = await ref.doc(id).get();
      img.value = data.data()!.img!;
      penulis.value = data.data()!.penulis!;
      judul.value = data.data()!.judul!;
      isi.value = data.data()!.isi!;
      idBerita.value = id;
      update();
    } catch (e) {
      print(e);
    }
  }

  @override
  void onInit() {
    super.onInit();
  }
}
