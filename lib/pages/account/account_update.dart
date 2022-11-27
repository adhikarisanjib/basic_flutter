import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:io';

import 'package:basic_flutter/models/user.dart';
import 'package:basic_flutter/config.dart';
import 'package:basic_flutter/pages/account/account.dart';

import 'package:basic_flutter/widgets/button.dart';
import 'package:basic_flutter/widgets/label_text.dart';
import 'package:basic_flutter/widgets/error_text.dart';

class AccountUpdate extends StatefulWidget {
  final User? user;
  const AccountUpdate({Key? key, required this.user}) : super(key: key);

  @override
  State<AccountUpdate> createState() => _AccountUpdateState();
}

class _AccountUpdateState extends State<AccountUpdate> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String username = '';
  String email = '';
  String name = '';
  String displayPic = '';

  String usernameError = '';
  String emailError = '';
  String nameError = '';
  String displayPicError = '';
  String nonFieldError = '';

  File? image;
  bool imageChanged = false;

  String regEmail =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  void validation() {
    final FormState? _form = _formKey.currentState;
    if (_form!.validate()) {
      update();
    }
  }

  update() async {
    Map<String, String> data = {
      'email': email,
      'username': username,
      'name': name,
    };

    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? token = _prefs.getString('auth-token');

    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('$apiDomain/api/account/'),
    );

    request.headers.addAll({'Authorization': 'Token $token'});
    request.fields.addAll(data);
    if (imageChanged) {
      request.files.add(
        await http.MultipartFile.fromPath('display_pic', image!.path),
      );
    }

    var response = await request.send();
    var jsonResponse = await http.Response.fromStream(response);

    if (jsonResponse.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Updated successfully'),
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        ),
      );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const Account(),
        ),
      );
    } else {
      Map<String, dynamic> errorData = json.decode(jsonResponse.body);
      setState(() {
        emailError =
            errorData.containsKey('email') ? errorData['email'][0] : '';
        usernameError =
            errorData.containsKey('username') ? errorData['username'][0] : '';
        nameError = errorData.containsKey('name') ? errorData['name'][0] : '';
        displayPicError = errorData.containsKey('display_pic')
            ? errorData['display_pic'][0]
            : '';
        nonFieldError = errorData.containsKey('non_field_errors')
            ? errorData['non_field_errors'][0]
            : '';
      });
    }
  }

  _openGallery() async {
    final ImagePicker _picker = ImagePicker();
    var file = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      try {
        image = convertToFile(file!);
        imageChanged = true;
      } catch (e) {
        return;
      }
    });
  }

  File convertToFile(XFile xFile) => File(xFile.path);

  @override
  void initState() {
    super.initState();
    setState(() {
      email = widget.user!.email;
      username = widget.user!.username;
      name = widget.user!.name ?? '';
      displayPic = widget.user!.displayPic!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Update'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 20,
            ),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            ClipOval(
                              child: Material(
                                  color: Colors.transparent,
                                  child: image == null
                                      ? Ink.image(
                                          image: NetworkImage(
                                              '$apiDomain$displayPic'),
                                          fit: BoxFit.cover,
                                          width: 200,
                                          height: 200,
                                        )
                                      : Ink.image(
                                          image: FileImage(image!),
                                          fit: BoxFit.cover,
                                          width: 200,
                                          height: 200,
                                        )),
                            ),
                            Positioned(
                              bottom: 2,
                              right: 5,
                              child: ClipOval(
                                child: Container(
                                  color: Colors.blue.shade400,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      _openGallery();
                                    },
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      displayPicError.isEmpty
                          ? const SizedBox()
                          : ErrorText(message: displayPicError),
                      const LabelText(label: 'Email'),
                      const SizedBox(height: 5),
                      TextFormField(
                        // initialValue: widget.user!.email,
                        initialValue: email,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                        validator: (value) {
                          if (value == '') {
                            return 'Please enter an email';
                          } else if (!RegExp(regEmail).hasMatch(value!)) {
                            return 'Invalid email address';
                          }
                          return null;
                        },
                      ),
                      emailError.isEmpty
                          ? const SizedBox()
                          : ErrorText(message: emailError),
                      const SizedBox(height: 20),
                      const LabelText(label: 'Username'),
                      const SizedBox(height: 5),
                      TextFormField(
                        // initialValue: widget.user!.username,
                        initialValue: username,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            username = value;
                          });
                        },
                        validator: (value) {
                          if (value == '') {
                            return 'Please enter a username';
                          }
                          return null;
                        },
                      ),
                      usernameError.isEmpty
                          ? const SizedBox()
                          : ErrorText(message: usernameError),
                      const SizedBox(height: 20),
                      const LabelText(label: 'Full Name'),
                      const SizedBox(height: 5),
                      TextFormField(
                        // initialValue: widget.user!.name,
                        initialValue: name,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            name = value;
                          });
                        },
                        validator: (value) {
                          if (value == '') {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                      nameError.isEmpty
                          ? const SizedBox()
                          : ErrorText(message: nameError),
                      const SizedBox(height: 20),
                      Button(
                        label: 'Update',
                        onClick: () => {validation()},
                        color: Colors.blue.shade400,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
