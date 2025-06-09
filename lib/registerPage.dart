import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:perpustakaanxyz/LoginPage.dart';
import 'package:perpustakaanxyz/models/Account.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  HashMap<String, String> registerData = HashMap();

  bool isFailedLogin = false;
  bool isDifferentPassword = false;
  bool isSuccessCreateAccount = false;

  bool checkIsSamePassword() {
    if (registerData.containsKey("password") &&
        registerData.containsKey("confirm-password")) {
      if (registerData["password"] == registerData["confirm-password"]) {
        return true;
      }
    }
    return false;
  }

  bool checkIsSameAllFilled() {
    var expectedFields = {
      "name",
      "fullname",
      "email",
      "password",
      "confirm-password",
    };
    for (var value in expectedFields) {
      if (!registerData.containsKey(value)) {
        return false;
      }
    }
    return true;
  }

  clearFields() {
    var expectedFields = {
      "name",
      "fullname",
      "email",
      "password",
      "confirm-password",
    };
    for (var value in expectedFields) {
      if (registerData.containsKey(value)) {
        registerData[value] = "";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20.0),
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
                        ? isDifferentPassword
                            ? "Password & Konfirmasi Password Berbeda"
                            : "Pastikan semua kolom sudah terisi, silahkan coba lagi"
                        : isSuccessCreateAccount
                        ? "Buat Akun Berhasil, Silahkan login"
                        : "Silahkan register untuk mempunyai hak sebagai anggota kami",
                    style: TextStyle(
                      fontSize: 12.0,
                      color:
                          isFailedLogin
                              ? Colors.red
                              : isSuccessCreateAccount
                              ? Colors.green
                              : Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 30.0),
                _fieldText("Nama", "Masukkan Nama..", "name"),
                SizedBox(height: 15.0),
                _fieldText(
                  "Nama Lengkap",
                  "Masukkan Nama Lengkap..",
                  "fullname",
                ),
                SizedBox(height: 15.0),
                _fieldText("Email", "Masukkan Email..", "email"),
                SizedBox(height: 15.0),
                _fieldText("Password", "Masukkan Password..", "password"),
                SizedBox(height: 15.0),
                _fieldText(
                  "Konfirmasi Password",
                  "Masukkan Konfirmasi..",
                  "confirm-password",
                ),
                SizedBox(height: 15.0),
                GestureDetector(
                  onTap: () async {
                    if (checkIsSameAllFilled()) {
                      isFailedLogin = false;
                      isDifferentPassword = false;
                      if (checkIsSamePassword()) {
                        var result = await Account.register(registerData);
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: Text(
                                  result["isSuccess"]
                                      ? "Berhasil Membuat Akun"
                                      : "Gagal Membuat Akun",
                                ),
                                content: Text(result["message"]),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("OK!"),
                                  ),
                                ],
                              ),
                        );
                        if (result["isSuccess"]) {
                          clearFields();
                          isSuccessCreateAccount = result["isSuccess"];
                          setState(() {});
                          return;
                        }
                      } else {
                        isDifferentPassword = true;
                      }
                    }
                    isFailedLogin = true;
                    setState(() {});
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 10.0,
                    height: 48.0,
                    child: Card(
                      color: Colors.blueAccent,
                      child: Center(
                        child: Text(
                          "Buat Akun",
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
                    Text("Sudah punya akun? "),
                    GestureDetector(
                      onTap:
                          () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          ),
                      child: Text(
                        "Login disini...",
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column _fieldText(String label, String hintext, String fieldname) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5.0,
      children: [
        Text(label, style: TextStyle(fontSize: 14.5)),
        TextField(
          controller: TextEditingController(text: registerData[fieldname]),
          obscureText: fieldname.contains("password"),
          style: TextStyle(fontSize: 13.0),
          keyboardType:
              fieldname.contains("email")
                  ? TextInputType.emailAddress
                  : TextInputType.text,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurple),
            ),
            hintText: hintext,
          ),
          onSubmitted: (String value) {
            if (fieldname.contains("password")) {
              setState(() {});
            }
          },
          onChanged: (String value) => registerData[fieldname] = value,
        ),
      ],
    );
  }
}
