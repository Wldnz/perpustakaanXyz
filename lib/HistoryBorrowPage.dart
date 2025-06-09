import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:perpustakaanxyz/components/NavigatorBottom.dart';
import 'package:perpustakaanxyz/models/Books.dart';

class Historyborrowpage extends StatefulWidget {
  const Historyborrowpage({super.key});

  @override
  State<Historyborrowpage> createState() => _HistoryborrowpageState();
}

class _HistoryborrowpageState extends State<Historyborrowpage> {
  var historys = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    historys = await Books.showHistoryBorrowedBooks();
    print(historys);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(8.0),
        // color: Colors.red,
        child: ListView.builder(
          itemCount: historys.length,
          itemBuilder:
              (context, index) => _cardHistoryBook(context, historys[index]),
        ),
      ),
      bottomNavigationBar: Navigatorbottom(),
    );
  }

  SizedBox _cardHistoryBook(BuildContext context, Map borrowedBook) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 10.0,
      height: 200.0,
      child: Card(
        color: const Color.fromARGB(255, 181, 207, 220),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // img,
              Text(
                borrowedBook["title"],
                maxLines: 1,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Status"),
                  Card(
                    color:
                        borrowedBook["status"] == "fail"
                            ? Colors.red
                            : borrowedBook["status"] == "returned" ||
                                borrowedBook["status"] == "borrowed"
                            ? Colors.green
                            : Colors.amber,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        borrowedBook["status"] == "fail"
                            ? "Gagal"
                            : borrowedBook["status"] == "returned"
                            ? "Dikembalikan"
                            : borrowedBook["status"] == "borrowed"
                            ? "Dipinjam"
                            : "Menunggu",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Tanggal Dipinjam"),
                  Text(
                    DateTime.fromMillisecondsSinceEpoch(
                      int.parse(borrowedBook["borrowed_at"]),
                    ).toString().split(" ")[0],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Tanggal Dibalikin"),
                  Text(
                    DateTime.fromMillisecondsSinceEpoch(
                      int.parse(borrowedBook["borrowed_at"]),
                    ).toString().split(" ")[0],
                  ),
                ],
              ),
              borrowedBook["status"] != "wait"
                  ? SizedBox()
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap:
                            () => showDialog(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: Text(
                                      "Apakah Anda Yakin Ingin Membatalkan?",
                                    ),
                                    content: Text(
                                      "Apakah Anda Yakin Ingin Membatalkan Permintaan Peminjaman Buku?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed:
                                            () => Navigator.of(context).pop(),
                                        child: Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          var response =
                                              await Books.sendRequestCancelBorrowBook(
                                                borrowedBook["id_borrowed"],
                                              );
                                          if (response) {
                                            Navigator.pop(context);
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                        Historyborrowpage(),
                                              ),
                                            );
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder:
                                                  (context) => AlertDialog(
                                                    title: Text(
                                                      "gagal dalam membatalkan request peminjaman",
                                                    ),
                                                    content: Text(
                                                      "gagal dalam melakukan pembatalan terkait permintaan peminjaman",
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                        },
                                                        child: Text("OK!"),
                                                      ),
                                                    ],
                                                  ),
                                            );
                                          }
                                        },
                                        child: Text("Ya!"),
                                      ),
                                    ],
                                  ),
                            ),
                        child: SizedBox(
                          child: Column(
                            children: [
                              Card(
                                color: Colors.red,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "Batalkan Peminjaman",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
