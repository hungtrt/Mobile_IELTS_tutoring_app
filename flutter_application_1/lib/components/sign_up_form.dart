import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/button.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/models/auth_model.dart';
import 'package:flutter_application_1/providers/dio_provider.dart';
import 'package:flutter_application_1/utils/config.dart';
import 'package:provider/provider.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool obsecurePass = true;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _nameController,
            keyboardType: TextInputType.text,
            cursorColor: Config.primaryColor,
            decoration: const InputDecoration(
              hintText: 'Username',
              labelText: 'Username',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.person_outlined),
              prefixIconColor: Config.primaryColor,
            ),
          ),
          Config.spaceSmall,
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Config.primaryColor,
            decoration: const InputDecoration(
              hintText: 'Email Address',
              labelText: 'Email',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.email_outlined),
              prefixIconColor: Config.primaryColor,
            ),
          ),
          Config.spaceSmall,
          TextFormField(
            controller: _passController,
            keyboardType: TextInputType.visiblePassword,
            cursorColor: Config.primaryColor,
            obscureText: obsecurePass,
            decoration: InputDecoration(
                hintText: 'Password',
                labelText: 'Password',
                alignLabelWithHint: true,
                prefixIcon: const Icon(Icons.lock_outline),
                prefixIconColor: Config.primaryColor,
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obsecurePass = !obsecurePass;
                      });
                    },
                    icon: obsecurePass
                        ? const Icon(
                      Icons.visibility_off_outlined,
                      color: Colors.black38,
                    )
                        : const Icon(
                      Icons.visibility_outlined,
                      color: Config.primaryColor,
                    ))),
          ),
          Config.spaceSmall,
          Consumer<AuthModel>(
              builder: (context, auth, child) {
                return Button(
                    width: double.infinity,
                    title: 'Sign up',
                    onPressed: () async {
                      final userRegistration = await DioProvider().registerUser(_nameController.text, _emailController.text, _passController.text);
                      if (userRegistration)
                        {
                          final token = await DioProvider().getToken(_emailController.text, _passController.text);
                          if (token) {
                            final response = await DioProvider().getUser(token);
                            if (response != null)
                            {
                              setState(() {
                                Map<String, dynamic> appointment = {};

                                final user = json.decode(response);
                                for (var doctorData in user['doctor'])
                                {
                                  if (doctorData['appointment'] != null)
                                  {
                                    appointment = doctorData;
                                  }
                                }
                                auth.loginSuccess(user, appointment);
                                MyApp.navigatorKey.currentState!.pushNamed('main');
                              });
                            }
                          }
                        }
                      else
                        {
                          print('register failed');
                        }
                    },
                    disable: false
                );
              }
          )
        ],
      ),
    );
  }
}
