import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:perpustakaanxyz/models/Account.dart';
import 'package:perpustakaanxyz/models/Books.dart';
import 'package:perpustakaanxyz/utilities/Env.dart';

class Detailbook extends StatefulWidget {
  const Detailbook({super.key, required this.book});

  final dynamic book;

  @override
  State<Detailbook> createState() => _DetailbookState();
}

class _DetailbookState extends State<Detailbook> {
  var book = {};
  HashMap<String, dynamic> account = HashMap();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    book = widget.book;
    _loadData();
  }

  Future<void> _loadData() async {
    account = await Account.getAccountById(Env.account["id"]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book["title"]),
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 16.0),
        actions: [
          GestureDetector(
            onTap: () async {
              if (int.parse(book["stock"]) <= 0) return;
              if (account.isNotEmpty && account["status"] == "verified") {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: Text(
                          "Melakukan Request Peminjaman Buku ${book["title"]}",
                        ),
                        content: Text(
                          "Harap menunggu untuk mengirim request permintan...",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("OK!"),
                          ),
                        ],
                      ),
                );
                var result = await Books.sendRequestBorrowBook(book["id"]);
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: Text(
                          "${result["isSuccess"] ? "Berhasil" : "Gagal"} Melakukan Request Peminjaman Buku ${book["title"]}",
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
              }
            },
            child: SizedBox(
              width: 50.0,
              height: 50.0,
              child: Card(
                color:
                    int.parse(book["stock"]) <= 0
                        ? Colors.red.shade300
                        : account.isNotEmpty && account["status"] == "verified"
                        ? Colors.blueAccent
                        : Colors.blueAccent.shade100,
                child: Icon(
                  Icons.import_contacts,
                  color: Colors.white,
                  size: 25.0,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 35.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 5.0),
                    Image(
                      image: NetworkImage(book["image_url"]),
                      width: 150.0,
                      height: 200.0,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(width: 9.0),
                    Wrap(
                      direction: Axis.vertical,
                      spacing: 2.0,
                      children: [
                        _customText(book['title'], true),
                        _customText("Penulis: \n${book["author"]}", false),
                        _customText("Publisher: \n${book["publisher"]}", false),
                        _customText(
                          "Tahun Terbit: ${book["publication_year"]}",
                          false,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 25.0),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5.0,
                    children: [
                      Text(
                        "Deskripsi",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          //
                        ),
                      ),
                      Text(
                        book["description"] ?? "-",
                        style: TextStyle(fontSize: 14.0),
                      ),
                      SizedBox(height: 11.0),
                      Text(
                        "Informasi Tambahan",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          //
                        ),
                      ),
                      _customTextV2("ISBN 10: ${book["isbn_10"] ?? ""}", false),
                      _customTextV2("ISBN 13: ${book["isbn_13"] ?? ""}", false),
                      _customTextV2(
                        "Buku Edisi: ${book["edition_number"] ?? ""}",
                        false,
                      ),
                      _customTextV2(
                        "Jumlah Halaman: ${book["total_pages"]} Halaman",
                        false,
                      ),
                      _customTextV2(
                        "Kategori: ${book["category"] ?? ""}",
                        false,
                      ),
                      _customTextV2("Bahasa: ${book["language"] ?? ""}", false),
                      _customTextV2(
                        "Tersedia: ${book["stock"]} Buku Salinan",
                        false,
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        "Hubungi Kami Melalui",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          //
                        ),
                      ),
                      SizedBox(height: 2.0),
                      _contactField(
                        "(21) 1231212",
                        Icon(Icons.phone, size: 20.0),
                        false,
                      ),
                      SizedBox(height: 2.0),
                      _contactField(
                        "perpustakaan@xyz.org",
                        Icon(Icons.email, size: 20.0, color: Colors.pinkAccent),
                        false,
                      ),
                      SizedBox(height: 2.0),
                      _contactField(
                        "PerpustakaanXyz",
                        Icon(Icons.facebook, size: 20.0, color: Colors.blue),
                        false,
                      ),
                      SizedBox(height: 2.0),
                      _contactField(
                        "(62+) 8123456789",
                        Icon(Icons.phone, size: 20.0, color: Colors.green),
                        false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _contactField(String label, Icon icon, bool isBold) {
    return Row(
      spacing: 5.0,
      children: [
        icon,
        Text(
          label,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            //
          ),
        ),
      ],
    );
  }

  SizedBox _customText(String text, bool isBold) {
    return SizedBox(
      width: 180.0,
      child: Text(
        text,
        maxLines: 3,
        style: TextStyle(
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontSize: isBold ? 16.0 : 14.0,
          //
        ),
      ),
    );
  }

  SizedBox _customTextV2(String text, bool isBold) {
    return SizedBox(
      child: Text(
        text,
        maxLines: 3,
        style: TextStyle(
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontSize: isBold ? 16.0 : 14.0,
          //
        ),
      ),
    );
  }
}
