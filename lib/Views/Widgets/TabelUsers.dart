import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Models/User.dart';
import '../../Controllers/UserController.dart';
import '../../Controllers/AuthController.dart';
import '../../Routes/PageNames.dart';

class TabelUser extends DataTableSource {
  final BuildContext context;
  TabelUser(this.context);
  final userC = Get.find<UserController>();

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => userC.totalUser.value;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow? getRow(int index) {
    User data = userC.dataUser[index];
    return DataRow.byIndex(index: index, cells: [
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Align(alignment: Alignment.topLeft, child: Text("${data.nama}")),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child:
            Align(alignment: Alignment.topLeft, child: Text("${data.level}")),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Align(alignment: Alignment.topLeft, child: Text("${data.pbsi}")),
      )),
      DataCell(
        Align(
          alignment: Alignment.topLeft,
          child: GetBuilder<AuthController>(
            builder: (authC) {
              if (data.email == authC.authEmail.value) {
                return const SizedBox();
              } else {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                        onTap: () {},
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [Icon(Icons.key), Text("Reset Password")],
                        )),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
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
                                  userC.deleteUser(data.id!, data.email!);
                                }
                              },
                              child: const Text("Iya")));
                        },
                        icon: const Icon(Icons.delete)),
                  ],
                );
              }
            },
          ),
        ),
      ),
    ]);
  }
}
