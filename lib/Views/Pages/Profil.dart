import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Widgets/LoadingBarrier.dart';
import '../Widgets/NavBar.dart';
import '../../Routes/PageNames.dart';
import '../../Controllers/UserController.dart';

class Profil extends StatelessWidget {
  Profil({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: NavBar(title: "Profil Lengkap"),
        body: LoadingBarrier(
          child: GetBuilder<UserController>(
            builder: (userC) => ListView(
              padding:
                  EdgeInsets.symmetric(horizontal: Get.width / 3, vertical: 20),
              children: [
                Center(
                  child: Stack(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.transparent,
                                maxRadius: 67,
                                backgroundImage:
                                    NetworkImage("${userC.userProfil!.img}"),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: FloatingActionButton(
                                  shape: const CircleBorder(),
                                  backgroundColor: Colors.white70,
                                  mini: true,
                                  onPressed: () {
                                   // userC.imgPicked(false);
                                    Get.defaultDialog(
                                      title: "Pilih Gambar",
                                      content: GetBuilder<UserController>(
                                        builder: (userC) {
                                          if (1 != 2) {
                                         // if (!userC.isImgPicked.value) {
                                            return Center(
                                              child: InkWell(
                                                onTap: () async{
                                                  //userC.pickImage();
                                                },
                                                child: Container(
                                                  height: 250,
                                                  width: 250,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade200,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: const Center(
                                                      child: Icon(
                                                    Icons.camera_alt,
                                                    size: 100,
                                                    color: Colors.black38,
                                                  )),
                                                ),
                                              ),
                                            );
                                          }
                                          return Column(
                                            children: [
                                              Container(
                                                height: 250,
                                                width: 250,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10)
                                                ),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(10),
                                                  //child: Image.file(userC.image!)
                                                  ),
                                              ),
                                              const SizedBox(height: 10,),
                                              TextButton(onPressed: ()async{
                                                Get.back();
                                                //await userC.gantiProfil();
                                              },style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.green), padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 20))), child: const Text("Ganti Foto Profil", style: TextStyle(color: Colors.white),))
                                            ],
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 24,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Center(
                    child: Text(
                  "${userC.userProfil!.nama}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                const SizedBox(
                  height: 5,
                ),
                Center(
                    child: Text(
                  "${userC.userProfil!.level}",
                  style: const TextStyle(
                    fontSize: 15,
                    //fontWeight: FontWeight.bold,
                  ),
                )),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Nama PBSI",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('${userC.pbsiname}')
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Username",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            (userC.userProfil!.username != "null"
                                ? Text('${userC.userProfil!.username}')
                                : TextButton(
                                    onPressed: () {
                                      Get.defaultDialog(
                                        title: "Buat Username",
                                        barrierDismissible: false,
                                        confirm: TextButton(
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              _formKey.currentState!.save();
                                              Get.back();
                                              userC.changeUser(
                                                  userC.userProfil!.id!);
                                            }
                                          },
                                          style: const ButtonStyle(
                                            backgroundColor:
                                                WidgetStatePropertyAll(
                                                    Colors.green),
                                          ),
                                          child: const Text(
                                            "Buat Username",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        cancel: TextButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: const Text("Batal")),
                                        content: Form(
                                            key: _formKey,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 15),
                                              child: Column(
                                                children: [
                                                  TextFormField(
                                                    decoration:
                                                        const InputDecoration(
                                                            hintText:
                                                                "Masukan Username"),
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return "Data tidak Boleh Kosong";
                                                      }
                                                      if (value.length <= 5) {
                                                        return "Minimal 6 Digit karakter";
                                                      }
                                                    },
                                                    onSaved: (value) {
                                                      userC.changeUsername.value =
                                                          value!;
                                                    },
                                                  )
                                                ],
                                              ),
                                            )),
                                      );
                                    },
                                    child: const Text("Buat Username")))
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "E-mail",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('${userC.userProfil!.email}')
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "No HP",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('${userC.userProfil!.hp}')
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Level Permain",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('${userC.userProfil!.skill}')
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () async{
                    userC.showDate(userC.userProfil!.tgl!);
                    await userC.getSingelUSerForEdit(userC.userProfil!.id!);
                    Get.toNamed(PageNames.EditProfil);
                  },
                  child: Container(
                    width: Get.width / 1.1,
                    height: 60,
                    decoration: BoxDecoration(color: Colors.green),
                    child: const Center(
                      child: Text("Perbaharui Profil"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
