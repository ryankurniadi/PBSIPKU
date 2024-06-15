import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:email_validator/email_validator.dart';

import '../Widgets/NavBar.dart';
import '../../Models/PBSI.dart';
import '../../Controllers/UserController.dart';
import '../../Controllers/PBSIController.dart';
import '../../Controllers/LoadingController.dart';

class AddUser extends StatelessWidget {
  AddUser({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(title: "Add User"),
      body: GetBuilder<LoadingController>(builder: (loadC) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: GetBuilder<UserController>(builder: (userC) {
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(hintText: "Nama Lengkap"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Nama Wajib Di Isi";
                      }
                    },
                    onSaved: (value) {
                      userC.nama.value = value!;
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: "E-mail",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "E-mail Wajib Di Isi";
                      }
                      if (!EmailValidator.validate(value)) {
                        return "Format E-mail Tidak Valid";
                      }
                    },
                    onSaved: (value) {
                      userC.email.value = value!;
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Row(
                    children: [
                      Text('Level User'),
                    ],
                  ),
                  DropdownButtonFormField(
                    value: "Root",
                    onSaved: (value) {
                      userC.level.value = value!;
                    },
                    onChanged: (value) {
                      userC.level.value = value!;
                      if (value! == "Admin PBSI") {
                        userC.levelUserChanger(false);
                      } else {
                        userC.levelUserChanger(true);
                      }
                    },
                    items: const [
                      DropdownMenuItem(
                        value: "Root",
                        child: Text("Admin Sistem/Root"),
                      ),
                      DropdownMenuItem(
                        value: "Admin PBSI",
                        child: Text("Admin PBSI"),
                      ),
                    ],
                  ),
                  (!userC.isRoot.value
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text("Pilih PBSI"),
                            const SizedBox(
                              height: 5,
                            ),
                            GetBuilder<PBSIController>(builder: (pbsiC) {
                              return DropdownButtonFormField(
                                hint: const Text("Pilih PBSI"),
                                onChanged: (value) {
                                  userC.pbsi.value = value!;
                                },
                                items: List<DropdownMenuItem>.generate(
                                    pbsiC.totalPBSI.value, (index) {
                                  PBSI data = pbsiC.dataPBSI[index];
                                  return DropdownMenuItem(
                                    value: "${data.id}",
                                    child: Text("${data.nama}"),
                                  );
                                }),
                              );
                            }),
                          ],
                        )
                      : const SizedBox()),
                  const SizedBox(
                    height: 5,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          userC.addUser();
                        }
                      },
                      child: const Text("Tambah User")),
                ],
              ),
            );
          }),
        );
      }),
    );
  }
}
