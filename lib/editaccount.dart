import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:perpustakaanxyz/AccountPage.dart';
import 'package:perpustakaanxyz/models/Account.dart';
import '../utilities/Env.dart';

class EditAccount extends StatefulWidget {
  const EditAccount({super.key, required this.account});

  final HashMap<String, dynamic> account;

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  HashMap<String, dynamic> editAkun = HashMap();
  HashMap<String, dynamic> account = HashMap();
  @override
  void initState() {
    super.initState();
    account = widget.account;
  }

  bool _checkDataIsDifferent() {
    var isDifferent = false;
    editAkun.forEach((key, value) {
      if (account[key] != value) {
        isDifferent = true;
        return;
      }
    });
    return isDifferent;
  }

  HashMap<String, dynamic> sendData() {
    HashMap<String, dynamic> data = HashMap();
    data["id"] = Env.account["id"];
    account.forEach((key, value) {
      if (editAkun.containsKey(key)) {
        data[key] = editAkun[key];
      } else {
        data[key] = account[key];
      }
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        titleTextStyle: TextStyle(fontSize: 18.0, color: Colors.black),
        actions: [
          SizedBox(
            width: 50.0,
            height: 50.0,
            child: GestureDetector(
              onTap: () {
                if (_checkDataIsDifferent()) {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: Text(
                            "Anda yakin ingin mengubah form menjadi data sebelum di ubah?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                editAkun.clear();
                                account = widget.account;
                                setState(() {});
                                Navigator.of(context).pop();
                              },
                              child: Text("Ya"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text("Tidak"),
                            ),
                          ],
                        ),
                  );
                }
              },
              child: Card(
                color: Colors.lightBlueAccent,
                child: Icon(Icons.refresh, weight: 10.0, color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            width: 50.0,
            height: 50.0,
            child: GestureDetector(
              onTap: () async {
                if (_checkDataIsDifferent()) {
                  var result = await Account.updateProfile(sendData());
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: Text(
                            result["isSuccess"]
                                ? "Berhasil Memperbarui Profil"
                                : "Gagal Dalam Memperbarui Profil",
                          ),
                          content: Text(result["message"]),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                if (result["isSuccess"]) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Accountpage(),
                                    ),
                                  );
                                }
                              },
                              child: Text("Close"),
                            ),
                          ],
                        ),
                  );
                }
              },
              child: Card(
                color: Colors.blueAccent,
                child: Icon(
                  Icons.check_sharp,
                  weight: 10.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              _fieldData("Nama", "Masukkan Nama Anda...", "name"),
              SizedBox(height: 10.0),
              _fieldData(
                "Nama Lengkap",
                "Masukkan Nama Lengkap...",
                "fullname",
              ),
              SizedBox(height: 10.0),
              _fieldData("Email", "Masukkan Email...", "email"),
              SizedBox(height: 10.0),
              _fieldData(
                "Nomor Telephone",
                "Masukkan Nomor Telephone...",
                "phone",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column _fieldData(String label, String hintext, String fieldName) {
    return Column(
      spacing: 5.0,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16.0)),
        TextField(
          controller: TextEditingController(text: account[fieldName]),
          style: TextStyle(fontSize: 14.0),
          keyboardType:
              fieldName == "phone" ? TextInputType.phone : TextInputType.text,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurple),
            ),
            hintText: hintext,
          ),
          onChanged: (value) {
            editAkun[fieldName] = value;
          },
        ),
      ],
    );
  }
}
