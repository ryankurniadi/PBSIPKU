import 'package:dynamic_tabbar/dynamic_tabbar.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';

import '../Widgets/TabelTurnamenPBSI.dart';
import '../Widgets/TabelPeserta.dart';
import '../../Controllers/PBSITurController.dart';
import '../../Controllers/PesertaTurController.dart';
import '../../Controllers/AuthController.dart';
import '../../Routes/PageNames.dart';
import '../Widgets/NavBar.dart';
import '../Widgets/LoadingBarrier.dart';

class DataTurnamenPBSI extends StatelessWidget {
  DataTurnamenPBSI({super.key});
  final pesertaC = Get.put(PesertaTurController());
  final turC = Get.put(PBSITurController());
  final authC = Get.find<AuthController>();
  List<TabData> tabs = [
    TabData(
        index: 1,
        title: const Tab(
          child: Text("Data Turnamen"),
        ),
        content: const DataTur()),
    TabData(
        index: 1,
        title: const Tab(
          child: Text("Pendaftaran Turnamen"),
        ),
        content: const DataPeserta())
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: NavBar(title: "Data Turnamen PBSI"),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    InkWell(
                        onTap: () {
                          turC.date.value = DateTime.now();
                          turC.date2.value = DateTime.now();
                          turC.setDate(DateTime.now());
                          turC.setDate2(DateTime.now());
                          Get.toNamed(PageNames.AjukanTurnamen);
                        },
                        child: Container(
                            width: 200,
                            height: 50,
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xff197500),
                                    Color(0xff007529)
                                  ],
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
                                  "Ajukan Turnamen",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            )))),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: DynamicTabBarWidget(
                        dynamicTabs: tabs,
                        onTabControllerUpdated: (controller) {})),
              ],
            ),
          )),
    );
  }
}

class DataTur extends StatelessWidget {
  const DataTur({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PBSITurController>(
      builder: (turC) {
        if (turC.totalTur.value > 0) {
          return SingleChildScrollView(
            child: PaginatedDataTable(
              source: TabelTurnamenPBSI(context),
              header: const Text("Data Turnamen"),
              rowsPerPage: (turC.totalTur.value >= 7 ? 7 : turC.totalTur.value),
              showFirstLastButtons: true,
              showEmptyRows: false,
              dataRowMaxHeight: 200,
              columns: const [
                DataColumn(label: Text('Baner Turnamen')),
                DataColumn(label: Text('Nama Turnamen dan Level')),
                DataColumn(label: Text('Pelaksanaan')),
                DataColumn(label: Text('Lokasi')),
                DataColumn(label: Text('Status Pengajuan')),
                DataColumn(label: Text('Aksi')),
              ],
            ),
          );
        }
        return const Center(child: Text("Tidak ada Data Turnamen"));
      },
    );
  }
}

class DataPeserta extends StatelessWidget {
  const DataPeserta({super.key});

  @override
  Widget build(BuildContext context) {
    final pesertaC = Get.find<PesertaTurController>();
    final authC = Get.find<AuthController>();
    pesertaC.getDataPBSI(authC.authpbsi.value);
    return GetBuilder<PesertaTurController>(
      builder: (pesertaC) {
        if (pesertaC.totalPeserta.value > 0) {
          return SingleChildScrollView(
            child: PaginatedDataTable(
              source: TabelPeserta(context),
              header: const Text("Pengajuan Turnamen"),
              rowsPerPage: (pesertaC.totalPeserta.value >= 7
                  ? 7
                  : pesertaC.totalPeserta.value),
              showFirstLastButtons: true,
              showEmptyRows: false,
              dataRowMaxHeight: 150,
              columns: const [
                DataColumn(label: Text('Nama Pemain')),
                DataColumn(label: Text('Benner Turnamen')),
                DataColumn(label: Text('Keterangan Turnamen')),
                DataColumn(label: Text('Status Pengajuan')),
                DataColumn(label: Text('Aksi')),
              ],
            ),
          );
        }
        return const Center(child: Text("Tidak ada Data Pengajuan"));
      },
    );
  }
}
