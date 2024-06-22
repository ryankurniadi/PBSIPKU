import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../Widgets/NewSideBar.dart';
import '../../Routes/PageNames.dart';
import '../../Controllers/PBSIController.dart';
import '../../Controllers/SidebarContoller.dart';
import '../../Controllers/AuthController.dart';
import '../../Controllers/UserController.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final pbsiC = Get.put(PBSIController());
  final userC = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    userC.getSingleUser();
    return SafeArea(
      child: Scaffold(
          //appBar: NavBar(title: "PBSI KOTA PEKANBARU"),
          //drawer: const Sidebar(),
          body: GetBuilder<AuthController>(builder: (authC) {
        if (authC.authLevel.value == "Root") {
          return GetBuilder<SidebarController>(
              builder: (sideC) => Row(
                    children: [
                      NavigationRail(
                        selectedIndex: sideC.index.value,
                        labelType: NavigationRailLabelType.selected,
                        onDestinationSelected: (index) {
                          sideC.changeIndex(index);
                        },
                        indicatorColor: Colors.white,
                        useIndicator: true,
                        elevation: 1,
                        backgroundColor: Colors.black87,
                        selectedIconTheme: const IconThemeData(
                          color: Colors.black,
                        ),
                        unselectedIconTheme:
                            const IconThemeData(color: Colors.white),
                        selectedLabelTextStyle:
                            const TextStyle(color: Colors.white),
                        leading: SizedBox(
                          height: 70,
                          child: GestureDetector(
                            onTap: () {
                              Get.toNamed(PageNames.Profil);
                            },
                            child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage("${authC.authimg.value}"),
                            ),
                          ),
                          //color: Colors.amber,
                        ),
                        destinations: const [
                          NavigationRailDestination(
                              icon: Icon(
                                Icons.house,
                              ),
                              label: Text("Home")),
                          NavigationRailDestination(
                              icon: Icon(
                                Icons.sports,
                              ),
                              label: Text("Data PBSI")),
                          NavigationRailDestination(
                              icon: Icon(Icons.ballot),
                              label: Text("Turnamen")),
                          NavigationRailDestination(
                              icon: Icon(Icons.newspaper),
                              label: Text("Berita")),
                          NavigationRailDestination(
                              icon: Icon(Icons.person), label: Text("Users")),
                          NavigationRailDestination(
                              icon: Icon(Icons.paste), label: Text("Blank")),
                        ],
                      ),
                      Expanded(child: NewSideBar(index: sideC.index.value))
                    ],
                  ));
        } else {
          if (authC.authLevel.value == "Admin PBSI") {
            return GetBuilder<SidebarController>(
                builder: (sideC) => Row(
                      children: [
                        NavigationRail(
                          selectedIndex: sideC.index.value,
                          labelType: NavigationRailLabelType.selected,
                          onDestinationSelected: (index) {
                            sideC.changeIndex(index);
                          },
                          indicatorColor: Colors.white,
                          useIndicator: true,
                          elevation: 1,
                          backgroundColor: Colors.black87,
                          selectedIconTheme: const IconThemeData(
                            color: Colors.black,
                          ),
                          unselectedIconTheme:
                              const IconThemeData(color: Colors.white),
                          selectedLabelTextStyle:
                              const TextStyle(color: Colors.white),
                          leading: SizedBox(
                            height: 70,
                            child: GestureDetector(
                              onTap: () {
                                
                                Get.toNamed(PageNames.Profil);
                              },
                              child: CircleAvatar(
                                backgroundImage:
                                    NetworkImage("${authC.authimg.value}"),
                              ),
                            ),
                            //color: Colors.amber,
                          ),
                          destinations: const [
                            NavigationRailDestination(
                                icon: Icon(
                                  Icons.house,
                                ),
                                label: Text("Home")),
                            NavigationRailDestination(
                                icon: FaIcon(FontAwesomeIcons.trophy),
                                label: Text("Turnamen Publik")),
                            NavigationRailDestination(
                                icon: Icon(Icons.ballot),
                                label: Text("Turnamen")),
                            NavigationRailDestination(
                                icon: Icon(Icons.group),
                                label: Text("Anggota")),
                            NavigationRailDestination(
                                icon: Icon(Icons.newspaper),
                                label: Text("Berita")),
                            NavigationRailDestination(
                                icon: Icon(Icons.paste), label: Text("Blank")),
                          ],
                        ),
                        Expanded(child: NewSideBar(index: sideC.index.value))
                      ],
                    ));
          } else {
            return GetBuilder<SidebarController>(
                builder: (sideC) => Row(
                      children: [
                        NavigationRail(
                          selectedIndex: sideC.index.value,
                          labelType: NavigationRailLabelType.selected,
                          onDestinationSelected: (index) {
                            sideC.changeIndex(index);
                          },
                          indicatorColor: Colors.white,
                          useIndicator: true,
                          elevation: 1,
                          backgroundColor: Colors.black87,
                          selectedIconTheme: const IconThemeData(
                            color: Colors.black,
                          ),
                          unselectedIconTheme:
                              const IconThemeData(color: Colors.white),
                          selectedLabelTextStyle:
                              const TextStyle(color: Colors.white),
                          leading: SizedBox(
                            height: 70,
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(PageNames.Profil);
                              },
                              child: CircleAvatar(
                                backgroundImage:
                                    NetworkImage("${authC.authimg.value}"),
                              ),
                            ),
                            //color: Colors.amber,
                          ),
                          destinations: const [
                            NavigationRailDestination(
                                icon: Icon(
                                  Icons.house,
                                ),
                                label: Text("Home")),
                            NavigationRailDestination(
                                icon: Icon(Icons.paste), label: Text("Blank")),
                          ],
                        ),
                        Expanded(child: NewSideBar(index: sideC.index.value))
                      ],
                    ));
          }
        }
      })),
    );
  }
}
