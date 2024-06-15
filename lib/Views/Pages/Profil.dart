import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Widgets/NavBar.dart';
import '../../Controllers/UserController.dart';

class Profil extends StatelessWidget {
  Profil({super.key});


  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
      child: Scaffold(
        appBar: NavBar(title: "Profil Lengkap"),
        body: GetBuilder<UserController>(
          builder: (userC)=>ListView(
            padding: EdgeInsets.symmetric(horizontal: Get.width/3, vertical: 20),
            children: [
              
              SizedBox(
                height: 150,
                width: 150,
                child: CircleAvatar(

                  backgroundImage: NetworkImage("${userC.userProfil!.img}"),
                ),
              ),
              const SizedBox(height: 5,),
              Center(child: Text("${userC.userProfil!.nama}", style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),)),
              const SizedBox(height: 5,),
              Center(child: Text("${userC.userProfil!.level}", style: const TextStyle(
                fontSize: 15,
                //fontWeight: FontWeight.bold,
              ),)),
              const SizedBox(height: 10,),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
                          const Text("Username", style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),),
                          (userC.userProfil!.isPickUsername == true ? Text('${userC.userProfil!.username}') : Row(
                            children: [
                              ElevatedButton(onPressed: (){}, child: Text("Ganti Username")),
                              Text('${userC.userProfil!.username}'),                  
                            ],
                          ))
                        ],
                      ),
                      const SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("E-mail", style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),),
                          Text('${userC.userProfil!.email}')
                        ],
                      ),
                      const SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("No HP", style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),),
                          Text('${userC.userProfil!.hp}')
                        ],
                      ),
                      const SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Level Permain", style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),),
                          Text('${userC.userProfil!.skill}')
                        ],
                      ),
                      const SizedBox(height: 15,),
                      
                    ],
                    
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              ElevatedButton(
                      onPressed: (){},
                      child: const Text("PERBAHARUI PROFIL"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}