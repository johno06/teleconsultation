import 'package:flutter/material.dart';
import 'package:teleconsultation/home_page/drawers/history/absent_appointment.dart';
import 'package:teleconsultation/home_page/drawers/history/reject_appointment.dart';

import '../../../constant.dart';
import 'history_screen.dart';


class TransactionHistoryScreen extends StatefulWidget {
  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _pages = <Widget>[
    HistoryScreen(),
    HistoryScreen2(),
    HistoryScreen1(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.verified),
            label: 'COMPLETED',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.width_normal_sharp),
            label: 'ABSENT',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.clear),
            label: 'REJECTED',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
    //   ),
    // );
  }
}
