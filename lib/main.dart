import 'dart:io';

import 'package:banking/dashboard.dart';
import 'package:banking/model.dart';
import 'package:banking/signin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: splash(),
  ));
}

class splash extends StatefulWidget {
  const splash({Key? key}) : super(key: key);

  @override
  State<splash> createState() => _splashState();
}

class _splashState extends State<splash> {
  String font = "family 1";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    screen();
    permission();
  }

  permission() async {
    var status = await Permission.storage.status;

    if (status.isDenied) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
    } else if (status.isGranted) {
      _createFolder();
    }
  }

  _createFolder() async {
    final folderName = "Banking image";
    final path = Directory("storage/emulated/0/Download/$folderName");
    if ((await path.exists())) {
      // TODO:
      print("exist");
    } else {
      // TODO:
      print("not exist");
      path.create();
    }
  }

  screen() async {
    await Future.delayed(Duration(seconds: 3));

    share.sp = await SharedPreferences.getInstance();

    bool loginstatus = share.sp!.getBool("loginstatus") ?? false;

    if (loginstatus) {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return dashboard();
        },
      ));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return signin();
        },
      ));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset("animation/banklottie.json", width: 160, height: 160),
          Text(
            "Banking ERP System",
            style: TextStyle(
                color: Color(0xff27496D),
                fontFamily: font,
                fontWeight: FontWeight.bold,
                fontSize: 20),
          )
        ],
      )),
    );
  }
}
