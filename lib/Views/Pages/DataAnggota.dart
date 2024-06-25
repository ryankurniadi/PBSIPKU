import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Widgets/TabelAnggota.dart';
import '../../Routes/PageNames.dart';
import '../Widgets/NavBar.dart';
import '../../Controllers/AnggotaController.dart';


class DataAnggota extends StatelessWidget {
  DataAnggota({super.key});
  final anggotaC = Get.put(AnggotaController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: NavBar(title: "Data Anggota ${anggotaC.pbsinama}"),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            //
            children: [
              Row(
                children: [
                  InkWell(
                      onTap: () {
                        Get.toNamed(PageNames.AddAnggota);
                        // userC.isRoot.value = true;
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
                                "TAMBAH ANGGOTA",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )))),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              GetBuilder<AnggotaController>(
                builder: (userC) {
                  if (userC.dataUser.isNotEmpty) {
                    return PaginatedDataTable(
                      source: TabelAnggota(context),
                      rowsPerPage: (userC.dataUser.length >= 7
                          ? 7
                          : userC.dataUser.length),
                      showFirstLastButtons: true,
                      showEmptyRows: false,
                      columns: const [
                        DataColumn(label: Text('Nama')),
                        DataColumn(label: Text('Jabatan')),
                        DataColumn(label: Text('Level Pemain')),
                        DataColumn(label: Text('Aksi')),
                      ],
                    );
                  }
                  return const Center(child: Text("Tidak ada data Anggota"));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
