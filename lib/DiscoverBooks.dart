import 'package:flutter/material.dart';
import 'package:perpustakaanxyz/DetailBook.dart';

class Discoverbooks extends StatefulWidget {
  const Discoverbooks({super.key, required this.title, required this.books});

  final String title;
  final List<dynamic> books;

  @override
  @override
  State<Discoverbooks> createState() => _DiscoverbooksState();
}

class _DiscoverbooksState extends State<Discoverbooks> {
  String currentSelected = "Semua";
  List<dynamic> currentBooks = [];
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
    if (currentSelected == "Semua") {
      currentBooks = widget.books;
    } else if (currentSelected == "Tersedia") {
      currentBooks = [];
      widget.books.map((book) {
        if (int.parse(book["stock"]) > 0) {
          currentBooks.add(book);
        }
      }).toList();
    } else if (currentSelected == "Tidak Tersedia") {
      currentBooks = [];
      widget.books.map((book) {
        if (int.parse(book["stock"]) == 0) {
          currentBooks.add(book);
        }
      }).toList();
    }
    return currentBooks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        titleTextStyle: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
          // fontWeight: FontWeight.bold,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: [
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
