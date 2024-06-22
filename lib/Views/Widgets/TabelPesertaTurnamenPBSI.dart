import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Models/PesertaView.dart';
import '../../Controllers/PesertaTerdaftarController.dart';

class TabelPesertaTurnamenPBSI extends DataTableSource {
  final BuildContext context;
  TabelPesertaTurnamenPBSI(this.context);

  final terC = Get.find<PesertaTerdaftarController>();

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => terC.dataTerdaftar.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow? getRow(int index) {
    Pesertaview data = terC.dataTerdaftar[index];
    return DataRow.byIndex(index: index, cells: [
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${data.nama}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17),
                ),
                Text("No. HP : ${data.hp}"),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${data.nama2}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17),
                ),
                Text("No. HP : ${data.hp2}"),
              ],
            ),
          ],
        ),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Align(
            alignment: Alignment.topLeft, child: Text("${data.namaPBSI}")),
      )),
    ]);
  }
}
