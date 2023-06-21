import 'dart:convert';
import 'dart:io';

import 'package:banking/signin.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class signup extends StatefulWidget {
  const signup({Key? key}) : super(key: key);

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  String path = "";

  final ImagePicker _picker = ImagePicker();

  TextEditingController tname = TextEditingController();
  TextEditingController tcontact = TextEditingController();
  TextEditingController tacnumber = TextEditingController();
  TextEditingController temail = TextEditingController();
  TextEditingController tpass = TextEditingController();

  bool hidepass = true;
  bool nameerror = false;
  bool contacterror = false;
  bool acerror = false;
  bool emailerror = false;
  bool passerror = false;

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
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return SimpleDialog(
                                title: Text("Select Your Choice"),
                                children: [
                                  ListTile(
                                    onTap: () async {
                                      Navigator.pop(context);
                                      final XFile? photo =
                                          await _picker.pickImage(
                                              source: ImageSource.camera);

                                      setState(() {
                                        path = photo!.path;
                                      });
                                    },
                                    title: Text(
                                      "Camera",
                                      style: TextStyle(
                                        color: Color(0xff27496D),
                                      ),
                                    ),
                                    leading: Icon(
                                      CupertinoIcons.photo_camera_solid,
                                      color: Color(0xff27496D),
                                    ),
                                  ),
                                  ListTile(
                                    onTap: () async {
                                      Navigator.pop(context);
                                      final XFile? photo =
                                          await _picker.pickImage(
                                              source: ImageSource.gallery);

                                      setState(() {
                                        path = photo!.path;
                                      });
                                    },
                                    title: Text("Gallery",
                                        style: TextStyle(
                                          color: Color(0xff27496D),
                                        )),
                                    leading: Icon(
                                      CupertinoIcons.photo_fill,
                                      color: Color(0xff27496D),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 5,
                                    spreadRadius: 5,
                                    offset: Offset(0, 0))
                              ],
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                  width: 1, color: Color(0xff27496D))),
                          child: path.isEmpty
                              ? CircleAvatar(
                                  backgroundColor: Color(0xff27496D),
                                  backgroundImage:
                                      AssetImage("images/user1.png"),
                                )
                              : Container(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Image.file(
                                    File(path),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
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
                            nameerror = false;
                          });
                        },
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          // focusColor: Colors.yellow,
                          // hintText: "Enter Name",
                          filled: true,
                          fillColor: Color(0xffd6deee),
                          labelText: "Name",
                          labelStyle: TextStyle(color: Colors.black54),
                          errorText:
                              nameerror ? "Please Enter Valid Name" : null,
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(5),
                                  bottomRight: Radius.circular(30),
                                  bottomLeft: Radius.circular(5)),
                              borderSide: BorderSide(color: Colors.black54)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(5),
                                  bottomRight: Radius.circular(30),
                                  bottomLeft: Radius.circular(5)),
                              borderSide: BorderSide(color: Colors.black54)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black54),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(30),
                                bottomLeft: Radius.circular(5)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black54),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(30),
                                bottomLeft: Radius.circular(5)),
                          ),
                          hoverColor: Color(0xffd6deee),
                          enabled: true,
                          prefixIcon: Icon(
                            Icons.account_circle,
                            size: 20,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 10, bottom: 10),
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        controller: tcontact,
                        textCapitalization: TextCapitalization.words,
                        onChanged: (value) {
                          setState(() {
                            contacterror = false;
                          });
                        },
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          // focusColor: Colors.yellow,
                          // hintText: "Enter Name",
                          filled: true,
                          fillColor: Color(0xffd6deee),
                          labelText: "Mobile No.",
                          labelStyle: TextStyle(color: Colors.black54),
                          errorText: contacterror
                              ? "Please Enter Valid Mobile No."
                              : null,
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(5),
                                  bottomRight: Radius.circular(30),
                                  bottomLeft: Radius.circular(5)),
                              borderSide: BorderSide(color: Colors.black54)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(5),
                                  bottomRight: Radius.circular(30),
                                  bottomLeft: Radius.circular(5)),
                              borderSide: BorderSide(color: Colors.black54)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black54),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(30),
                                bottomLeft: Radius.circular(5)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black54),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(30),
                                bottomLeft: Radius.circular(5)),
                          ),
                          hoverColor: Color(0xffd6deee),
                          enabled: true,
                          prefixIcon: Icon(
                            Icons.phone,
                            size: 20,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 10, bottom: 10),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        maxLength: 12,
                        controller: tacnumber,
                        textCapitalization: TextCapitalization.words,
                        onChanged: (value) {
                          setState(() {
                            acerror = false;
                          });
                        },
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          // focusColor: Colors.yellow,
                          // hintText: "Enter Name",
                          filled: true,
                          fillColor: Color(0xffd6deee),
                          labelText: "Account No.",
                          helperText: "In Number Letter",
                          helperStyle: TextStyle(fontSize: 10),
                          labelStyle: TextStyle(color: Colors.black54),
                          errorText:
                              acerror ? "Please Enter Valid Account No." : null,
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(5),
                                  bottomRight: Radius.circular(30),
                                  bottomLeft: Radius.circular(5)),
                              borderSide: BorderSide(color: Colors.black54)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(5),
                                  bottomRight: Radius.circular(30),
                                  bottomLeft: Radius.circular(5)),
                              borderSide: BorderSide(color: Colors.black54)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black54),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(30),
                                bottomLeft: Radius.circular(5)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black54),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(30),
                                bottomLeft: Radius.circular(5)),
                          ),
                          hoverColor: Color(0xffd6deee),
                          enabled: true,
                          prefixIcon: Icon(
                            Icons.account_balance_rounded,
                            size: 20,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 10, bottom: 10),
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: temail,
                        textCapitalization: TextCapitalization.words,
                        onChanged: (value) {
                          setState(() {
                            emailerror = false;
                          });
                        },
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          // focusColor: Colors.yellow,
                          // hintText: "Enter Name",
                          filled: true,
                          fillColor: Color(0xffd6deee),
                          labelText: "E-mail",
                          labelStyle: TextStyle(color: Colors.black54),
                          errorText:
                              emailerror ? "Please Enter Valid E-mail" : null,
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(5),
                                  bottomRight: Radius.circular(30),
                                  bottomLeft: Radius.circular(5)),
                              borderSide: BorderSide(color: Colors.black54)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(5),
                                  bottomRight: Radius.circular(30),
                                  bottomLeft: Radius.circular(5)),
                              borderSide: BorderSide(color: Colors.black54)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black54),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(30),
                                bottomLeft: Radius.circular(5)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black54),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(30),
                                bottomLeft: Radius.circular(5)),
                          ),
                          hoverColor: Color(0xffd6deee),
                          enabled: true,
                          prefixIcon: Icon(
                            Icons.mail,
                            size: 20,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 10, bottom: 10),
                      child: TextField(
                        obscureText: hidepass,
                        controller: tpass,
                        textCapitalization: TextCapitalization.words,
                        onChanged: (value) {
                          setState(() {
                            passerror = false;
                          });
                        },
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hidepass = !hidepass;
                                });
                              },
                              icon: hidepass
                                  ? Icon(
                                      Icons.visibility,
                                      size: 20,
                                      color: Colors.black54,
                                    )
                                  : Icon(
                                      Icons.visibility_off,
                                      size: 20,
                                      color: Colors.black54,
                                    )),
                          // focusColor: Colors.yellow,
                          // hintText: "Enter Name",
                          filled: true,
                          fillColor: Color(0xffd6deee),
                          labelText: "Password",
                          labelStyle: TextStyle(color: Colors.black54),
                          errorText:
                              passerror ? "Please Enter Valid Password" : null,
                          helperText:
                              "Password Must Be In [ A-Z, a-z, 0-9, sp.char ]",
                          helperStyle: TextStyle(fontSize: 9),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(5),
                                  bottomRight: Radius.circular(30),
                                  bottomLeft: Radius.circular(5)),
                              borderSide: BorderSide(color: Colors.black54)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(5),
                                  bottomRight: Radius.circular(30),
                                  bottomLeft: Radius.circular(5)),
                              borderSide: BorderSide(color: Colors.black54)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black54),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(30),
                                bottomLeft: Radius.circular(5)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black54),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(30),
                                bottomLeft: Radius.circular(5)),
                          ),
                          hoverColor: Color(0xffd6deee),
                          enabled: true,
                          prefixIcon: Icon(
                            Icons.lock_outline_sharp,
                            size: 20,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: ElevatedButton(
                          onPressed: () async {
                            String name = tname.text;
                            String contact = tcontact.text;
                            String account = tacnumber.text;
                            String email = temail.text;
                            String password = tpass.text;

                            DateTime d = DateTime.now();

                            String imgname =
                                "${name}${d.year}${d.month}${d.day}${d.hour}${d.minute}${d.second}.jpg";

                            if (name.isEmpty) {
                              nameerror = true;
                            } else {
                              nameerror = false;
                            }

                            if (!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)')
                                    .hasMatch(contact) ||
                                contact.length < 10) {
                              contacterror = true;
                            } else {
                              contacterror = false;
                            }

                            if (account.isEmpty) {
                              acerror = true;
                            } else {
                              acerror = false;
                            }

                            if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(email) ||
                                email.isEmpty) {
                              emailerror = true;
                            } else {
                              emailerror = false;
                            }

                            if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                                    .hasMatch(password) ||
                                password.isEmpty) {
                              passerror = true;
                            } else {
                              passerror = false;
                            }

                            if (nameerror == false &&
                                contacterror == false &&
                                acerror == false &&
                                emailerror == false &&
                                passerror == false) {
                              var formData = FormData.fromMap({
                                'name': name,
                                'contact': contact,
                                'account': account,
                                'email': email,
                                'password': password,
                                'file': await MultipartFile.fromFile(path,
                                    filename: imgname),
                              });
                              var response = await Dio().post(
                                  'https://kevinsavaliya17.000webhostapp.com/apibanking/banksignup.php',
                                  data: formData);

                              print(response.data);

                              Map map = jsonDecode(response.data);

                              int connection = map['Connection'];

                              if (connection == 1) {
                                int result = map['Result'];

                                if (result == 0) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      "Sorry! Don't have any account",
                                      style:
                                          TextStyle(color: Color(0xff27496D)),
                                    ),
                                    backgroundColor: Colors.white,
                                  ));
                                }
                                if (result == 1) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      "Registered Successfully",
                                      style:
                                          TextStyle(color: Color(0xff27496D)),
                                    ),
                                    backgroundColor: Colors.white,
                                  ));
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(
                                    builder: (context) {
                                      return signin();
                                    },
                                  ));
                                }
                                if (result == 2) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      "User Already Sign In",
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
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(5),
                                    bottomRight: Radius.circular(30),
                                    bottomLeft: Radius.circular(5)),
                              ))),
                          child: Text(
                            "Register",
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account ? ",
                            style: TextStyle(color: Colors.black54),
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(
                                  builder: (context) {
                                    return signin();
                                  },
                                ));
                                setState(() {});
                              },
                              child: RichText(
                                  text: TextSpan(
                                      text: " Log In ",
                                      style: TextStyle(
                                          color: Color(0xff27496D),
                                          fontSize: 16))))
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black54,
                      blurRadius: 5,
                      spreadRadius: 3,
                      offset: Offset(1, 3))
                ],
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5),
                    topLeft: Radius.circular(50),
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(50))),
            height: 700,
            width: double.infinity,
            margin: EdgeInsets.only(left: 20, right: 20, top: 80, bottom: 40),
          ))
        ],
      ),
    );
  }
}
