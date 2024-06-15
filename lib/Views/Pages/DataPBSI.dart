import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Widgets/NavBar.dart';
import '../../Routes/PageNames.dart';
import '../../Models/PBSI.dart';
import '../Widgets/TabelPBSI.dart';
import '../../Controllers/PBSIController.dart';

class DataPBSI extends StatelessWidget {
  DataPBSI({super.key});
  final pbsiC = Get.find<PBSIController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: NavBar(title: "Data PBSI Pekanbaru"),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          Row(
            children: [
              InkWell(
                  onTap: () {
                    Get.toNamed(PageNames.AddPBSI);
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
                            "TAMBAH DATA",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      )))),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          GetBuilder<PBSIController>(
            builder: (pbsiC) {
              if (pbsiC.totalPBSI > 0) {
                return PaginatedDataTable(
                  source: PBSISource(context),
                  header: const Text("Data PBSI Kota Pekanbaru"),
                  rowsPerPage:
                      (pbsiC.totalPBSI.value >= 7 ? 7 : pbsiC.totalPBSI.value),
                  showFirstLastButtons: true,
                  showEmptyRows: false,
                  columns: const [
                    DataColumn(label: Text('Nama PBSI')),
                    DataColumn(label: Text('Aksi')),
                  ],
                );
              }
              return const Center(child: Text("Tidak ada Data PBSI"));
            },
          ),
        ],
      ),
    ));
  }
}
