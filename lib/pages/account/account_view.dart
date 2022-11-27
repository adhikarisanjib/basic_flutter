import 'package:flutter/material.dart';

import 'package:basic_flutter/models/user.dart';
import 'package:basic_flutter/config.dart';
import 'package:basic_flutter/widgets/label_text.dart';

class AccountView extends StatelessWidget {
  final User user;
  const AccountView({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Account'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 25,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipOval(
                    child: Material(
                      color: Colors.transparent,
                      child: Ink.image(
                        image: NetworkImage('$apiDomain${user.displayPic}'),
                        fit: BoxFit.cover,
                        width: 250,
                        height: 250,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const SizedBox(height: 20),
                const LabelText(label: 'Email :'),
                LabelText(label: user.email),
                const SizedBox(height: 10),
                const LabelText(label: 'Username :'),
                LabelText(label: user.username),
                const SizedBox(height: 10),
                const LabelText(label: 'Name :'),
                user.name == null
                    ? const SizedBox(height: 0)
                    : LabelText(label: (user.name).toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
