import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:perpustakaanxyz/Dashboard.dart';
import 'package:perpustakaanxyz/models/Account.dart';
import 'package:perpustakaanxyz/registerPage.dart';
import 'package:perpustakaanxyz/utilities/Env.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  HashMap<String, String> loginData = HashMap();

  bool isFailedLogin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10.0),
              Image(
                image: AssetImage("public/icons/icon.png"),
                width: 80.0,
                height: 90.0,
              ),
              // TextField
              Text(
                "Selamat Datang, Di PerpustakaanXyz",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 250.0,
                child: Text(
                  isFailedLogin
                      ? "Data yang dimasukkan tidak valid, silahkan coba lagi"
                      : "Silahkan login untuk memiliki hak sebagai anggota kami",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: isFailedLogin ? Colors.red : Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 30.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5.0,
                children: [
                  Text("Username", style: TextStyle(fontSize: 16.0)),
                  TextField(
                    style: TextStyle(fontSize: 13.0),
                    decoration: InputDecoration(
                      // hintStyle:
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple),
                      ),
                      hintText: "Masukkan username",
                    ),
                    onChanged: (String value) => loginData["username"] = value,
                  ),
                ],
              ),
              SizedBox(height: 15.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5.0,
                children: [
                  Text("Password", style: TextStyle(fontSize: 16.0)),
                  TextField(
                    obscureText: true,
                    style: TextStyle(fontSize: 13.0),
                    decoration: InputDecoration(
                      // hintStyle:
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                      hintText: "Masukkan password",
                    ),
                    onChanged: (String value) => loginData["password"] = value,
                  ),
                ],
              ),
              SizedBox(height: 15.0),
              GestureDetector(
                onTap: () async {
                  if (await Account.login(
                    loginData["username"]!,
                    loginData["password"]!,
                  )) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => Dashboard()),
                    );
                  } else {
                    isFailedLogin = true;
                    setState(() {});
                  }
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 10.0,
                  height: 48.0,
                  child: Card(
                    color: Colors.blueAccent,
                    child: Center(
                      child: Text(
                        "Masuk",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Belum punya akun? "),
                  GestureDetector(
                    onTap:
                        () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ),
                        ),
                    child: Text(
                      "Daftar disini...",
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
