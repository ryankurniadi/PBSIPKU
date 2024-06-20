import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './LoadingController.dart';
import '../Models/Peserta.dart';
import '../Models/PesertaView.dart';

class PesertaTerdaftarController extends GetxController {
  final db = FirebaseFirestore.instance;

  final loadC = Get.find<LoadingController>();
  var dataTerdaftar = [].obs;
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
            email: user.data()!['email'],
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
      loadC.changeLoading(false);
      update();
    } catch (e) {
      loadC.changeLoading(false);
      print(e);
    }
  }

  lunasiPendaftaran(String id, String IDtur)async{
    final ref = db.collection("peserta").withConverter(
        fromFirestore: Peserta.fromFirestore,
        toFirestore: (Peserta peserta, _) => peserta.toFirestore());
      
    try {
      await ref.doc(id).update({
        'pembayaran' :"Lunas"
      });
      getData(IDtur);
      
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
