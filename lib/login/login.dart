import 'dart:convert';
import 'dart:developer';
import 'package:digital_geeks_agent/home/HomePage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final Dio dio = Dio();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    checkLogin();
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) => initializeDioInterceptor(context));
  }

  void checkLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('user') != null){
      if (context.mounted) {
        Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const HomePage(
              title: 'My Tasks',
            )),
      );
      }
    }

  }

  initializeDioInterceptor(ctx) {
    dio.interceptors.add(PrettyDioLogger());
// customization
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
  }

  Future<bool> doLogin() async {
    // EasyLoading.show();
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final formData = FormData.fromMap({
        'email': emailController.text,
        'date': DateTime.now().toIso8601String(),
        'password': passwordController.text,
        'device_token_android' : prefs.getString('fcm_token')
      });
      final Response response = await dio.post(
        'https://crm.mygeeks.net.au/api/v1/login',
        data: formData,
        onSendProgress: (int sent, int total) {
          print('${sent / total}');
          EasyLoading.showProgress(sent / total);
        },
      );
      print("200 login raw");
      print(response);
      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200) {
        var responseData = json.decode(json.encode(response.data)) as Map;
        print("200 login in");
        print(responseData['message']);
        print(responseData['status']);
        EasyLoading.showSuccess("${responseData['message']}");
        if (responseData['status'] == 200) {
          // Obtain shared preferences.
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          // Save an String value to 'action' key.
          await prefs.setString('user', json.encode(responseData['data']));
          return Future.value(true);
        }
      } else {
        print("200 login no");
        EasyLoading.showError("Invalid User");
      }
    } catch (e) {
      EasyLoading.showInfo("$e");
    }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 400,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/background.png'),
                        fit: BoxFit.fill)),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 30,
                      width: 80,
                      height: 200,
                      child: FadeInUp(
                          duration: const Duration(seconds: 1),
                          child: Container(
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/light-1.png'))),
                          )),
                    ),
                    Positioned(
                      left: 140,
                      width: 80,
                      height: 150,
                      child: FadeInUp(
                          duration: const Duration(milliseconds: 1200),
                          child: Container(
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/light-2.png'))),
                          )),
                    ),
                    Positioned(
                      right: 40,
                      top: 40,
                      width: 80,
                      height: 150,
                      child: FadeInUp(
                          duration: const Duration(milliseconds: 1300),
                          child: Container(
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/clock.png'))),
                          )),
                    ),
                    Positioned(
                      child: FadeInUp(
                          duration: const Duration(milliseconds: 1600),
                          child: Container(
                            margin: const EdgeInsets.only(top: 50),
                            child: Center(
                              child: Text(
                                "Login",
                                style: GoogleFonts.whisper(
                                    color: Colors.white,
                                    fontSize: 90,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    FadeInUp(
                        duration: const Duration(milliseconds: 1800),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color:
                                      const Color.fromRGBO(143, 148, 251, 1)),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromRGBO(143, 148, 251, .2),
                                    blurRadius: 20.0,
                                    offset: Offset(0, 10))
                              ]),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Color.fromRGBO(
                                                143, 148, 251, 1)))),
                                child: TextField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.email,
                                      color: Colors.blueAccent,
                                    ),
                                    border: InputBorder.none,
                                    hintText: "Email",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[700]),
                                    // contentPadding:
                                    // const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.password,
                                        color: Colors.blueAccent,
                                      ),
                                      border: InputBorder.none,
                                      hintText: "Password",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[700])),
                                ),
                              )
                            ],
                          ),
                        )),
                    const SizedBox(
                      height: 30,
                    ),
                    FadeInUp(
                        duration: const Duration(milliseconds: 1900),
                        child: GestureDetector(
                          onTap: () async {
                            if (await doLogin()) {
                              if (context.mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomePage(
                                            title: 'My Tasks',
                                          )),
                                );
                              }
                            }
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: const LinearGradient(colors: [
                                  Color.fromRGBO(143, 148, 251, 1),
                                  Color.fromRGBO(143, 148, 251, .6),
                                ])),
                            child: Center(
                              child: Text(
                                "Login",
                                style: GoogleFonts.abel(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )),
                    // const SizedBox(height: 70,),
                    // FadeInUp(duration: const Duration(milliseconds: 2000), child: const Text("Forgot Password?", style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),)),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
