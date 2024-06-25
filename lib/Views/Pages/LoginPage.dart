import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


import '../Widgets/LoadingBarrier.dart';
import '../../Controllers/AuthController.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: GetBuilder<AuthController>(builder: (authC) {
      return LoadingBarrier(
        child: Scaffold(

          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
              image: AssetImage('assets/img/bg.jpg'),
              fit: BoxFit.cover,
            ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GetBuilder<AuthController>(builder: (authC) {
                    return Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Card(
                            margin: EdgeInsets.symmetric(horizontal: Get.width / 3),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 80, vertical: 40),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text("LOGIN PBSI PEKANBARU", style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                    fontSize: 23
                                  ),),
                                  const SizedBox(height: 20,),
                                  TextFormField(
                                      controller: TextEditingController(),
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        hintText: "E-mail/Username",
                                        prefixIcon: const Icon(Icons.person),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              20.0), // Melengkungkan border
                                        ),
                                      ),
                                      onSaved: (value) {
                                        authC.email.value = value!;
                                      },
                                      onFieldSubmitted: (value) {
                                        if (_formKey.currentState!.validate()) {
                                          _formKey.currentState!.save();
                                          authC.login();
                                        }
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "E-Mail Wajib Di Isi";
                                        }
                                        if(value.length < 6 ){
                                          return "Username Terlalu Pendek";
                                        }
                                      }),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      hintText: "Password",
                                      prefixIcon: const Icon(Icons.lock),
                                      // /filled: true,
                                      //fillColor: Colors.grey[200],
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            20.0), // Melengkungkan border
                                      ),
                                    ),
                                    onSaved: (value) {
                                      authC.password.value = value!;
                                    },
                                    onFieldSubmitted: (value) {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        authC.login();
                                      }
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Password Wajib Di Isi";
                                      }
                                    },
                                  ),
                                  if (authC.isLoginFail.value)
                                    const Column(
                                      children: [
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "username atau password salah",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: Get.width / 3,
                            height: 60,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                    )
                                  ),
                                ),
                                // style: ButtonStyle(),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    authC.login();
                                  }
                                },
                                child: const Text("LOGIN")),
                          )
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      );
    }));
  }
}
