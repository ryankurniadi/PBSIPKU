import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/Peserta.dart';
import '../Models/User.dart';
import '../Models/Turnamen.dart';

class ListTurPBSIController extends GetxController {
  final db = FirebaseFirestore.instance;

  var dataTurnamen = [].obs;
  var ket = "".obs;
  var table = 'turnamen';

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

  @override
  void onInit() {
    getData();
    super.onInit();
  }
}
