import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:banking/main.dart';
import 'package:banking/model.dart';
import 'package:banking/signin.dart';
import 'package:banking/transaction.dart';
import 'package:clipboard/clipboard.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class dashboard extends StatefulWidget {
  const dashboard({Key? key}) : super(key: key);

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  String? type;

  String font = "family 1";

  String id = "";
  String name = "";
  String contact = "";
  String account = "";
  String email = "";
  String password = "";
  String imagepath = "";
  String imageurl = "";

  Map map = {};
  List l = [];
  bool status = false;

  int credit = 0;
  int debit = 0;
  int total = 0;
  List<int> totallist = [];

  PermissionStatus? pstatus;

  GlobalKey _globalKey = new GlobalKey();

  final folderpath = "storage/emulated/0/Download/Banking image";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    check();
  }

  check() async {
    pstatus = await Permission.storage.status;
    print("Checked");
  }

  Future<Uint8List> _capturePng() async {
    try {
      print('inside');
      RenderRepaintBoundary boundary = _globalKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png) as ByteData;
      var pngBytes = byteData.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);
      print(pngBytes);
      print(bs64);
      setState(() {});
      return pngBytes;
    } catch (e) {
      print(e);
    }
    return Future.value();
  }

  permission() async {
    //status = await Permission.storage.status;
    print(status);
    if (pstatus!.isDenied) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
    }
    if (await pstatus!.isGranted) {
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

  getdata() async {
    id = share.sp?.getString("id") ?? "";
    name = share.sp?.getString("name") ?? "";
    contact = share.sp?.getString("contact") ?? "";
    account = share.sp?.getString("account") ?? "";
    email = share.sp?.getString("email") ?? "";
    password = share.sp?.getString("password") ?? "";
    imagepath = share.sp?.getString("imagepath") ?? "";
    imageurl =
        "https://kevinsavaliya17.000webhostapp.com/apibanking/$imagepath";

    String usrid = share.sp!.getString("id") ?? "";

    Response response = await Dio().get(
        'https://kevinsavaliya17.000webhostapp.com/apibanking/viewtransaction.php?userid=$usrid');

    // debugPrint(response.data);

    map = jsonDecode(response.data);

    int result = map["Result"];

    if (result == 1) {
      l = map["Datalist"];
    }

    for (int i = 0; i < l.length; i++) {
      if (l[i]["type"] == '1') {
        credit = credit + int.parse(l[i]["amount"]);
      }
      if (l[i]["type"] == '0') {
        debit = debit + int.parse(l[i]["amount"]);
      }
      total = credit - debit;
      totallist.add(total);
      // print("credit : $credit");
      // print("Debit : $debit");
      // print("Total : $total");
    }
    // print(totallist);

    status = true;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            // backgroundColor: Color(0xff27496D),
            body: status
                ? Stack(
                    children: [
                      Container(
                        height: double.infinity,
                        width: double.infinity,
                        color: Color(0xff27496D),
                      ),
                      Positioned(
                          top: 50,
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(50),
                                      topRight: Radius.circular(50))),
                              height: 750,
                              width: MediaQuery.of(context).size.width,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: Container(
                                        child: Column(
                                          children: [
                                            Text(
                                              "Your Balance",
                                              style: TextStyle(
                                                  color: Color(0xff27496D),
                                                  fontSize: 12,
                                                  fontFamily: font),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.currency_rupee,
                                                  color: Colors.black54,
                                                  size: 25,
                                                ),
                                                Text(
                                                  "${total}.00",
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 25,
                                                      fontFamily: font),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Column(
                                        children: [
                                          Container(
                                            child: Text(
                                              "Account Number",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontFamily: font,
                                                  color: Colors.white60,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            alignment: Alignment.centerLeft,
                                            margin: EdgeInsets.only(
                                                top: 15, left: 15),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 15),
                                                child: Text(
                                                  "${account}",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontFamily: font,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  FlutterClipboard.copy(
                                                          '${account}')
                                                      .then((value) {
                                                    Fluttertoast.showToast(
                                                        msg: "Copied",
                                                        backgroundColor:
                                                            Colors.black54,
                                                        fontSize: 15,
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        textColor: Colors.white,
                                                        gravity: ToastGravity
                                                            .BOTTOM);
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.copy_rounded,
                                                  size: 18,
                                                  color: Colors.white54,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 50),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: Container(
                                                      height: 50,
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 15),
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              "Name",
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  fontFamily:
                                                                      font,
                                                                  color: Colors
                                                                      .white60,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 15,
                                                                    top: 8),
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              "${name}",
                                                              style: TextStyle(
                                                                  fontSize: 13,
                                                                  fontFamily:
                                                                      font,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    flex: 4),
                                                Expanded(
                                                  child: Container(
                                                    height: 50,
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "Valid upto",
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                fontFamily:
                                                                    font,
                                                                color: Colors
                                                                    .white60,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 8),
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "08/25",
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontFamily:
                                                                    font,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  flex: 2,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    height: 30,
                                                    width: 35,
                                                    child: Image.asset(
                                                        "images/card6.png"),
                                                  ),
                                                  flex: 2,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      height: 190,
                                      width: double.infinity,
                                      margin: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.bottomRight,
                                              end: Alignment.topRight,
                                              colors: [
                                                Colors.blue.shade600,
                                                Color(0xff27496D)
                                              ]),
                                          color: Color(0xff27496D),
                                          border: Border.all(
                                              width: 2,
                                              color: Color(0xff27496D)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 1,
                                                spreadRadius: 2,
                                                offset: Offset(3, 3))
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Row(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              type = "1";
                                              Navigator.pushAndRemoveUntil(
                                                  context, MaterialPageRoute(
                                                builder: (context) {
                                                  return transaction(
                                                      type: type);
                                                },
                                              ), (route) => false);
                                            },
                                            child: Text(
                                              "  Cash In  ",
                                              style: TextStyle(
                                                  color: Color(0xff2474c7),
                                                  fontFamily: font,
                                                  fontSize: 12),
                                            ),
                                            style: ButtonStyle(
                                                shadowColor:
                                                    MaterialStateProperty.all(
                                                        Colors.black),
                                                shape: MaterialStateProperty
                                                    .all(BeveledRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(7),
                                                        side: BorderSide(
                                                            width: 0.5,
                                                            color: Colors
                                                                .black12))),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.white)),
                                          ),
                                          Container(
                                            child: IconButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return CupertinoAlertDialog(
                                                      title: Text("Log Out"),
                                                      content: Text(
                                                          "Are you sure you want to Log Out?"),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                              share.sp!.clear();
                                                              Navigator
                                                                  .pushReplacement(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                                  return signin();
                                                                },
                                                              ));
                                                              setState(() {});
                                                            },
                                                            child: Text("Yes")),
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text("No"))
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              icon: Icon(
                                                Icons
                                                    .power_settings_new_rounded,
                                                color: Color(0xff2474c7),
                                              ),
                                            ),
                                            height: 40,
                                            width: 40,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black12,
                                                      blurRadius: 1,
                                                      spreadRadius: 1,
                                                      offset: Offset(0, 1))
                                                ],
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                    width: 0.3,
                                                    color: Colors.black12)),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              type = "0";
                                              Navigator.pushAndRemoveUntil(
                                                  context, MaterialPageRoute(
                                                builder: (context) {
                                                  return transaction(
                                                      type: type);
                                                },
                                              ), (route) => false);
                                            },
                                            child: Text(
                                              "Cash Out ",
                                              style: TextStyle(
                                                  color: Color(0xff2474c7),
                                                  fontFamily: font,
                                                  fontSize: 12),
                                            ),
                                            style: ButtonStyle(
                                                shadowColor:
                                                    MaterialStateProperty.all(
                                                        Colors.black),
                                                shape: MaterialStateProperty
                                                    .all(BeveledRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(7),
                                                        side: BorderSide(
                                                            width: 0.5,
                                                            color: Colors
                                                                .black12))),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.white)),
                                          )
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                      ),
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              2,
                                      width: MediaQuery.of(context).size.width,
                                      child: ListView.builder(
                                        itemBuilder: (context, index) {
                                          Map m = l[index];

                                          trasaction t = trasaction.fromJson(m);

                                          return InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                context: context,
                                                builder: (context) {
                                                  return Container(
                                                      height: 500,
                                                      margin:
                                                          EdgeInsets.all(10),
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Expanded(
                                                            flex: 8,
                                                            child:
                                                                RepaintBoundary(
                                                              key: _globalKey,
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    border: Border.all(
                                                                        width:
                                                                            2,
                                                                        color: Color(
                                                                            0xff27496D))),
                                                                height: 350,
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                child: Column(
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                          Container(
                                                                        child:
                                                                            Text(
                                                                          "Remark",
                                                                          style: TextStyle(
                                                                              color: Colors.black54,
                                                                              fontFamily: font),
                                                                        ),
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                20,
                                                                            top:
                                                                                10,
                                                                            bottom:
                                                                                5),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                          Container(
                                                                        child:
                                                                            Text(
                                                                          "${t.info}",
                                                                          style: TextStyle(
                                                                              color: Color(0xff27496D),
                                                                              fontSize: 20,
                                                                              fontFamily: font),
                                                                        ),
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                20,
                                                                            top:
                                                                                5,
                                                                            bottom:
                                                                                5),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                          Container(
                                                                        child:
                                                                            Text(
                                                                          "Transaction Amount ",
                                                                          style: TextStyle(
                                                                              color: Colors.black54,
                                                                              fontFamily: font),
                                                                        ),
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                20,
                                                                            top:
                                                                                20,
                                                                            bottom:
                                                                                5),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                          Container(
                                                                        child: Text(
                                                                            "${t.amount}",
                                                                            style: t.type == '1'
                                                                                ? TextStyle(color: Colors.green, fontFamily: font, fontSize: 25)
                                                                                : TextStyle(color: Colors.red, fontFamily: font, fontSize: 20)),
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        margin: EdgeInsets.only(
                                                                            top:
                                                                                5,
                                                                            bottom:
                                                                                5,
                                                                            left:
                                                                                20),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                          Container(
                                                                        child:
                                                                            Text(
                                                                          "Timing",
                                                                          style: TextStyle(
                                                                              color: Colors.black54,
                                                                              fontFamily: font),
                                                                        ),
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                20,
                                                                            top:
                                                                                20,
                                                                            bottom:
                                                                                5),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                          Container(
                                                                        child:
                                                                            Text(
                                                                          "${t.date}",
                                                                          style: TextStyle(
                                                                              fontFamily: font,
                                                                              fontSize: 15,
                                                                              color: Color(0xff27496D)),
                                                                        ),
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        margin: EdgeInsets.only(
                                                                            top:
                                                                                5,
                                                                            left:
                                                                                20,
                                                                            bottom:
                                                                                5),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  GFButton(
                                                                    onPressed:
                                                                        () {
                                                                      showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return CupertinoAlertDialog(
                                                                            title:
                                                                                Text("Delete Transaction"),
                                                                            content:
                                                                                Text("Are you sure you want to delete transaction?"),
                                                                            actions: [
                                                                              TextButton(
                                                                                  onPressed: () async {
                                                                                    String id = t.id!;

                                                                                    var url = Uri.parse('https://kevinsavaliya17.000webhostapp.com/apibanking/deletetransaction.php?id=$id');
                                                                                    var response = await http.get(url);

                                                                                    print(response.body);

                                                                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                                                                                      builder: (context) {
                                                                                        return dashboard();
                                                                                      },
                                                                                    ), (route) => false);

                                                                                    setState(() {
// Navigator.pop(context);
                                                                                    });
                                                                                  },
                                                                                  child: Text("Yes")),
                                                                              TextButton(
                                                                                  onPressed: () {
                                                                                    setState(() {
                                                                                      Navigator.pop(context);
                                                                                    });
                                                                                  },
                                                                                  child: Text("No"))
                                                                            ],
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                    text:
                                                                        "Delete",
                                                                    textStyle: TextStyle(
                                                                        fontFamily:
                                                                            font,
                                                                        fontSize:
                                                                            12),
                                                                    icon: Icon(
                                                                      CupertinoIcons
                                                                          .delete_solid,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 17,
                                                                    ),
                                                                    shape: GFButtonShape
                                                                        .pills,
                                                                    color: Color(
                                                                        0xff27496D),
                                                                  ),
                                                                  GFButton(
                                                                    color: Colors
                                                                        .green,
                                                                    onPressed:
                                                                        () async {
                                                                      if (pstatus!
                                                                          .isGranted) {
                                                                        await _capturePng()
                                                                            .then((value) {
                                                                          // print(
                                                                          //     value);

                                                                          DateTime
                                                                              d =
                                                                              DateTime.now();

                                                                          String
                                                                              imgname =
                                                                              "${d.year}${d.month}${d.day}${d.hour}${d.minute}${d.second}";

                                                                          String
                                                                              imgpath =
                                                                              "$folderpath/Bank$imgname.png";

                                                                          // print(
                                                                          //     imgpath);

                                                                          File
                                                                              file =
                                                                              File(imgpath);

                                                                          file
                                                                              .writeAsBytes(value)
                                                                              .then((value) {
                                                                            Share.shareFiles([
                                                                              file.path
                                                                            ], text: "Banking App By Kevin Savaliya");
                                                                          });
                                                                        });
                                                                      } else if (pstatus!
                                                                          .isDenied) {
                                                                        permission();
                                                                      }

                                                                      setState(
                                                                          () {});
                                                                    },
                                                                    text:
                                                                        "share",
                                                                    textStyle: TextStyle(
                                                                        fontFamily:
                                                                            font,
                                                                        fontSize:
                                                                            12),
                                                                    icon: Icon(
                                                                      Icons
                                                                          .share_rounded,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 17,
                                                                    ),
                                                                    shape: GFButtonShape
                                                                        .pills,
                                                                  ),
                                                                  GFButton(
                                                                    color: Color(
                                                                        0xff27496D),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pushAndRemoveUntil(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                        builder:
                                                                            (context) {
                                                                          return transaction(
                                                                            t: t,
                                                                          );
                                                                        },
                                                                      ),
                                                                          (route) =>
                                                                              false);
                                                                    },
                                                                    text:
                                                                        "Edit",
                                                                    textStyle: TextStyle(
                                                                        fontFamily:
                                                                            font,
                                                                        fontSize:
                                                                            12),
                                                                    icon: Icon(
                                                                      Icons
                                                                          .edit_off_rounded,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 17,
                                                                    ),
                                                                    shape: GFButtonShape
                                                                        .pills,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ));
                                                },
                                              );
                                            },
                                            child: Stack(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top: 10,
                                                      bottom: 10,
                                                      right: 15,
                                                      left: 15),
                                                  height: 100,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                            blurRadius: 1,
                                                            spreadRadius: 1,
                                                            color:
                                                                Colors.black26,
                                                            offset:
                                                                Offset(1, 1))
                                                      ],
                                                      // border: Border.all(width: 0.5,color: Colors.black12),
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                ),
                                                Positioned(
                                                  child: Text(
                                                    "${t.info}",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: font,
                                                        color:
                                                            Color(0xff27496D)),
                                                  ),
                                                  top: 30,
                                                  left: 25,
                                                ),
                                                Positioned(
                                                  child: t.type == '1'
                                                      ? Text(
                                                          "${t.amount} cr",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.green,
                                                              fontFamily: font,
                                                              fontSize: 17),
                                                        )
                                                      : Text(
                                                          "${t.amount} dr",
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontFamily: font,
                                                              fontSize: 17),
                                                        ),
                                                  right: 35,
                                                  top: 28,
                                                ),
                                                Positioned(
                                                  child: Text(
                                                    "Balance : ${totallist[index]}",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontFamily: font,
                                                        color:
                                                            Color(0xff27496D)),
                                                  ),
                                                  right: 25,
                                                  bottom: 20,
                                                ),
                                                Positioned(
                                                  child: Text(
                                                    " ${t.date}",
                                                    style: TextStyle(
                                                        color: Colors.black54,
                                                        fontFamily: font,
                                                        fontSize: 12),
                                                  ),
                                                  bottom: 20,
                                                  left: 25,
                                                ),
                                                Positioned(
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 30),
                                                    height: 1,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.2,
                                                    color: Colors.black12,
                                                    alignment: Alignment.center,
                                                  ),
                                                  bottom: 45,
                                                  left: 30,
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                        itemCount: l.length,
                                      ),
                                    )
                                  ],
                                ),
                              )))
                    ],
                  )
                : Center(
                    child: CircularProgressIndicator(
                    color: Color(0xff274960),
                  ))),
        onWillPop: backfun);
  }

  Future<bool> backfun() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Exit"),
          content: Text("Do you want to exit from app?"),
          actions: [
            TextButton(
                onPressed: () {
                  setState(() {
                    Navigator.of(context).pop(true);
                  });
                },
                child: Text(
                  "Yes",
                  style: TextStyle(color: Color(0xff27496D)),
                )),
            TextButton(
                onPressed: () {
                  setState(() {
                    Navigator.of(context).pop(false);
                  });
                },
                child: Text(
                  "No",
                  style: TextStyle(color: Color(0xff27496D)),
                ))
          ],
        );
      },
    );
    return Future.value();
  }
}

class trasaction {
  String? id;
  String? userid;
  String? amount;
  String? date;
  String? info;
  String? type;

  trasaction(
      {this.id, this.userid, this.amount, this.date, this.info, this.type});

  trasaction.fromJson(Map json) {
    id = json['id'];
    userid = json['userid'];
    amount = json['amount'];
    date = json['date'];
    info = json['info'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['amount'] = this.amount;
    data['date'] = this.date;
    data['info'] = this.info;
    data['type'] = this.type;
    return data;
  }
}
