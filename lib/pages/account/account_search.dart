import 'package:flutter/material.dart';

import 'package:basic_flutter/models/user.dart';
import 'package:basic_flutter/widgets/user_card.dart';

class AccountSearch extends StatelessWidget {
  final List<User> users;
  final bool found;
  const AccountSearch({Key? key, required this.users, required this.found})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Search'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(7),
        child: found
            ? ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return UserCard(user: users[index]);
                })
            : const Center(
                child: Text('No users found...'),
              ),
      ),
    );
  }
}
