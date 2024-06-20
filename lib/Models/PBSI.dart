import 'package:cloud_firestore/cloud_firestore.dart';

class PBSI{
  final String? nama;
  final String? alamat;
  final String? id;

  PBSI({this.nama, this.id, this.alamat});

  factory PBSI.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ){
    final data = snapshot.data();
    return PBSI(
      nama: data?['nama'],
      alamat: data?['alamat'],
      id: snapshot.id
    );
  }

  Map<String, dynamic> toFirestore(){
    return {
      if (nama != null) 'nama' : nama,
      if (alamat != null) 'alamat' : alamat,
      if (id != null) 'id' : id,
    };
  }


}

