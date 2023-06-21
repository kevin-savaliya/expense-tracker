import 'dart:convert';

import 'package:banking/dashboard.dart';
import 'package:banking/model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class transaction extends StatefulWidget {
  String? type;
  trasaction? t;

  transaction({this.type, this.t}); //additional argument

  @override
  State<transaction> createState() => _transactionState();
}

class _transactionState extends State<transaction> {
  TextEditingController tdate = TextEditingController();
  TextEditingController tprice = TextEditingController();
  TextEditingController tinfo = TextEditingController();

  bool perror = false;
  bool infoerror = false;
  bool dateerror = false;

  String font = "family 1";

  String uid = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tdate.text = "";

    if (widget.t != null) {
      tprice.text = widget.t!.amount!;
      tinfo.text = widget.t!.info!;
      tdate.text = widget.t!.date!;
      uid = widget.t!.id!;
      widget.type = widget.t!.type;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                  // child: Text("${widget.type}",style: TextStyle(fontSize: 30,color: Colors.white),),
                  height: double.infinity,
                  width: double.infinity,
                  color: Color(0xff27496D)),
              Positioned(
                  child: Container(
                margin: EdgeInsets.only(top: 100),
                height: 700,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        topLeft: Radius.circular(50))),
                child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          child: widget.type == "1"
                              ? Text(
                                  "Credit Transaction",
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontFamily: font,
                                      color: Color(0xff27496D)),
                                )
                              : Text(
                                  "Debit Transaction",
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontFamily: font,
                                      color: Color(0xff27496D)),
                                ),
                          height: 100,
                          alignment: Alignment.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 10, bottom: 10),
                          child: TextField(
                            // style: widget.type == '1'
                            //     ? TextStyle(color: Colors.green)
                            //     : TextStyle(color: Colors.red),
                            controller: tprice,
                            textCapitalization: TextCapitalization.words,
                            onChanged: (value) {
                              setState(() {
                                perror = false;
                              });
                            },
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                                // focusColor: Colors.yellow,
                                // hintText: "Enter Name",
                                filled: true,
                                fillColor: Color(0xffd6deee),
                                labelText: "Amount",
                                labelStyle: TextStyle(color: Colors.black54),
                                errorText:
                                    perror ? "Please Enter Valid Amount" : null,
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(20)),
                                    borderSide:
                                        BorderSide(color: Colors.black54)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(20)),
                                    borderSide:
                                        BorderSide(color: Colors.black54)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black54),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(20))),
                                hoverColor: Color(0xffd6deee),
                                enabled: true,
                                prefixIcon: Icon(
                                  Icons.currency_rupee_rounded,
                                  size: 20,
                                  color: Colors.black54,
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black54),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(20)))),keyboardType: TextInputType.number,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 10, bottom: 10),
                          child: TextField(
                            controller: tdate,
                            // textCapitalization: TextCapitalization.words,
                            onChanged: (value) {
                              setState(() {
                                dateerror = false;
                              });
                            },
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: () async {
                                    DateTime? datepick = await showDatePicker(
                                        builder: (context, child) {
                                          return Theme(
                                              data: Theme.of(context).copyWith(
                                                  colorScheme:
                                                      ColorScheme.fromSeed(
                                                          seedColor: Color(
                                                              0xff27496D)),
                                                  primaryColor:
                                                      Color(0xff27496D)),
                                              child: child!);
                                        },
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2050));

                                    if (datepick != null) {
                                      print(datepick);
                                      String formatdate =
                                          DateFormat("dd-MM-yyyy")
                                              .format(datepick);

                                      setState(() {
                                        tdate.text = formatdate;
                                      });
                                    }
                                  },
                                  icon: Icon(Icons.calendar_month_rounded),
                                  iconSize: 20,
                                ),
                                // focusColor: Colors.yellow,
                                // hintText: "Enter Name",
                                filled: true,
                                fillColor: Color(0xffd6deee),
                                labelText: "Date",
                                labelStyle: TextStyle(color: Colors.black54),
                                errorText: dateerror
                                    ? "Please Select Valid Date"
                                    : null,
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(20)),
                                    borderSide:
                                        BorderSide(color: Colors.black54)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(20)),
                                    borderSide:
                                        BorderSide(color: Colors.black54)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black54),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(20))),
                                hoverColor: Color(0xffd6deee),
                                enabled: true,
                                prefixIcon: Icon(
                                  Icons.date_range_rounded,
                                  size: 20,
                                  color: Colors.black54,
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black54),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(20)))),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 10, bottom: 10),
                          child: TextField(
                            controller: tinfo,
                            textCapitalization: TextCapitalization.words,
                            onChanged: (value) {
                              setState(() {
                                infoerror = false;
                              });
                            },
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                                // focusColor: Colors.yellow,
                                // hintText: "Enter Name",
                                filled: true,
                                fillColor: Color(0xffd6deee),
                                labelText: "Remark",
                                labelStyle: TextStyle(color: Colors.black54),
                                errorText: infoerror
                                    ? "Please Enter Valid Remark"
                                    : null,
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(20)),
                                    borderSide:
                                        BorderSide(color: Colors.black54)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(20)),
                                    borderSide:
                                        BorderSide(color: Colors.black54)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black54),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(20))),
                                hoverColor: Color(0xffd6deee),
                                enabled: true,
                                prefixIcon: Icon(
                                  Icons.info_outline_rounded,
                                  size: 20,
                                  color: Colors.black54,
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black54),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(20)))),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: ElevatedButton(
                              onPressed: () async {
                                String amount = tprice.text;
                                String date = tdate.text;
                                String info = tinfo.text;

                                String userid = share.sp!.getString("id") ?? "";

                                if (amount.isEmpty) {
                                  perror = true;
                                } else {
                                  perror = false;
                                }

                                if (date.isEmpty) {
                                  dateerror = true;
                                } else {
                                  dateerror = false;
                                }

                                if (info.isEmpty) {
                                  infoerror = true;
                                } else {
                                  infoerror = false;
                                }

                                if (perror == false &&
                                    dateerror == false &&
                                    infoerror == false &&
                                    widget.t == null) {
                                  var formData = FormData.fromMap({
                                    'userid': userid,
                                    'amount': amount,
                                    'date': date,
                                    'info': info,
                                    'type': widget.type
                                  });
                                  var response = await Dio().post(
                                      'https://kevinsavaliya17.000webhostapp.com/apibanking/addtransaction.php',
                                      data: formData);

                                  print(response.data);

                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(
                                    builder: (context) {
                                      return dashboard();
                                    },
                                  ));
                                }

                                if (perror == false &&
                                    dateerror == false &&
                                    infoerror == false &&
                                    widget.t != null) {
                                  var formData = FormData.fromMap({
                                    'id': uid,
                                    'amount': amount,
                                    'date': date,
                                    'info': info,
                                    'type': widget.t!.type
                                  });
                                  var response = await Dio().post(
                                      'https://kevinsavaliya17.000webhostapp.com/apibanking/edittransaction.php',
                                      data: formData);

                                  // print(response.data);

                                  Map m1 = jsonDecode(response.data);

                                  int result = m1["Result"];

                                  if (result == 1) {
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(
                                      builder: (context) {
                                        return dashboard();
                                      },
                                    ));
                                  }
                                }

                                setState(() {});
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color(0xff27496D)),
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
                                          borderRadius:
                                              BorderRadius.circular(20)))),
                              child: Text("Save")),
                        )
                      ],
                    );
                  },
                ),
              ))
            ],
          ),
        ),
        onWillPop: backfun);
  }

  Future<bool> backfun() {
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return dashboard();
      },
    ));
    return Future.value();
  }
}
