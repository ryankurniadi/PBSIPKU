import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Models/PBSI.dart';
import '../../Controllers/PBSIController.dart';
import '../../Routes/PageNames.dart';

class PBSISource extends DataTableSource {
  final BuildContext context;
  PBSISource(this.context);
  final pbsiC = Get.find<PBSIController>();

  @override
  DataRow? getRow(int index) {
    PBSI data = pbsiC.dataPBSI[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text('${data.nama}')),
        DataCell(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () {
                  Get.toNamed(PageNames.EditPBSI);
                  pbsiC.id.value = "${data.id}";
                  pbsiC.nama.value = "${data.nama}";
                  pbsiC.alamat.value = "${data.alamat}";
                },
                icon: const Icon(
                  Icons.edit,
                  size: 20,
                )),
            IconButton(
                onPressed: () {
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
                              pbsiC.deleteData("${data.id}");
                            }
                          },
                          child: const Text("Iya")));
                },
                icon: const Icon(
                  Icons.delete,
                  size: 20,
                ))
          ],
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => pbsiC.dataPBSI.length;

  @override
  int get selectedRowCount => 0;
}
