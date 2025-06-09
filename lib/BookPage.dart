import 'package:flutter/material.dart';
import 'package:perpustakaanxyz/DetailBook.dart';
import 'package:perpustakaanxyz/components/NavigatorBottom.dart';
import 'package:perpustakaanxyz/models/Books.dart';

class Bookpage extends StatefulWidget {
  const Bookpage({super.key});

  @override
  @override
  State<Bookpage> createState() => _BookpageState();
}

class _BookpageState extends State<Bookpage> {
  String currentSelected = "Semua";
  List<dynamic> books = [];
  List<dynamic> currentBooks = [];
  String judulBuku = "";
  List<dynamic> statusBookFilters = [
    {
      "title": "Semua",
      "unselected": Colors.indigo,
      "selected": Colors.indigo.shade800,
    },
    {
      "title": "Tersedia",
      "unselected": Colors.green.shade400,
      "selected": Colors.green,
    },
    {
      "title": "Tidak Tersedia",
      "unselected": Colors.red.shade400,
      "selected": Colors.red,
    },
  ];

  _loadBooksByStatus() {
    if (books.isEmpty) [];
    currentBooks = [];
    if (currentSelected == "Semua") {
      books.map((book) {
        if (judulBuku.isNotEmpty &&
            book["title"].toString().toLowerCase().contains(
              judulBuku.toLowerCase(),
            )) {
          currentBooks.add(book);
        } else if (judulBuku.isEmpty) {
          currentBooks.add(book);
        }
      }).toList();
    } else if (currentSelected == "Tersedia") {
      books.map((book) {
        if (int.parse(book["stock"]) > 0) {
          if (judulBuku.isNotEmpty &&
              book["title"].toString().toLowerCase().contains(
                judulBuku.toLowerCase(),
              )) {
            currentBooks.add(book);
          } else if (judulBuku.isEmpty) {
            currentBooks.add(book);
          }
        }
      }).toList();
    } else if (currentSelected == "Tidak Tersedia") {
      books.map((book) {
        if (int.parse(book["stock"]) == 0) {
          if (judulBuku.isNotEmpty &&
              book["title"].toString().toLowerCase().contains(
                judulBuku.toLowerCase(),
              )) {
            currentBooks.add(book);
          } else if (judulBuku.isEmpty) {
            currentBooks.add(book);
          }
        }
      }).toList();
    }
    return currentBooks;
  }

  Future<void> _loadData() async {
    books = await Books.getAll();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(8.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: [
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 100 * 80,
                  height: 43.0,
                  child: TextField(
                    controller: TextEditingController(text: judulBuku),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Cari Buku Disini...",
                      hintStyle: TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),
                    style: TextStyle(fontSize: 14.0),
                    onChanged: (String value) => judulBuku = value,
                  ),
                ),
                SizedBox(
                  width: 53.0,
                  height: 53.0,
                  child: GestureDetector(
                    onTap: () => setState(() {}),
                    child: Card(
                      color: Colors.blueAccent,
                      child: Icon(Icons.search, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              children:
                  statusBookFilters.map((value) {
                    return _statusBook(
                      value["title"],
                      value["selected"],
                      value["unselected"],
                    );
                  }).toList(),
            ),
            SizedBox(height: 15.0),
            _bukuCard(context, _loadBooksByStatus()),
          ],
        ),
      ),
      bottomNavigationBar: Navigatorbottom(),
    );
  }

  GestureDetector _statusBook(String title, Color selected, Color unselected) {
    return GestureDetector(
      onTap: () {
        currentSelected = title;
        setState(() {});
      },
      child: Card(
        color: currentSelected == title ? selected : unselected,
        child: Padding(
          padding: const EdgeInsets.only(
            right: 16.0,
            left: 16.0,
            bottom: 4.0,
            top: 4.0,
          ),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13.0,
            ),
          ),
        ),
      ),
    );
  }
}

Wrap _bukuCard(BuildContext context, List<dynamic> books) {
  return Wrap(
    spacing: 10.0,
    runSpacing: 10.0,
    children:
        books.isEmpty
            ? [
              Center(
                child: Column(
                  spacing: 10.0,
                  children: [
                    SizedBox(height: 78.0),
                    Image(
                      image: AssetImage(
                        "public/icons/item-not-found-license.png",
                      ),
                      width: 150.0,
                      height: 150.0,
                    ),
                    Text("Tidak Dapat Menemukan Buku"),
                  ],
                ),
              ),
            ]
            : books.map((book) {
              return GestureDetector(
                onTap:
                    () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Detailbook(book: book),
                      ),
                    ),
                child: Container(
                  width: 100.0,
                  // height: 200.0,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
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
  );
}
