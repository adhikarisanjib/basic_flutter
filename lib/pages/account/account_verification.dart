import 'package:basic_flutter/pages/home.dart';
import 'package:basic_flutter/widgets/button.dart';
import 'package:flutter/material.dart';

class AccountVerification extends StatelessWidget {
  const AccountVerification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Verification'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Account verifief successfully.'),
            Button(
              label: 'Home',
              color: Colors.blue.shade400,
              onClick: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const Home(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
