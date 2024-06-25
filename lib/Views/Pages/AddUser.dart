import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  final userC = Get.find<UserController>();

  Future<void> _datePick(BuildContext context) async {
    DateTime? datepick = await showDatePicker(
        context: context,
        initialDate: userC.tgl.value,
        firstDate: DateTime(1900),
        lastDate: DateTime(DateTime.now().year + 1),
        onDatePickerModeChange: (value) {
          print("get data");
        });
    if (datepick == null) {
      userC.setDate(DateTime.now());
    } else {
      userC.setDate(datepick);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(title: "Add User"),
      body: GetBuilder<LoadingController>(builder: (loadC) {
        return SingleChildScrollView(
          padding:
              EdgeInsets.symmetric(horizontal: Get.width / 7, vertical: 20),
          child: GetBuilder<UserController>(builder: (userC) {
            return Form(
              key: _formKey,
              child: Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 70, vertical: 50),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Text(
                            "Nama Lengkap",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
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
                        height: 10,
                      ),
                      const Row(
                        children: [
                          Text(
                            "NIK",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        keyboardType:
                            TextInputType.number, // Keyboard type untuk angka
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter
                              .digitsOnly // Formatter untuk angka saja
                        ],
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Data Wajib Di Isi";
                          }
                        },
                        onSaved: (value) {
                          int nik = int.parse(value!);
                          userC.nik.value = nik;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Row(
                        children: [
                          Text(
                            "Alamat",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Nama Wajib Di Isi";
                          }
                        },
                        onSaved: (value) {
                          userC.alamat.value = value!;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Row(
                        children: [
                          Text(
                            "Tempat Lahir",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Nama Wajib Di Isi";
                          }
                        },
                        onSaved: (value) {
                          userC.lahir.value = value!;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Row(
                        children: [
                          Text(
                            "Tanggal Lahir",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: "${userC.dateShow}",
                          suffix: const Icon(Icons.calendar_month),
                        ),
                        readOnly: true,
                        onTap: () {
                          _datePick(context);
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Row(
                        children: [
                          Text(
                            "No Hp",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        keyboardType:
                            TextInputType.number, // Keyboard type untuk angka
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter
                              .digitsOnly // Formatter untuk angka saja
                        ],
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Data Wajib Di Isi";
                          }
                        },
                        onSaved: (value) {
                          int noHP = int.parse(value!);
                          userC.hp.value = noHP;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Row(
                        children: [
                          Text(
                            "E-mail",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
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
                      const Row(
                        children: [
                          Text(
                            "Level User",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      DropdownButtonFormField(
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
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
                                const Row(
                                  children: [
                                    Text(
                                      "Pilih PBSI",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                GetBuilder<PBSIController>(builder: (pbsiC) {
                                  return DropdownButtonFormField(
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder()),
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
                        height: 20,
                      ),
                       InkWell(
                      onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              userC.addUser();
                            }
                          },
                           child: Container(
                        width: Get.width / 1.1,
                        height: 60,
                        decoration: BoxDecoration(color: Colors.green,
                      borderRadius: BorderRadius.circular(10),),
                        child: const Center(
                          child: Text("Tambah User",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),),
                        ),
                      ),),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}
