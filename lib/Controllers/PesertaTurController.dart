import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/Peserta.dart';
import '../Models/PesertaView.dart';

class PesertaTurController extends GetxController{
  final db = FirebaseFirestore.instance;

  var dataPeserta = [].obs;
  var totalPeserta = 0.obs;


  String tabel = "peserta";

  getDataPBSI(String idPBSI)async{
    final ref = db.collection("peserta").withConverter(
        fromFirestore: Peserta.fromFirestore,
        toFirestore: (Peserta peserta, _) => peserta.toFirestore());
    try {
      final docSNap = await ref.where('idPBSI'.toString(), isEqualTo: idPBSI).get();
      totalPeserta.value = docSNap.docs.length;
      if(docSNap.docs.isNotEmpty){
        dataPeserta.clear();
        for (var i = 0; i < totalPeserta.value; i++) {
          final user = await db.collection('users').doc(docSNap.docs[i].data().idUser).get();
          final tur = await db.collection('turnamen').doc(docSNap.docs[i].data().idTurnamen).get();
          dataPeserta.add(Pesertaview(
            id: docSNap.docs[i].data().id,
            idTurnamen: docSNap.docs[i].data().idTurnamen,
            idUser: docSNap.docs[i].data().idUser,
            nama: user.data()!['nama'],
            turnamen: tur.data()!['nama'],
            status: docSNap.docs[i].data().status,
            level: tur.data()!['level'],
          ));
        }
      }else{
        totalPeserta.value = 0;
      }
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