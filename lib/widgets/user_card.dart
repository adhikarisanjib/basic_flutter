import 'package:basic_flutter/pages/account/account_view.dart';
import 'package:basic_flutter/widgets/label_text.dart';
import 'package:flutter/material.dart';

import 'package:basic_flutter/models/user.dart';

class UserCard extends StatelessWidget {
  final User user;
  const UserCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AccountView(user: user),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage:
                    NetworkImage('http://10.0.2.2:8000${user.displayPic}'),
              ),
              const SizedBox(width: 25),
              Column(
                children: [
                  LabelText(label: user.username),
                  const SizedBox(height: 5),
                  Text(user.email),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
