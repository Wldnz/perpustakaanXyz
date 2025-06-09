import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:perpustakaanxyz/DetailBook.dart';
import 'package:perpustakaanxyz/DiscoverBooks.dart';
import 'package:perpustakaanxyz/components/NavigatorBottom.dart';
import 'package:perpustakaanxyz/models/Account.dart';
import 'package:perpustakaanxyz/models/Books.dart';
import '../utilities/Env.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  HashMap<String, dynamic> akun = HashMap();
  List<dynamic> books = List.empty();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    akun = await Account.getAccountById(Env.account["id"]);
    books = await Books.getAll();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: ,
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 100 * 5),
              Text("Selamat Datang, ${akun['name']}"),
              SizedBox(
                width: 350.0,
                child: Text(
                  "PerpustakaanXyz telah mengumpulkan buku-buku yang bermanfaat untuk anda temukan",
                  style: TextStyle(fontSize: 12.0, fontStyle: FontStyle.italic),
                ),
              ),
              SizedBox(height: 50.0),
              _bookSection(context, "Buku - Buku Populer", books),
              _bookSection(context, "Buku - Buku Terbaru", books),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Navigatorbottom(),
    );
  }

  SizedBox _bookSection(
    BuildContext context,
    String sectionName,
    List<dynamic> books,
  ) {
    return SizedBox(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 5.0, left: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  sectionName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                ),
                GestureDetector(
                  onTap:
                      () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) => Discoverbooks(
                                title: sectionName,
                                books: books,
                              ),
                        ),
                      ),
                  child: Icon(Icons.arrow_forward, size: 18.0),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 220.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children:
                  books.map((book) {
                    return GestureDetector(
                      onTap:
                          () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Detailbook(book: book),
                            ),
                          ),
                      child: Container(
                        width: 100.0,
                        height: 200.0,
                        margin: EdgeInsets.all(3.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image(
                              image: NetworkImage(book["image_url"]),
                              width: 100.0,
                              height: 150.0,
                              fit: BoxFit.fill,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: SizedBox(
                                height: 43.0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      book["title"],
                                      maxLines: 2,
                                      style: TextStyle(fontSize: 10.0),
                                    ),
                                    Text(
                                      "Stok : ${book["stock"]}",
                                      style: TextStyle(fontSize: 10.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
