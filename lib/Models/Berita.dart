import 'package:cloud_firestore/cloud_firestore.dart';

class Berita {
  String? id;
  String? judul;
  String? isi;
  DateTime? date;
  String? penulis;
  String? img;

  Berita({this.id, this.judul, this.isi, this.img, this.penulis, this.date});

  factory Berita.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return Berita(
      id: snapshot.id,
      judul: data?['judul'],
      isi: data?['isi'],
      img: data?['img'],
      penulis: data?['penulis'],
      date: data?['date'].toDate(),
    );
  }

  Map<String, dynamic> toFirestore(){
    return {
      if(id != null) 'id':id,
      if(judul != null) 'judul':judul,
      if(isi != null) 'isi':isi,
      if(img != null) 'img':img,
      if(penulis != null) 'penulis':penulis,
      if(date != null) 'date':date,
    };
  }

}
