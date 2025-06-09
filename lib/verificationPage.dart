import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:perpustakaanxyz/AccountPage.dart';
import 'package:perpustakaanxyz/models/Account.dart';
import 'package:perpustakaanxyz/utilities/Env.dart';

class Verificationpage extends StatefulWidget {
  const Verificationpage({super.key});

  @override
  State<Verificationpage> createState() => _VerificationpageState();
}

class _VerificationpageState extends State<Verificationpage> {
  final ImagePicker picker = ImagePicker();
  HashMap<String, dynamic> account = HashMap();
  var cloudinary = Env.cloudinary;
  bool showPersonalData = false;
  File? image;
  XFile? imageX;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    account = await Account.getPersonalAccount();
    setState(() {});
  }

  Future<void> takeImageFrom(ImageSource source) async {
    try {
      XFile? file = await picker.pickImage(source: source);
      if (file == null) return;
      image = File(file.path);
      imageX = file;
    } catch (error) {
      print(error);
    }
  }

  bool checkIsHasAllFields() {
    var expectedFields = {
      "name",
      "fullname",
      "email",
      "status",
      "id",
      "id_user",
      "address",
      "identify_type",
      "identify_image",
      "profile_image",
      "status_user",
      "created_at",
      "updated_at",
    };
    for (var field in expectedFields) {
      if (!account.containsKey((field))) {
        return false;
      }
    }
    return true;
  }

  bool checkIsAllFill() {
    account["id"] = Env.account["id"];
    var expectedFields = {"id", "address", "identify_type", "status_user"};
    for (var field in expectedFields) {
      if (!account.containsKey(field)) {
        return false;
      } else if (account.containsKey(field) &&
          account[field].toString().isEmpty) {
        return false;
      }
    }
    return true;
  }

  HashMap<String, dynamic> sedData() {
    HashMap<String, dynamic> result = HashMap();
    result["id"] = Env.account["id"];
    var expectedFields = {
      "address",
      "identify_type",
      "identify_image",
      "status_user",
    };
    for (var field in expectedFields) {
      if (!account.containsKey(field)) {
        return HashMap();
      } else if (account.containsKey(field) &&
          account[field].toString().isEmpty) {
        return HashMap();
      } else if (account.containsKey(field) &&
          account[field].toString().isNotEmpty) {
        result[field] = account[field];
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            !checkIsHasAllFields()
                ? Text("Form Verifikasasi")
                : account["status"] == "wait"
                ? Row(
                  spacing: 5.0,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Menuggu Verifikasi",
                      style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.pending_actions_sharp,
                      color: Colors.amber,
                      size: 20.0,
                    ),
                  ],
                )
                : Row(
                  spacing: 5.0,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      account["status"] == "success"
                          ? "Terverifikasi"
                          : "Belum Terverikasi",
                      style: TextStyle(
                        color:
                            account["status"] == "success"
                                ? Colors.green
                                : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      account["status"] == "success"
                          ? Icons.verified
                          : Icons.error_sharp,
                      color:
                          account["status"] == "success"
                              ? Colors.green
                              : Colors.red,
                      size: 20.0,
                    ),
                  ],
                ),
        titleTextStyle: TextStyle(fontSize: 18.0, color: Colors.black),
        actions:
            checkIsHasAllFields() && account["status"] != "fail"
                ? [
                  GestureDetector(
                    onTap: () {
                      showPersonalData = !showPersonalData;
                      setState(() {});
                    },
                    child: SizedBox(
                      width: 45.0,
                      height: 45.0,
                      child: Card(
                        color:
                            showPersonalData ? Colors.red : Colors.blueAccent,
                        child: Icon(
                          showPersonalData
                              ? Icons.remove_red_eye_rounded
                              : Icons.security_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ]
                : [
                  GestureDetector(
                    onTap: () async {
                      if (image == null ||
                          imageX == null ||
                          !checkIsAllFill()) {
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: Text(
                                  "Pastikan Semua Kolom Sudah Terisi!",
                                ),
                                content: Text(
                                  "Pastikan semua kolom sudah terisi, silahkan coba lagi!",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("Coba Lagi"),
                                  ),
                                ],
                              ),
                        );
                      } else {
                        try {
                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: Text("Sedang memproses data...."),
                                  content: Text(
                                    "membutuhkan waktu yang sekitar 1-10 detik...",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("OK!"),
                                    ),
                                  ],
                                ),
                          );
                          var result = await cloudinary.upload(
                            file: image.toString(),
                            fileBytes: await imageX?.readAsBytes(),
                            fileName:
                                "identifty_type-${DateTime.now().millisecondsSinceEpoch.toString()}",
                            folder: "PerpustakaanXyz/identify",
                          );
                          if (result.isSuccessful) {
                            account["identify_image"] = result.secureUrl;
                            var data = sedData();
                            print(data);
                            if (data.isNotEmpty) {
                              var result =
                                  await Account.sendVerificationRequest(data);
                              await showDialog(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: Text(
                                        result["isSuccess"]
                                            ? "Berhasil melakukan request.."
                                            : "Gagal dalam melakukan request..",
                                      ),
                                      content: Text(result["message"]),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            if (result["isSuccess"]) {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) =>
                                                          Accountpage(),
                                                ),
                                              );
                                            }
                                          },
                                          child:
                                              result["isSuccess"]
                                                  ? Text("OK!")
                                                  : Text("Coba Lagi"),
                                        ),
                                      ],
                                    ),
                              );
                              return;
                            }
                          }
                        } catch (error) {
                          print(error);
                        }
                        await showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: Text("Terjadi kesalahan"),
                                content: Text(
                                  "Telah terjadi kesalahan saat ingin merequest verifikasi akun",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("Coba Lagi"),
                                  ),
                                ],
                              ),
                        );
                      }
                    },
                    child: SizedBox(
                      width: 45.0,
                      height: 45.0,
                      child: Card(
                        color: Colors.blueAccent,
                        child: Icon(Icons.check_outlined, color: Colors.white),
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
            children:
                !checkIsHasAllFields()
                    ? [
                      _fieldData(
                        "Alamat",
                        "Masukkan alamat rumah...",
                        "address",
                      ),
                      SizedBox(height: 15.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tipe Identifikasi",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          SizedBox(height: 5.0),
                          DropdownMenu(
                            width: 250.0,
                            hintText: "Tipe Identitas",
                            dropdownMenuEntries: [
                              DropdownMenuEntry(
                                value: "Kartu Pelajar",
                                label: "Kartu Pelajar",
                              ),
                              DropdownMenuEntry(value: "KTP", label: "KTP"),
                              DropdownMenuEntry(value: "KIP", label: "KIP"),
                            ],
                            onSelected:
                                (String? value) =>
                                    account["identify_type"] = value,
                          ),
                        ],
                      ),
                      SizedBox(height: 15.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Status", style: TextStyle(fontSize: 16.0)),
                          SizedBox(height: 5.0),
                          DropdownMenu(
                            width: 200.0,
                            hintText: "Status Pengguna",
                            dropdownMenuEntries: [
                              DropdownMenuEntry(
                                value: "student",
                                label: "Pelajar",
                              ),
                              DropdownMenuEntry(
                                value: "worker",
                                label: "Pekerja",
                              ),
                            ],
                            onSelected:
                                (String? value) =>
                                    account["status_user"] = value,
                          ),
                          SizedBox(height: 15.0),
                          _identifyImageSection(context),
                          SizedBox(height: 25.0),
                          Text(
                            "Keuntungan Akun Terverifikasi",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "1. Dapat melakukan permintaan peminjaman buku",
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ],
                      ),
                    ]
                    // section 2
                    : [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _fieldData(
                            "Alamat",
                            "Masukkan alamat rumah...",
                            "address",
                          ),
                          SizedBox(height: 15.0),
                          account["status"] != "success" &&
                                  account["status"] != "wait"
                              ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Tipe Identifikasi",
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  SizedBox(height: 5.0),
                                  DropdownMenu(
                                    width:
                                        MediaQuery.of(context).size.width /
                                        100 *
                                        90,
                                    hintText: "Tipe Identitas",
                                    controller: TextEditingController(
                                      text: account["identify_type"],
                                    ),
                                    dropdownMenuEntries: [
                                      DropdownMenuEntry(
                                        value: "Kartu Pelajar",
                                        label: "Kartu Pelajar",
                                      ),
                                      DropdownMenuEntry(
                                        value: "KTP",
                                        label: "KTP",
                                      ),
                                      DropdownMenuEntry(
                                        value: "KIP",
                                        label: "KIP",
                                      ),
                                    ],
                                  ),
                                ],
                              )
                              : _fieldData(
                                "Tipe Identifikasi",
                                "Masukkan alamat rumah...",
                                "identify_type",
                              ),
                          SizedBox(height: 15.0),
                          // status user such as worker or student
                          account["status"] != "success" &&
                                  account["status"] != "wait"
                              ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Status Anggota",
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  SizedBox(height: 5.0),
                                  DropdownMenu(
                                    width:
                                        MediaQuery.of(context).size.width /
                                        100 *
                                        90,
                                    hintText: "Status Pengguna",
                                    controller: TextEditingController(
                                      text:
                                          account["status_user"] == "student"
                                              ? "Pelajar"
                                              : "Worker",
                                    ),
                                    dropdownMenuEntries: [
                                      DropdownMenuEntry(
                                        value: "student",
                                        label: "Pelajar",
                                      ),
                                      DropdownMenuEntry(
                                        value: "worker",
                                        label: "Pekerja",
                                      ),
                                    ],
                                  ),
                                ],
                              )
                              : _fieldData(
                                "Status Anggota",
                                "Masukkan alamat rumah...",
                                "status_user",
                              ),
                          SizedBox(height: 15.0),
                          _identifyImageSection(context),
                        ],
                      ),
                    ],
          ),
        ),
      ),
    );
  }

  Column _identifyImageSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Lampiran Foto Identifikasi", style: TextStyle(fontSize: 18.0)),
        SizedBox(height: 15.0),
        GestureDetector(
          onTap: () {
            if (!checkIsHasAllFields() ||
                account["status"] != "success" && account["status"] != "wait") {
              showDialog(
                context: context,
                builder:
                    (context) => Dialog(
                      child: SizedBox(
                        height: 130.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [_ambilFoto(), _ambilGambar(context)],
                        ),
                      ),
                    ),
              );
            }
          },
          child: Image(
            image:
                image == null && !checkIsHasAllFields() ||
                        account["status"] == "fail"
                    ? image == null
                        ? AssetImage("public/images/image-not-found.png")
                        : FileImage(image as File)
                    : image != null
                    ? FileImage(image as File)
                    : showPersonalData && checkIsHasAllFields()
                    ? NetworkImage(account["identify_image"])
                    : AssetImage("public/images/image-not-found.png"),
            width: MediaQuery.of(context).size.width / 100 * 90,
            height: 300.0,
            fit: BoxFit.fill,
          ),
        ),
      ],
    );
  }

  SizedBox _ambilGambar(BuildContext context) {
    return SizedBox(
      child: GestureDetector(
        onTap: () async {
          await takeImageFrom(ImageSource.gallery);
          Navigator.pop(context);
          setState(() {});
        },
        child: Card(
          color: Colors.blueAccent,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              spacing: 5.0,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera, color: Colors.white),
                Text(
                  "AMBIL GAMBAR",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _ambilFoto() {
    return SizedBox(
      child: GestureDetector(
        onTap: () async {
          await takeImageFrom(ImageSource.camera);
          Navigator.pop(context);
          setState(() {});
        },
        child: Card(
          color: Colors.red,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              spacing: 5.0,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera, color: Colors.white),
                Text(
                  "AMBIL FOTO",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
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
          enabled: !checkIsHasAllFields() || account["status"] == "fail",
          controller: TextEditingController(text: account[fieldName]),
          obscureText:
              checkIsAllFill() &&
              account["status"] != "fail" &&
              !showPersonalData,
          style: TextStyle(fontSize: 14.0),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurple),
            ),
            hintText: hintext,
          ),
          onChanged: (value) {
            account[fieldName] = value;
          },
        ),
      ],
    );
  }
}
