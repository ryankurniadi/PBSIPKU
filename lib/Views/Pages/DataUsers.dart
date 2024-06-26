import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Widgets/NavBar.dart';
import '../../Routes/PageNames.dart';
import '../Widgets/TabelUsers.dart';
import '../../Controllers/UserController.dart';
import '../../Controllers/AuthController.dart';

class DataUsers extends StatelessWidget {
  DataUsers({super.key});
  final userC = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(title: "Data Users"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ListView(
          shrinkWrap: true,
          //physics: const NeverScrollableScrollPhysics(),
          //
          children: [
            Row(
              children: [
                InkWell(
                    onTap: () {
                      Get.toNamed(PageNames.AddUser);
                      userC.isRoot.value = true;
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
                              "TAMBAH USER",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        )))),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            GetBuilder<UserController>(
              builder: (userC) {
                if (userC.dataUser.isNotEmpty) {
                  return PaginatedDataTable(
                    source: TabelUser(context),
                    header: const Text("Data User"),
                    rowsPerPage: (userC.totalUser.value >= 7
                        ? 7
                        : userC.totalUser.value),
                    showFirstLastButtons: true,
                    showEmptyRows: false,
                    columns: const [
                      DataColumn(label: Text('Nama')),
                      DataColumn(label: Text('Level')),
                      DataColumn(label: Text('PBSI')),
                      DataColumn(label: Text('Aksi')),
                    ],
                  );
                }
                return const Center(child: Text("Tidak ada Data User"));
              },
            ),
          ],
        ),
      ),
    );
  }
}
