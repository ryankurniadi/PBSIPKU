import 'package:cloud_firestore/cloud_firestore.dart';

class Peserta{
  String? id;
  String? idUser;
  String? idTurnamen;
  String? idPBSI;
  String? pembayaran;
  String? status;

  Peserta({this.id, this.idTurnamen, this.idUser, this.status, this.idPBSI, this.pembayaran});

   factory Peserta.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ){
    final data = snapshot.data();
    return Peserta(
      id: snapshot.id,
      idTurnamen: data?['idTurnamen'],
      idUser: data?['idUser'],
      idPBSI: data?['idPBSI'],
      pembayaran: data?['pembayaran'],
      status: data?['status'],
    );
  }

    Map<String, dynamic> toFirestore(){
    return {
      if (idTurnamen != null) 'idTurnamen' : idTurnamen,
      if (idUser != null) 'idUser' : idUser,
      if (idPBSI != null) 'idPBSI' : idPBSI,
      if (pembayaran != null) 'pembayaran' : pembayaran,
      if (status != null) 'status' : status,
      if (id != null) 'id' : id,
    };
  }


}