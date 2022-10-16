import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:teleconsultation/doctor_page/drawers/chat/screens/home_screen.dart';
import '../app.dart';
import '../main.dart';
import '../models/demo_users.dart';

class SelectUserScreen extends StatefulWidget {
  static Route get route => MaterialPageRoute(
    builder: (context) => const SelectUserScreen(),
  );

  const SelectUserScreen({Key? key}) : super(key: key);

  @override
  _SelectUserScreenState createState() => _SelectUserScreenState();
}

class _SelectUserScreenState extends State<SelectUserScreen> {
  bool _loading = true;
  late SharedPreferences loginData;
  late String email, name, surname, user_id;


  @override
  void initState(){
    super.initState();
    initial();
  }

  void initial() async{
    loginData = await SharedPreferences.getInstance();
    setState(() {
      email = loginData.getString('email')!;
      name = loginData.getString('name')!;
      surname = loginData.getString('surname')!;
      user_id = loginData.getString('_id')!;
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onUserSelected();
    });
  }

  Future<void> onUserSelected() async {
    setState(() {
      _loading = true;
    });

    try {
      final client = StreamChatCore.of(context).client;
      await client.connectUser(
        User(
          id: user_id,
          extraData: {
            'name': '$name $surname',
            'image': '',
          },
        ),
        client.devToken(user_id).rawValue,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(),
        ),
      );
    } on Exception catch (e, st) {
      logger.e('Could not connect user', e, st);
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: (_loading)
            ? const CircularProgressIndicator()
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const[
              //  Padding(
              //   padding: EdgeInsets.all(32.0),
              //   child: Text(
              //     'Select a user',
              //     style: TextStyle(fontSize: 24, letterSpacing: 0.4),
              //   ),
              // ),
              // Expanded(
              //   child: ListView.builder(
              //     itemCount: users.length,
              //     itemBuilder: (context, index) {
              //       return SelectUserButton(
              //         user: users[index],
              //         onPressed: onUserSelected,
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}


class SelectUserButton extends StatelessWidget {
  const SelectUserButton({
    Key? key,
    required this.user,
    required this.onPressed,
  }) : super(key: key);

  final DemoUser user;

  final Function(DemoUser user) onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        onTap: () => onPressed(user),
        child: Row(
          children: [
            // Avatar.large(url: user.image),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                user.name,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}