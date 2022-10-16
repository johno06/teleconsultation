import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:teleconsultation/doctor_page/drawer.dart';
import 'package:teleconsultation/doctor_page/drawers/chat/screens/contacts_page.dart';
import 'package:teleconsultation/doctor_page/drawers/home_screen.dart';
import '../theme.dart';
import 'messages_screen.dart';

class ChatScreen extends StatefulWidget {
  static Route routeWithChannel(Channel channel) => MaterialPageRoute(
    builder: (context) => StreamChannel(
      channel: channel,
      child: const ChatScreen(),
    ),
  );

  const ChatScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ValueNotifier<int> pageIndex = ValueNotifier(0);

  final ValueNotifier<String> title = ValueNotifier('Messages');

  final pages = const [
    MessagesPage(),
    ContactsPage(),
  ];

  final pageTitles = const [
    'Messages',
    'Contacts',
  ];

  void _onNavigationItemSelected(index) {
    title.value = pageTitles[index];
    pageIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffF8AFA6),
        iconTheme: const IconThemeData(color: Colors.redAccent),
        elevation: 0,
        title: ValueListenableBuilder(
          valueListenable: title,
          builder: (BuildContext context, String value, _) {
            return Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            );
          },
        ),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.redAccent),
          onPressed: () {
             StreamChat.of(context).client.disconnectUser();
             Navigator.pushAndRemoveUntil(
                 context,
                 MaterialPageRoute(builder: (BuildContext context) {
                   return  DoctorPage();
                 },
                 ), (router) => false);
          },
        ),
        // leadingWidth: 54,
        // leading: Align(
        //   alignment: Alignment.centerRight,
        //   child: IconBackground(
        //     icon: Icons.search,
        //     onTap: () {
        //       print('TODO search');
        //     },
        //   ),
        // ),
        actions: [
          // Padding(
          //   padding: const EdgeInsets.only(right: 24.0),
          //   child: Hero(
          //     tag: 'hero-profile-picture',
          //   child: Avatar.small(url: context.currentUserImage,
          //   onTap: (){
          //     Navigator.of(context).push(ProfileScreen.route);
          //       },
          //     ),
          //   ),
          // ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: pageIndex,
        builder: (BuildContext context, int value, _) {
          return pages[value];
        },
      ),
      bottomNavigationBar: _BottomNavigationBar(
        onItemSelected: _onNavigationItemSelected,
      ),
    );
  }
}

class _BottomNavigationBar extends StatefulWidget {
  const _BottomNavigationBar({
    Key? key,
    required this.onItemSelected,
  }) : super(key: key);

  final ValueChanged<int> onItemSelected;

  @override
  __BottomNavigationBarState createState() => __BottomNavigationBarState();
}

class __BottomNavigationBarState extends State<_BottomNavigationBar> {
  var selectedIndex = 0;

  void handleItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
    widget.onItemSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Card(
      color: (brightness == Brightness.light) ? Colors.transparent : null,
      elevation: 0,
      margin: const EdgeInsets.all(0),
      child: SafeArea(
        top: false,
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavigationBarItem(
                index: 0,
                lable: 'Messages',
                icon: CupertinoIcons.bubble_left_bubble_right_fill,
                isSelected: (selectedIndex == 0),
                onTap: handleItemSelected,
              ),
              // _NavigationBarItem(
              //   index: 1,
              //   lable: 'Notifications',
              //   icon: CupertinoIcons.bell_solid,
              //   isSelected: (selectedIndex == 1),
              //   onTap: handleItemSelected,
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //   child: GlowingActionButton(
              //     color: AppColors.secondary,
              //     icon: CupertinoIcons.add,
              //     onPressed: () {
              //       showDialog(
              //         context: context,
              //         builder: (BuildContext context) => const Dialog(
              //         child: AspectRatio(
              //         aspectRatio: 8 / 7,
              //         child: ContactsPage(),
              //       ),
              //       ),
              //       );
              //     },
              //   ),
              // ),
              // _NavigationBarItem(
              //   index: 2,
              //   lable: 'Calls',
              //   icon: CupertinoIcons.phone_fill,
              //   isSelected: (selectedIndex == 2),
              //   onTap: handleItemSelected,
              // ),
              _NavigationBarItem(
                index: 1,
                lable: 'Contacts',
                icon: CupertinoIcons.person_2_fill,
                isSelected: (selectedIndex == 1),
                onTap: handleItemSelected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationBarItem extends StatelessWidget {
  const _NavigationBarItem({
    Key? key,
    required this.index,
    required this.lable,
    required this.icon,
    this.isSelected = false,
    required this.onTap,
  }) : super(key: key);

  final int index;
  final String lable;
  final IconData icon;
  final bool isSelected;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onTap(index);
      },
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? AppColors.secondary : null,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              lable,
              style: isSelected
                  ? const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              )
                  : const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}