import 'package:cloud_firestore/cloud_firestore.dart';

class Peserta{
  String? id;
  String? idUser;
  String? idTurnamen;
  String? idPBSI;
  String? status;

  Peserta({this.id, this.idTurnamen, this.idUser, this.status, this.idPBSI});

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
      status: data?['status'],
    );
  }

    Map<String, dynamic> toFirestore(){
    return {
      if (idTurnamen != null) 'idTurnamen' : idTurnamen,
      if (idUser != null) 'idUser' : idUser,
      if (idPBSI != null) 'idPBSI' : idPBSI,
      if (status != null) 'status' : status,
      if (id != null) 'id' : id,
    };
  }


}