import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Api/SendNotif.dart';
import '../Models/Peserta.dart';
import '../Models/User.dart';
import '../Models/PesertaView.dart';
import './LoadingController.dart';

class PesertaTurController extends GetxController {
  final db = FirebaseFirestore.instance;
  final loadC = Get.find<LoadingController>();


  var dataPeserta = [].obs;
  var totalPeserta = 0.obs;

  var klik = false.obs;

  String tabel = "peserta";

  getDataPBSI(String idPBSI) async {
    loadC.changeLoading(true);
    final ref = db.collection("peserta").withConverter(
        fromFirestore: Peserta.fromFirestore,
        toFirestore: (Peserta peserta, _) => peserta.toFirestore());
    try {
      final docSNap = await ref
          .where('idPBSI'.toString(), isEqualTo: idPBSI)
          .orderBy('status', descending: true)
          .get();
      totalPeserta.value = docSNap.docs.length;
      if (docSNap.docs.isNotEmpty) {
        dataPeserta.clear();
        for (var i = 0; i < totalPeserta.value; i++) {
          final user = await db
              .collection('users')
              .doc(docSNap.docs[i].data().idUser)
              .get();
          final tur = await db
              .collection('turnamen')
              .doc(docSNap.docs[i].data().idTurnamen)
              .get();
          dataPeserta.add(Pesertaview(
            id: docSNap.docs[i].data().id,
            idTurnamen: docSNap.docs[i].data().idTurnamen,
            idUser: docSNap.docs[i].data().idUser,
            nama: user.data()!['nama'],
            email: user.data()!['email'],
            turnamen: tur.data()!['nama'],
            status: docSNap.docs[i].data().status,
            level: tur.data()!['level'],
            idPBSI: docSNap.docs[i].data().idPBSI,
          ));
        }
      } else {
        totalPeserta.value = 0;
      }
      loadC.changeLoading(false);
      update();
    } catch (e) {
      loadC.changeLoading(false);
      print(e);
    }
  }

  tolakPengajuan(String id, String idPBSI, String idTur) async {
    loadC.changeLoading(true);
    klik.value = true;
    final ref = db.collection("peserta").withConverter(
        fromFirestore: Peserta.fromFirestore,
        toFirestore: (Peserta peserta, _) => peserta.toFirestore());
    try {
      await ref.doc(id).update({"status": "Ditolak"});
      final tur = await db.collection('turnamen').doc(idTur).get();
      await getDataPBSI(idPBSI);
      klik.value = false;
      loadC.changeLoading(false);
      Get.snackbar("Berhasil", "Pengajuan Berhasil Ditolak",
          backgroundColor: Colors.green);
              final getIDUser = await ref.doc(id).get();
        String? idUser = getIDUser.data()!.idUser;
        final tabelUser = db.collection("users").withConverter(
            fromFirestore: User.fromFirestore,
            toFirestore: (User user, _) => user.toFirestore());
        ;
        final getUserData = await tabelUser.doc(idUser).get();
        String? tokenUser = getUserData.data()!.token;
        //Kirim Notif
        SendNotif().sendNotif(tokenUser!, "Pengajuan Ditolak", "Pengajuan Pendaftaranmu di Turnamen ${tur.data()!['nama']} Ditolak");

    } catch (e) {
      loadC.changeLoading(false);
      klik.value = false;
      Get.snackbar("Gagal", "Gagal Melakukan Persetujuan",
          backgroundColor: Colors.red);
      print(e);
    }
  }

  setujuiPengajuan(String id, String idPBSI, String idTur, String idUser) async {
    loadC.changeLoading(true);
    klik.value = true;
    final ref = db.collection("peserta").withConverter(
        fromFirestore: Peserta.fromFirestore,
        toFirestore: (Peserta peserta, _) => peserta.toFirestore());
    try {
      //cek max perwakilan turnamen
      final tur = await db.collection('turnamen').doc(idTur).get();
      int? limit = tur.data()!['limit'];
      //cek yang terdaftar
      final terdaftar = await ref
          .where('idTurnamen'.toString(), isEqualTo: idTur)
          .where('idPBSI'.toString(), isEqualTo: idPBSI)
          .where('status'.toString(), isEqualTo: "Disetujui")
          .get();
      if (terdaftar.docs.length < limit!) {
        await ref.doc(id).update({"status": "Disetujui"});
        Get.snackbar("Berhasil", "Pengajuan Berhasil Disetujui",
            backgroundColor: Colors.green);
        final tabelUser = db.collection("users").withConverter(
            fromFirestore: User.fromFirestore,
            toFirestore: (User user, _) => user.toFirestore());
        ;
        final getUserData = await tabelUser.doc(idUser).get();
        String? tokenUser = getUserData.data()!.token;
        //Kirim Notif
        SendNotif().sendNotif(tokenUser!, "Pengajuan Disetujui", "Pengajuan Pendaftaranmu di Turnamen ${tur.data()!['nama']} Disetujui");

      } else {
        Get.snackbar("Gagal", "Maksimal Perwakilan sudah terpenuhi",
            backgroundColor: Colors.red);
      }

      await getDataPBSI(idPBSI);
      klik.value = false;
      loadC.changeLoading(false);
    } catch (e) {
      loadC.changeLoading(false);
      klik.value = false;
      Get.snackbar("Gagal", "Gagal Melakukan Persetujuan",
          backgroundColor: Colors.red);
      print(e);
    }
  }

  @override
  void onInit() {
    super.onInit();
  }
}
