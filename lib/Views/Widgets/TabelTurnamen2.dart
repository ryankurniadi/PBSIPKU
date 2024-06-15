import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Models/Turnamen.dart';
import '../../Controllers/TurnamenContoller.dart';
import '../../Routes/PageNames.dart';

class TabelTurnamen2 extends DataTableSource {
  final BuildContext context;
  TabelTurnamen2(this.context);
  final turC = Get.find<TurnamenController>();

  @override
  DataRow? getRow(int index) {
    Turnamen data = turC.dataTurnamen2[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Image(
            image: NetworkImage(
              data.img!,
            ),
            width: 180,
            height: 180,
          ),
        ),
        DataCell(Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${data.nama}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              Text("${data.level}"),
            ],
          ),
        )),
        DataCell(Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Batas Pendaftaran",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              Text(DateFormat('EEEE, dd MMMM yyyy', 'id').format(data.batas!)),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Pelaksanaan Turnamen",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              Text(DateFormat('EEEE, dd MMMM yyyy', 'id').format(data.date!)),
            ],
          ),
        )),
        DataCell(Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Align(
              alignment: Alignment.topLeft, child: Text("${data.lokasi}")),
        )),
        DataCell(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      turC.turID.value = "${data.id}";
                      turC.pengajuanTur("Disetujui");
                    },
                    child: Container(
                      height: 40,
                      width: 250,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(5)),
                      child: const Center(child: Text("Setujui")),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      turC.turID.value = "${data.id}";
                      turC.pengajuanTur("Ditolak");
                    },
                    child: Container(
                      height: 40,
                      width: 250,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5)),
                      child: const Center(child: Text("Tolak")),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => turC.ajutotalTur.value;

  @override
  int get selectedRowCount => 0;
}
