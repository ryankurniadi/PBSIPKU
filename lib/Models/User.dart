import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  String? id;
  String? nama;
  String? level;
  String? username;
  String? email;
  bool? isActive;
  bool? isPickUsername;
  String? pbsi;
  String? skill;
  String? img;
  String? token;
  String? alamat;
  String? lahir;
  int? hp;
  int? nik;
  DateTime? tgl;


  User({
    this.id,
    this.token,
    this.nama,
    this.lahir,
    this.nik,
    this.tgl,
    this.level,
    this.img,
    this.alamat,
    this.email,
    this.hp,
    this.pbsi,
    this.skill,
    this.isActive,
    this.isPickUsername,
    this.username,
  });

  factory User.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ){
    final data = snapshot.data();
    return User(
      id: snapshot.id,
      nama: data?['nama'],
      tgl: data?['tgl'].toDate(),
      nik: data?['nik'],
      alamat: data?['alamat'],
      lahir: data?['lahir'],
      email: data?['email'],
      token: data?['token'],
      hp: data?['hp'],
      img: data?['img'],
      isActive: data?['isActive'],
      isPickUsername: data?['isPickUsername'],
      level: data?['level'],
      pbsi: data?['pbsi'],
      skill: data?['skill'],
      username: data?['username'],
    );
  }

  
  Map<String, dynamic> toFirestore(){
    return {
      if (nama != null) 'nama' : nama,
      if (id != null) 'id' : id,
      if (nik != null) 'nik' : nik,
      if (tgl != null) 'tgl' : tgl,
      if (alamat != null) 'alamat' : alamat,
      if (lahir != null) 'lahir' : lahir,
      if (email != null) 'email' : email,
      if (hp  != null) 'hp' : hp,
      if (username  != null) 'username' : username,
      if (img  != null) 'img' : img,
      if (level  != null) 'level' : level,
      if (skill  != null) 'skill' : skill,
      if (pbsi  != null) 'pbsi' : pbsi,
      if (token  != null) 'token' : token,
      if (isActive  != null) 'isActive' : isActive,
      if (isPickUsername  != null) 'isPickUsername' : isPickUsername,

    };
  }
}