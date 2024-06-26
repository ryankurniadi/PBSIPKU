import 'package:get/get.dart';


import '../Views/Pages/DetailBerita.dart';
import '../Views/Pages/DetailTurnamenPBSI.dart';
import '../Views/Pages/EditBerita.dart';
import '../Views/Pages/EditProfil.dart';
import '../Views/Pages/EditUser.dart';
import '../Views/Pages/ListTurnamenPBSI.dart';
import './PageNames.dart';
import '../Middleware/AuthMiddleware.dart';
import '../Middleware/LoginMiddleware.dart';

import '../Bindings/HomeBinding.dart';
import '../Views/Pages/Home.dart';
import '../Views/Pages/Beranda.dart';
import '../Views/Pages/LoginPage.dart';
import '../Views/Pages/BlankPage.dart';
import '../Views/Pages/InitialPage.dart';

import '../Views/Pages/DataPBSI.dart';
import '../Views/Pages/AddPBSI.dart';
import '../Views/Pages/EditPBSI.dart';

import '../Views/Pages/AddTurnament.dart';
import '../Views/Pages/DataTurnamen.dart';
import '../Views/Pages/EditTurnamen.dart';
import '../Views/Pages/AjukanTurnamen.dart';
import '../Views/Pages/DetailTurnamen.dart';
import '../Views/Pages/EditTurPBSI.dart';

import '../Views/Pages/DataBerita.dart';
import '../Views/Pages/AddBerita.dart';

import '../Views/Pages/DataUsers.dart';
import '../Views/Pages/AddUser.dart';

import '../Views/Pages/DataAnggota.dart';
import '../Views/Pages/AddAnggota.dart';
import '../Views/Pages/EditAnggota.dart';


import '../Views/Pages/Profil.dart';

class PageRoutes {
  static final Pages = [
    GetPage(
        name: PageNames.Home,
        binding: HomeBinding(),
        middlewares: [
          AuthMiddleware(),
        ],
        page: () => Home()),
    GetPage(
        name: PageNames.Blank,
        middlewares: [
          AuthMiddleware(),
        ],
        page: () => const BlankPage()),
    GetPage(
        name: PageNames.Beranda,
        middlewares: [
          AuthMiddleware(),
        ],
        page: () => Beranda()),
    GetPage(
        name: PageNames.Login,
        middlewares: [LoginMiddleware()],
        page: () => LoginPage()),
    GetPage(
        name: PageNames.Init,
        binding: HomeBinding(),
        page: () => Initialpage()),


    //Profil
        GetPage(
        name: PageNames.Profil,
        middlewares: [
          AuthMiddleware(),
        ],
        page: () => Profil()),
    //Profil
        GetPage(
        name: PageNames.EditProfil,
        middlewares: [
          AuthMiddleware(),
        ],
        page: () => EditProfil()),

    //PBSI
    GetPage(
        name: PageNames.DataPBSI,
        middlewares: [
          AuthMiddleware(),
        ],
        page: () => DataPBSI()),
    GetPage(
        name: PageNames.AddPBSI,
        middlewares: [
          AuthMiddleware(),
        ],
        page: () => AddPBSI()),
    GetPage(
        name: PageNames.EditPBSI,
        middlewares: [
          AuthMiddleware(),
        ],
        page: () => EditPBSI()),
    GetPage(
        name: PageNames.ListPBSITurnamen,
        middlewares: [
          AuthMiddleware(),
        ],
        page: () => ListTurnamenPBSI()),
    GetPage(
        name: PageNames.DetailTurnamenPBSI,
        middlewares: [
          AuthMiddleware(),
        ],
        page: () => DetailTurnamenPBSI()),

    //Turnamen
    GetPage(
        name: PageNames.DataTurnamen,
        middlewares: [
          AuthMiddleware(),
        ],
        page: () => DataTurnamen()),
    GetPage(
        name: PageNames.AddTurnamen,
        middlewares: [
          AuthMiddleware(),
        ],
        page: () => AddTurnamner()),
    GetPage(
        name: PageNames.EditTurnamen,
        middlewares: [
          AuthMiddleware(),
        ],
        page: () => EditTurnamen()),
    GetPage(
        name: PageNames.AjukanTurnamen,
        middlewares: [
          AuthMiddleware(),
        ],
        page: () => Ajukanturnamen()),
    GetPage(
        name: PageNames.EditTurnamenPBSI,
        middlewares: [
          AuthMiddleware(),
        ],
        page: () => EditTurPBSI()),
    GetPage(
        name: PageNames.DetailTurnamen,
        middlewares: [
          AuthMiddleware(),
        ],
        page: () => DetailTurnamen()),

    //Berita
    GetPage(
        name: PageNames.DataBerita,
        middlewares: [
          AuthMiddleware(),
        ],
        page: () => DataBerita()),
    GetPage(
        name: PageNames.AddBerita,
        middlewares: [
          AuthMiddleware(),
        ],
        page: () => AddBerita()),
    GetPage(
        name: PageNames.EditBerita,
        middlewares: [
          AuthMiddleware(),
        ],
        page: () => EditBerita()),
    GetPage(
        name: PageNames.DetailBerita,
        middlewares: [
          AuthMiddleware(),
        ],
        page: () => DetailBerita()),

    //Users
    GetPage(
        name: PageNames.DataUser,
        middlewares: [
          AuthMiddleware(),
        ],
        page: () => DataUsers()),
    GetPage(
        name: PageNames.AddUser,
        middlewares: [
          AuthMiddleware(),
        ],
        page: () => AddUser()),
    GetPage(
        name: PageNames.EditUser,
        middlewares: [
          AuthMiddleware(),
        ],
        page: () => EditUser()),

    //Manajemen PBSI
    GetPage(
        name: PageNames.DataAnggota,
        middlewares: [
          AuthMiddleware(),
        ],
        page: () => DataAnggota()),
    GetPage(
        name: PageNames.AddAnggota,
        middlewares: [
          AuthMiddleware(),
        ],
        page: () => AddAnggota()),
    GetPage(
        name: PageNames.EditAnggota,
        middlewares: [
          AuthMiddleware(),
        ],
        page: () => EditAnggota()),
  ];
}
