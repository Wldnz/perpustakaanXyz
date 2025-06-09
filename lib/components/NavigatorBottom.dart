import 'package:flutter/material.dart';
import 'package:perpustakaanxyz/AccountPage.dart';
import 'package:perpustakaanxyz/BookPage.dart';
import 'package:perpustakaanxyz/Dashboard.dart';
import 'package:perpustakaanxyz/HistoryBorrowPage.dart';
import '../../utilities/Env.dart';

class Navigatorbottom extends StatefulWidget {
  const Navigatorbottom({super.key});

  @override
  State<Navigatorbottom> createState() => _NavigatorbottomState();
}

class _NavigatorbottomState extends State<Navigatorbottom> {
  var menus = [
    {
      "label": "Home",
      "icon": Icon(Icons.home),
      "activeIcon": Icon(Icons.home, color: Colors.blueAccent),
      "tooltip": "dashboard",
      "destination": Dashboard(),
    },
    {
      "label": "Buku",
      "icon": Icon(Icons.book),
      "activeIcon": Icon(Icons.book, color: Colors.blueAccent),
      "tooltip": "Buku - Buku",
      "destination": Bookpage(),
    },
    {
      "label": "Riwayat",
      "icon": Icon(Icons.history),
      "activeIcon": Icon(Icons.history, color: Colors.blueAccent),
      "tooltip": "Riwayat Peminjaman",
      "destination": Historyborrowpage(),
    },
    {
      "label": "Akun",
      "icon": Icon(Icons.account_circle),
      "activeIcon": Icon(Icons.account_circle, color: Colors.blueAccent),
      "tooltip": "Profil Akun",
      "destination": Accountpage(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: Env.currentIndexNavigationBar,
      selectedIconTheme: IconThemeData(color: Colors.blue),
      backgroundColor: Colors.white,
      selectedFontSize: 12.0,
      onTap: (int index) {
        Env.currentIndexNavigationBar = index;
        setState(() {});
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => menus[index]["destination"] as Widget,
          ),
        );
      },
      items:
          menus.map((menu) {
            return BottomNavigationBarItem(
              label: menu["label"].toString(),
              icon: menu["icon"] as Icon,
              tooltip: menu["tooltip"].toString(),
            );
          }).toList(),
    );
  }
}
