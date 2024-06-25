import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


import '../Widgets/LoadingBarrier.dart';
import '../Widgets/NavBar.dart';
import '../../Controllers/UserController.dart';
import '../../Controllers/LoadingController.dart';

class EditProfil extends StatelessWidget {
  EditProfil({super.key});

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
      appBar: NavBar(title: "Perbaharui Profil"),
      body: GetBuilder<LoadingController>(builder: (loadC) {
        return LoadingBarrier(
          child: SingleChildScrollView(
            padding:
                EdgeInsets.symmetric(horizontal: Get.width / 7, vertical: 20),
            child: GetBuilder<UserController>(builder: (_) {
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
                          initialValue: userC.nama.value,
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
                          initialValue: "${userC.nik.value}",
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
                          initialValue: userC.alamat.value,
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
                          initialValue: userC.lahir.value,
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
                          initialValue: "${userC.hp.value}",
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
                          height: 20,
                        ),
                        InkWell(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              userC.editUser(userC.idUser.value);
                            }
                          },
                          child: Container(
                            width: Get.width / 1.1,
                            height: 60,
                            decoration: BoxDecoration(color: Colors.green,
                      borderRadius: BorderRadius.circular(10),),
                            child: const Center(
                              child: Text("Perbaharui Profil",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}
