import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/get_rx.dart';

import '../Api/SendNotif.dart';
import '../Models/User.dart';
import './LoadingController.dart';
import '../Models/Peserta.dart';
import '../Models/PesertaView.dart';

class PesertaTerdaftarController extends GetxController {
  final db = FirebaseFirestore.instance;

  final loadC = Get.find<LoadingController>();
  RxList<Pesertaview> dataTerdaftar = <Pesertaview>[].obs;
  var totalPeserta = 0.obs;

  getData(String idTur) async {
    loadC.changeLoading(true);
    final ref = db.collection("peserta").withConverter(
        fromFirestore: Peserta.fromFirestore,
        toFirestore: (Peserta peserta, _) => peserta.toFirestore());
    try {
      final docSNap = await ref
          .where('idTurnamen'.toString(), isEqualTo: idTur)
          .where('status'.toString(), isEqualTo: "Disetujui")
          .orderBy('idPBSI')
          .get();
      totalPeserta.value = docSNap.docs.length;
      if (docSNap.docs.isNotEmpty) {
        dataTerdaftar.clear();
        for (var i = 0; i < totalPeserta.value; i++) {
          final user = await db
              .collection('users')
              .doc(docSNap.docs[i].data().idUser)
              .get();
          final user2 = await db
              .collection('users')
              .doc(docSNap.docs[i].data().idUser2)
              .get();
          final tur = await db
              .collection('turnamen')
              .doc(docSNap.docs[i].data().idTurnamen)
              .get();
          final pbsi = await db
              .collection('pbsi')
              .doc(docSNap.docs[i].data().idPBSI)
              .get();
          dataTerdaftar.add(Pesertaview(
            id: docSNap.docs[i].data().id,
            idTurnamen: docSNap.docs[i].data().idTurnamen,
            idUser: docSNap.docs[i].data().idUser,
            nama: user.data()!['nama'],
            nama2: user2.data()!['nama'],
            email: user.data()!['email'],
            email2: user2.data()!['email'],
            hp: user.data()!['hp'],
            hp2: user2.data()!['hp'],
            turnamen: tur.data()!['nama'],
            status: docSNap.docs[i].data().status,
            level: tur.data()!['level'],
            namaPBSI: pbsi.data()!['nama'],
            idPBSI: docSNap.docs[i].data().idPBSI,
            pembayaran: docSNap.docs[i].data().pembayaran,
          ));
        }
      } else {
        totalPeserta.value = 0;
      }

      update();
    } catch (e) {
     
      print(e);
    }
     loadC.changeLoading(false);
  }

  lunasiPendaftaran(String id, String IDtur) async {
    final ref = db.collection("peserta").withConverter(
        fromFirestore: Peserta.fromFirestore,
        toFirestore: (Peserta peserta, _) => peserta.toFirestore());

    try {
      await ref.doc(id).update({'pembayaran': "Lunas"});
      getData(IDtur);

      final data = await ref.doc(id).get();
      final tabelUser = db.collection("users").withConverter(
          fromFirestore: User.fromFirestore,
          toFirestore: (User user, _) => user.toFirestore());
      ;
      final getUserData = await tabelUser.doc(data.data()!.idUser).get();
      String? tokenUser = getUserData.data()!.token;
      final tabelUser2 = db.collection("users").withConverter(
          fromFirestore: User.fromFirestore,
          toFirestore: (User user, _) => user.toFirestore());
      ;
      final getUserData2 = await tabelUser2.doc(data.data()!.idUser2).get();
      String? tokenUser2 = getUserData2.data()!.token;
      //Kirim Notif
      final tur = await db.collection('turnamen').doc(data.data()!.idTurnamen).get();
      SendNotif().sendNotif(tokenUser!, "Pembayaran Diverifikasi",
          "Pembayaran pada ${tur.data()!['nama']} sudah Lunas");
      SendNotif().sendNotif(tokenUser2!, "Pembayaran Diverifikasi",
          "Pembayaran pada ${tur.data()!['nama']} sudah Lunas");

      Get.snackbar("Berhasil", "Berhasil meng-update pembayaran peserta",
          backgroundColor: Colors.green);
      loadC.changeLoading(false);
    } catch (e) {
      loadC.changeLoading(false);
      Get.snackbar("Gagal", "Gagal meng-update pembayaran peserta",
          backgroundColor: Colors.red);
      print(e);
    }
  }

  deletePeserta(String id, String idTur) async {
    loadC.changeLoading(true);
    final ref = db.collection("peserta").withConverter(
        fromFirestore: Peserta.fromFirestore,
        toFirestore: (Peserta peserta, _) => peserta.toFirestore());

    try {
      await ref.doc(id).delete();
      getData(idTur);

      Get.snackbar("Berhasil", "Peserta Berhasil Dihapus",
          backgroundColor: Colors.green);
      loadC.changeLoading(false);
    } catch (e) {
      loadC.changeLoading(false);
      Get.snackbar("Gagal", "Peserta Gagal DIhapus",
          backgroundColor: Colors.red);
      print(e);
    }
  }
}
