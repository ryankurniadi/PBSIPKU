import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Models/Turnamen.dart';
import '../../Controllers/TurnamenContoller.dart';
import '../../Routes/PageNames.dart';

class TabelTurnamen extends DataTableSource {
  final BuildContext context;
  TabelTurnamen(this.context);
  final turC = Get.find<TurnamenController>();

  @override
  DataRow? getRow(int index) {
    Turnamen data = turC.dataTurnamen[index];
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () async {
                      turC.turID.value = "${data.id}";
                      await turC.getSingleTur();
                      Get.toNamed(PageNames.DetailTurnamen);
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                      ),
                      child: const Center(
                          child: Icon(
                        Icons.remove_red_eye,
                        size: 20,
                        color: Colors.white,
                      )),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  InkWell(
                    onTap: () async {
                      turC.turID.value = "${data.id}";
                      await turC.getSingleTur();
                      Get.toNamed(PageNames.EditTurnamen);
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                      ),
                      child: const Center(
                          child: Icon(
                        Icons.edit,
                        size: 20,
                        color: Colors.white,
                      )),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  InkWell(
                      onTap: () {
                        Get.defaultDialog(
                            title: "Konfirmasi Hapus",
                            content: Text(
                                "Apakah kamu yakin untuk menghapus data ${data.nama}?"),
                            barrierDismissible: false,
                            cancel: TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: const Text("Tidak")),
                            confirm: TextButton(
                                onPressed: () {
                                  if (!Get.isSnackbarOpen) {
                                    turC.deleteData("${data.id}", "${data.img}");
                                  }
                                },
                                child: const Text("Iya")));
                      },
                      
                      child: Container(
                        width: 30, height: 30,
                        decoration: const BoxDecoration(
                          color: Colors.red
                        ),
                          child: const Center(
                              child: Icon(
                        Icons.delete,
                        size: 20,
                        color: Colors.white,
                      )))),
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
  int get rowCount => turC.totalTur.value;

  @override
  int get selectedRowCount => 0;
}
