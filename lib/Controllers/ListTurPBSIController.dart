import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Api/SendNotif.dart';
import '../Models/Peserta.dart';
import '../Models/User.dart';
import '../Models/Turnamen.dart';
import './LoadingController.dart';

class ListTurPBSIController extends GetxController {
  final db = FirebaseFirestore.instance;
  final loadC = Get.find<LoadingController>();
  var dataTurnamen = [].obs;
  var ket = "".obs;
  var table = 'turnamen';

  var pesertaBelumTerdaftar = [].obs;
  var pesertaBelumTerdaftar2 = [].obs;
  var namaUser2 = "".obs;

  var pemain1 = "".obs;
  var pemain2 = "".obs;
  var isPemain1Selected = false.obs;
  var isAllPemainSelected = false.obs;

  getData() async {
    ket.value = "";
    final ref = db.collection(table).withConverter(
        fromFirestore: Turnamen.fromFirestore,
        toFirestore: (Turnamen turnamen, _) => turnamen.toFirestore());
    try {
      final docSnap = await ref
          .where('status'.toString(), isEqualTo: "Disetujui")
          .where('tipe'.toString(), isEqualTo: "Publik")
          .orderBy('date', descending: true)
          .get();
      if (docSnap.docs.isNotEmpty) {
        dataTurnamen.clear();
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
      }
      update();
    } catch (e) {
      print(e);
    }
  }

  checkUserTerdaftar(String idPBSI, String idTur, String level) async {
    namaUser2.value = "";
    final refPeserta = db.collection("peserta").withConverter(
        fromFirestore: Peserta.fromFirestore,
        toFirestore: (Peserta peserta, _) => peserta.toFirestore());
    final refUser = db.collection("users").withConverter(
        fromFirestore: User.fromFirestore,
        toFirestore: (User user, _) => user.toFirestore());
    pesertaBelumTerdaftar.clear();
    try {
      final dataUsr = await refUser
          .where('pbsi'.toString(), isEqualTo: idPBSI)
          .where('skill'.toString(), isEqualTo: level)
          .get();
      if (dataUsr.docs.isNotEmpty) {
        for (var i = 0; i < dataUsr.docs.length; i++) {
          String idUserFromDB = dataUsr.docs[i].id;
          final checkDaftar1 = await refPeserta
              .where('idTurnamen'.toString(), isEqualTo: idTur)
              .where('idPBSI'.toString(), isEqualTo: idPBSI)
              .where('idUser'.toString(), isEqualTo: idUserFromDB)
              .where('status'.toString(), isEqualTo: "Disetujui")
              .get();
          final checkDaftar2 = await refPeserta
              .where('idTurnamen'.toString(), isEqualTo: idTur)
              .where('idPBSI'.toString(), isEqualTo: idPBSI)
              .where('idUser2'.toString(), isEqualTo: idUserFromDB)
              .where('status'.toString(), isEqualTo: "Disetujui")
              .get();

          if (checkDaftar1.docs.isEmpty && checkDaftar2.docs.isEmpty) {
            pesertaBelumTerdaftar.add(User(
              nama: dataUsr.docs[i].data().nama,
              id: dataUsr.docs[i].id,
            ));
          }
        }
      }
      update();
    } catch (e) {
      print(e);
    }
  }

  hideSelectedUser(String namaUser) {
    //pesertaBelumTerdaftar2.clear();
    pesertaBelumTerdaftar2.assignAll(
        pesertaBelumTerdaftar.where((user) => user.id != namaUser).toList());
    update();
  }

  daftarkanUser(String turID, String idPBSInya) async {
    loadC.changeLoading(true);
    final ref = db.collection("peserta").withConverter(
        fromFirestore: Peserta.fromFirestore,
        toFirestore: (Peserta peserta, _) => peserta.toFirestore());
    var data = Peserta(
        idPBSI: idPBSInya,
        idTurnamen: turID,
        idUser: pemain1.value,
        idUser2: pemain2.value,
        pembayaran: "Belum Lunas",
        status: "Disetujui");

    try {
      final tur = await db.collection('turnamen').doc(turID).get();
      int? limit = tur.data()!['limit'];

      final terdaftar = await ref
          .where('idTurnamen'.toString(), isEqualTo: turID)
          .where('idPBSI'.toString(), isEqualTo: idPBSInya)
          .where('status'.toString(), isEqualTo: "Disetujui")
          .get();
          //kesini nanati
      if (pemain1.value != "" && pemain2.value != "") {
        Get.back();
        if (terdaftar.docs.length < limit!) {
          await ref.add(data);

          Get.snackbar("Berhasil", "Anda Berhasil Mendaftarkan Anggota Anda",
              backgroundColor: Colors.green);
          final tabelUser = db.collection("users").withConverter(
              fromFirestore: User.fromFirestore,
              toFirestore: (User user, _) => user.toFirestore());
          ;
          final getUserData = await tabelUser.doc(pemain1.value).get();
          String? tokenUser = getUserData.data()!.token;
          final tabelUser2 = db.collection("users").withConverter(
              fromFirestore: User.fromFirestore,
              toFirestore: (User user, _) => user.toFirestore());
          ;
          final getUserData2 = await tabelUser2.doc(pemain2.value).get();
          String? tokenUser2 = getUserData2.data()!.token;
          //Kirim Notif
          SendNotif().sendNotif(tokenUser!, "Pendaftaran Turnamen",
              "Anda Terdaftar di Turnamen ${tur.data()!['nama']}");
          SendNotif().sendNotif(tokenUser2!, "Pendaftaran Turnamen",
              "Anda Terdaftar di Turnamen ${tur.data()!['nama']}");
        } else {
          Get.snackbar("Gagal", "Maksimal Perwakilan sudah terpenuhi",
              backgroundColor: Colors.red);
        }
      }
      else{
        isAllPemainSelected.value = false;
      }
      update();
    } catch (e) {
      print(e);
    }
    loadC.changeLoading(false);
  }

  player1SelectNotify(bool isSelect) {
    isPemain1Selected.value = isSelect;
    if (isSelect) {
      pemain2.value = "";
    }
    update();
  }

  @override
  void onInit() {
    getData();
    super.onInit();
  }
}
