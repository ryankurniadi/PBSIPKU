import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Widgets/TabelBerita.dart';
import '../../Routes/PageNames.dart';
import '../Widgets/NavBar.dart';
import '../../Controllers/BeritaController.dart';

class DataBerita extends StatelessWidget {
  DataBerita({super.key});

  final beritaC = Get.find<BeritaController>();
  @override
  Widget build(BuildContext context) {
    beritaC.getBeritaPerAdmin();
    return SafeArea(
        child: Scaffold(
      appBar: NavBar(title: "Data Berita"),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          Row(
            children: [
              InkWell(
                  onTap: () {
                    beritaC.editImgChanger(false);
                    beritaC.isi.value = "";
                    Get.toNamed(PageNames.AddBerita);
                  },
                  child: Container(
                      width: 200,
                      height: 50,
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xff197500), Color(0xff007529)],
                            stops: [0, 1],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "TAMBAH BERITA",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      )))),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          GetBuilder<BeritaController>(
            builder: (_) {
              if (beritaC.dataPerAdmin.isNotEmpty) {
                return PaginatedDataTable(
                  source: TabelBerita(context),
                  header: const Text("Data Berita/Kegiatan"),
                  rowsPerPage: (beritaC.totalDataPerAdmin.value >= 7
                      ? 7
                      : beritaC.totalDataPerAdmin.value),
                  showFirstLastButtons: true,
                  showEmptyRows: false,
                  dataRowMaxHeight: 200,
                  
                  columns: const [
                    DataColumn(label: Text('Thumbail Berita/Kegiatan')),
                    DataColumn(label: Text('Judul dan Waktu')),
                    DataColumn(label: Text('Aksi')),
                  ],
                );
              }
              return const Center(
                  child: Text("Anda belum pernah membat berita atau kegiatan"));
            },
          ),
        ],
      ),
    ));
  }
}
