import 'dart:convert';

import 'package:banking/dashboard.dart';
import 'package:banking/model.dart';
import 'package:banking/signup.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class signin extends StatefulWidget {
  const signin({Key? key}) : super(key: key);

  @override
  State<signin> createState() => _signinState();
}

class _signinState extends State<signin> {
  TextEditingController tname = TextEditingController();
  TextEditingController tpassword = TextEditingController();

  bool usererror = false;
  bool passerror = false;

  bool hidepass = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff27496D),
      body: Stack(
        children: [
          Positioned(
              child: Container(
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Container(
                      child: Image.asset("images/login1.png"),
                      height: 200,
                      width: 200,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Register In",
                        style: TextStyle(color: Colors.black54, fontSize: 25),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 10, bottom: 10),
                      child: TextField(
                        controller: tname,
                        textCapitalization: TextCapitalization.words,
                        onChanged: (value) {
                          setState(() {
                            usererror = false;
                          });
                        },
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            // focusColor: Colors.yellow,
                            // hintText: "Enter Name",
                            filled: true,
                            fillColor: Color(0xffd6deee),
                            labelText: "UserName",
                            labelStyle: TextStyle(color: Colors.black54),
                            errorText: usererror
                                ? "Please Enter Valid Username"
                                : null,
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(30),
                                    bottomRight: Radius.circular(5),
                                    bottomLeft: Radius.circular(30)),
                                borderSide: BorderSide(color: Colors.black54)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(30),
                                    bottomRight: Radius.circular(5),
                                    bottomLeft: Radius.circular(30)),
                                borderSide: BorderSide(color: Colors.black54)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black54),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(30),
                                    bottomRight: Radius.circular(5),
                                    bottomLeft: Radius.circular(30))),
                            hoverColor: Color(0xffd6deee),
                            enabled: true,
                            prefixIcon: Icon(
                              Icons.account_circle,
                              color: Colors.black54,
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black54),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(30),
                                    bottomRight: Radius.circular(5),
                                    bottomLeft: Radius.circular(30)))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 10, bottom: 10),
                      child: TextField(
                        controller: tpassword,
                        onChanged: (value) {
                          setState(() {
                            passerror = false;
                          });
                        },
                        cursorColor: Colors.black,
                        obscureText: hidepass,
                        decoration: InputDecoration(
                            // hintText: "Enter Password",
                            labelText: "Password",
                            labelStyle: TextStyle(color: Colors.black54),
                            helperText:
                                "Password Must Be In [ A-Z, a-z, 0-9, sp.char ]",
                            helperStyle: TextStyle(fontSize: 9),
                            filled: true,
                            prefixIcon: Icon(
                              Icons.password_outlined,
                              color: Colors.black54,
                              size: 20,
                            ),
                            errorText: passerror
                                ? "Please Enter Valid Password"
                                : null,
                            fillColor: Color(0xffd6deee),
                            hoverColor: Color(0xffd6deee),
                            enabled: true,
                            suffixIcon: hidepass
                                ? IconButton(
                                    onPressed: () {
                                      hidepass = !hidepass;
                                      setState(() {});
                                    },
                                    icon: Icon(
                                      Icons.visibility,
                                      size: 20,
                                      color: Colors.black54,
                                    ))
                                : IconButton(
                                    onPressed: () {
                                      hidepass = !hidepass;
                                      setState(() {});
                                    },
                                    icon: Icon(
                                      Icons.visibility_off,
                                      size: 20,
                                      color: Colors.black54,
                                    )),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(30),
                                    bottomRight: Radius.circular(5),
                                    bottomLeft: Radius.circular(30)),
                                borderSide: BorderSide(color: Colors.black54)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(30),
                                    bottomRight: Radius.circular(5),
                                    bottomLeft: Radius.circular(30)),
                                borderSide: BorderSide(color: Colors.black54)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black54),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(30),
                                    bottomRight: Radius.circular(5),
                                    bottomLeft: Radius.circular(30))),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black54),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(30),
                                    bottomRight: Radius.circular(5),
                                    bottomLeft: Radius.circular(30)))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: ElevatedButton(
                          onPressed: () async {
                            String username = tname.text;
                            String password = tpassword.text;

                            if (username.isEmpty) {
                              usererror = true;
                            } else {
                              usererror = false;
                            }

                            if (password.isEmpty) {
                              passerror = true;
                            } else {
                              passerror = false;
                            }

                            if (usererror == false && passerror == false) {
                              Response response = await Dio().get(
                                  "https://kevinsavaliya17.000webhostapp.com/apibanking/banksignin.php?username=$username&password=$password");

                              print(response.data);

                              Map mp = jsonDecode(response.data);

                              int connection = mp['Connection'];

                              if (connection == 1) {
                                int result = mp['Result'];
                                if (result == 1) {

                                  share.sp?.setBool("loginstatus", true);

                                  userdata ud = userdata.fromJson(mp['Data']);

                                  String? id = ud.id;
                                  String? name = ud.name;
                                  String? contact = ud.contact;
                                  String? account = ud.account;
                                  String? email = ud.email;
                                  String? password = ud.password;
                                  String? imagepath = ud.imagepath;

                                  share.sp!.setString("id", id!);
                                  share.sp!.setString("name", name!);
                                  share.sp!.setString("contact", contact!);
                                  share.sp!.setString("account", account!);
                                  share.sp!.setString("email", email!);
                                  share.sp!.setString("password", password!);
                                  share.sp!.setString("imagepath", imagepath!);


                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(
                                    builder: (context) {
                                      return dashboard();
                                    },
                                  ));
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      "Invalid user and password",
                                      style:
                                          TextStyle(color: Color(0xff27496D)),
                                    ),
                                    backgroundColor: Colors.white,
                                  ));
                                }
                              }
                            }

                            setState(() {});
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xff27496D)),
                              minimumSize: MaterialStateProperty.all(
                                  Size(double.infinity, 55)),
                              textStyle: MaterialStateProperty.all(
                                  TextStyle(fontSize: 18)),
                              side: MaterialStateProperty.all(BorderSide(
                                  color: Color(0xff27496D),
                                  width: 1,
                                  style: BorderStyle.solid)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          topRight: Radius.circular(30),
                                          bottomRight: Radius.circular(5),
                                          bottomLeft: Radius.circular(30))))),
                          child: Text(
                            "Log In",
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have any account ?",
                            style: TextStyle(color: Colors.black54),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(
                                builder: (context) {
                                  return signup();
                                },
                              ));
                            },
                            child: RichText(
                                text: TextSpan(children: [
                              // TextSpan(
                              //     text: " Don't have any account ?",
                              //     style: TextStyle(
                              //         color: Colors.black54,
                              //         fontWeight: FontWeight.bold,
                              //         fontSize: 15)),
                              TextSpan(
                                  text: " Sign Up ",
                                  style: TextStyle(
                                      color: Color(0xff27496D),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500))
                            ])),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black54,
                      blurRadius: 5,
                      spreadRadius: 3,
                      offset: Offset(1, 3))
                ],
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(50),
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(5))),
            margin: EdgeInsets.only(left: 20, right: 20, top: 80, bottom: 50),
            height: 750,
            width: double.infinity,
          ))
        ],
      ),
    );
  }
}
class userdata {
  String? id;
  String? name;
  String? contact;
  String? account;
  String? email;
  String? password;
  String? imagepath;

  userdata(
      {this.id,
        this.name,
        this.contact,
        this.account,
        this.email,
        this.password,
        this.imagepath});

  userdata.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    contact = json['contact'];
    account = json['account'];
    email = json['email'];
    password = json['password'];
    imagepath = json['imagepath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['contact'] = this.contact;
    data['account'] = this.account;
    data['email'] = this.email;
    data['password'] = this.password;
    data['imagepath'] = this.imagepath;
    return data;
  }
}
