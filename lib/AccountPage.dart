import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:perpustakaanxyz/LoginPage.dart';
import 'package:perpustakaanxyz/components/NavigatorBottom.dart';
import 'package:perpustakaanxyz/editaccount.dart';
import 'package:perpustakaanxyz/models/Account.dart';
import '../utilities/Env.dart';
import 'package:perpustakaanxyz/verificationPage.dart';

class Accountpage extends StatefulWidget {
  const Accountpage({super.key});

  @override
  State<Accountpage> createState() => _AccountpageState();
}

class _AccountpageState extends State<Accountpage> {
  HashMap<String, dynamic> account = HashMap();
  HashMap<String, dynamic> personalAccount = HashMap();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    account = await Account.getAccountById(Env.account["id"]);
    personalAccount = await Account.getPersonalAccount();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children:
              account.isEmpty
                  ? [
                    SizedBox(
                      height: 250.0,
                      child: Center(
                        child: Text(
                          "Sedang Mengambil Data...",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ]
                  : [
                    SizedBox(height: 40.0),
                    SizedBox(
                      width: 250.0,
                      height: 100.0,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                  "https://res.cloudinary.com/ddiulakke/image/upload/v1747055039/vecteezy_profile-icon-design-vector_5544718_cje74w.jpg",
                                ),
                                radius: 25.0,
                              ),
                              SizedBox(width: 10.0),
                              Expanded(
                                child: Wrap(
                                  direction: Axis.vertical,
                                  children: [
                                    Text(
                                      account["fullname"],
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        //
                                      ),
                                    ),
                                    Text(
                                      "Anggota",
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                        //
                                      ),
                                    ),
                                    SizedBox(height: 3.0),
                                    Row(
                                      spacing: 5.0,
                                      children: [
                                        Text(
                                          personalAccount.isNotEmpty &&
                                                  personalAccount["status"] ==
                                                      "wait"
                                              ? "Menunggu Verifikasi"
                                              : account["status"] == "verified"
                                              ? "Terverifikasi"
                                              : personalAccount["status"] ==
                                                  "fail"
                                              ? "Gagal Verifikasi"
                                              : "Belum Verifikasi",
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            backgroundColor:
                                                personalAccount.isNotEmpty &&
                                                        personalAccount["status"] ==
                                                            "wait"
                                                    ? Colors.amber
                                                    : account["status"] ==
                                                        "verified"
                                                    ? Colors.green
                                                    : Colors.red,
                                          ),
                                        ),
                                        Icon(
                                          personalAccount.isNotEmpty &&
                                                  personalAccount["status"] ==
                                                      "wait"
                                              ? Icons.pending_actions_sharp
                                              : account["status"] == "verified"
                                              ? Icons.verified
                                              : Icons.error,
                                          color:
                                              personalAccount.isNotEmpty &&
                                                      personalAccount["status"] ==
                                                          "wait"
                                                  ? Colors.amber
                                                  : account["status"] ==
                                                      "verified"
                                                  ? Colors.green
                                                  : Colors.red,
                                          size: 15.0,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10.0),
                              SizedBox(
                                width: 40.0,
                                height: 40.0,
                                child: Card(
                                  color: Colors.blueAccent,
                                  child: GestureDetector(
                                    onTap:
                                        () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder:
                                                (context) => EditAccount(
                                                  account: account,
                                                ),
                                          ),
                                        ),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 40.0,
                                height: 40.0,
                                child: Card(
                                  color: Colors.red,
                                  child: GestureDetector(
                                    onTap:
                                        () => showDialog(
                                          context: context,
                                          builder:
                                              (context) => AlertDialog(
                                                title: Text(
                                                  "Apakah anda ingin keluar?",
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(
                                                        context,
                                                      ).pushReplacement(
                                                        MaterialPageRoute(
                                                          builder:
                                                              (context) =>
                                                                  LoginPage(),
                                                        ),
                                                      );
                                                      Env.currentIndexNavigationBar =
                                                          0;
                                                    },
                                                    child: Text("yes"),
                                                  ),
                                                  TextButton(
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                        ),
                                                    child: Text("no"),
                                                  ),
                                                ],
                                              ),
                                        ),
                                    child: Icon(
                                      Icons.logout,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 60.0),
                    _buttonInformasi(
                      context,
                      "Verifikasi Akun",
                      Verificationpage(),
                    ),
                    SizedBox(height: 15),
                  ],
        ),
      ),
      bottomNavigationBar: Navigatorbottom(),
    );
  }

  SizedBox _buttonInformasi(
    BuildContext context,
    String title,
    Widget destination,
  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 100 * 80,
      child: GestureDetector(
        onTap:
            () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => destination)),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.5),
                ),
                Icon(
                  personalAccount.isNotEmpty &&
                          personalAccount["status"] == "wait"
                      ? Icons.pending_actions_sharp
                      : account["status"] == "verified"
                      ? Icons.verified
                      : Icons.error,
                  color:
                      personalAccount.isNotEmpty &&
                              personalAccount["status"] == "wait"
                          ? Colors.amber
                          : account["status"] == "verified"
                          ? Colors.green
                          : Colors.red,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
