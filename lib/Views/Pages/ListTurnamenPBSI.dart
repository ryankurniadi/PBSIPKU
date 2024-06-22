import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../Widgets/LoadingBarrier.dart';
import '../Widgets/NavBar.dart';
import '../../Routes/PageNames.dart';
import '../../Models/Turnamen.dart';
import '../../Models/User.dart';
import '../../Controllers/ListTurPBSIController.dart';
import '../Widgets/TabelListTurPBSI.dart';

class ListTurnamenPBSI extends StatelessWidget {
  ListTurnamenPBSI({super.key});

  final turC = Get.put(ListTurPBSIController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: NavBar(title: "Turnamen Publik"),
            body: LoadingBarrier(
              child: GetBuilder<ListTurPBSIController>(
                builder: (turC) {
                  if (turC.dataTurnamen.isNotEmpty) {
                    return SingleChildScrollView(
                      child: PaginatedDataTable(
                        source: TabelListTurPBSI(context),
                        rowsPerPage: (turC.dataTurnamen.length >= 7
                            ? 7
                            : turC.dataTurnamen.length),
                        showFirstLastButtons: true,
                        showEmptyRows: false,
                        dataRowMaxHeight: 200,
                        columns: const [
                          DataColumn(label: Text('Baner Turnamen')),
                          DataColumn(label: Text('Nama Turnamen')),
                          DataColumn(label: Text('Pelaksanaan')),
                          DataColumn(label: Text('Lokasi')),
                          DataColumn(label: Text('Aksi')),
                        ],
                      ),
                    );
                  }
              
                  return const Center(child: Text("Tidak ada Data Turnamen"));
                },
              ),
            )));
  }
}
