import 'package:cloud_firestore/cloud_firestore.dart';

class Turnamen{
  final String? id;
  final String? nama;
  final String? img;
  final String? status;
  final String? ket;
  final String? level;
  final String? lokasi;
  final String? kontak;
  final String? host;
  final String? tipe;
  final int? limit;
  final int? biaya;
  final String? pbsi;
  final DateTime? date;
  final DateTime? batas;

  Turnamen({this.id, this.biaya, this.nama, this.img, this.tipe, this.limit, this.host, this.lokasi, this.ket, this.status, this.date, this.kontak, this.level, this.batas, this.pbsi});

  factory Turnamen.fromFirestore(
    DocumentSnapshot<Map<String,dynamic>> snapshot,
    SnapshotOptions? options
  ) {
    final data = snapshot.data();
    return Turnamen(
      id: snapshot.id,
      nama: data?["nama"],
      img: data?["img"],
      status: data?["status"],
      ket: data?["ket"],
      biaya: data?["biaya"],
      level: data?["level"],
      tipe: data?["tipe"],
      pbsi: data?["pbsi"],
      host: data?["host"],
      limit: data?["limit"],
      kontak: data?["kontak"],
      lokasi: data?["lokasi"],
      date: data?["date"].toDate(),
      batas: data?["batas"].toDate(),
    );
  }

  Map<String, dynamic> toFirestore(){
    return {
      if(id != null) 'id':id,
      if(nama != null) 'nama':nama,
      if(ket != null) 'ket':ket,
      if(biaya != null) 'biaya':biaya,
      if(img != null) 'img':img,
      if(status != null) 'status':status,
      if(pbsi != null) 'pbsi':pbsi,
      if(kontak != null) 'kontak':kontak,
      if(host != null) 'kontak':host,
      if(date != null) 'date':date,
      if(tipe != null) 'tipe':tipe,
      if(limit != null) 'limit':limit,
      if(batas != null) 'batas':batas,
      if(lokasi != null) 'lokasi':lokasi,
      if(level != null) 'level':level,
    };
  }
}