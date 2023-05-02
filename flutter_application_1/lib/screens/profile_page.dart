import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/models/auth_model.dart';
import 'package:flutter_application_1/providers/dio_provider.dart';
import 'package:flutter_application_1/utils/config.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthModel>(context, listen: false).getUser;
    return Column(
      children: [
        Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              color: Config.primaryColor,
              child: Column(
                children: <Widget> [
                  const SizedBox(height: 50,),
                  CircleAvatar(
                    radius: 65.0,
                    backgroundImage: NetworkImage("http://10.0.2.2:8000${user['profile_photo_url']}"),
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 10,),
                  Text(user['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20
                  ),),
                  const SizedBox(height: 10,),
                  const Text(
                    '20 Years Old | Male',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15
                    ),
                  )
                ],
              ),
        )),
        Expanded(
            flex: 5,
            child: Container(
              color: Colors.grey[200],
              child: Center(
                child: Card(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Container(
                    width: 300,
                    height: 250,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          const Text('Profile', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),),
                          Divider(
                            color: Colors.grey[300]
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.person, color: Colors.blueAccent[400], size: 35,),
                              const SizedBox(width: 20,),
                              TextButton(
                                  onPressed: () {},
                                  child: const Text('Profile', style: TextStyle(color: Config.primaryColor, fontSize: 15),))
                            ],
                          ),
                          Config.spaceSmall,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.history, color: Colors.yellow[400], size: 35,),
                              const SizedBox(width: 20,),
                              TextButton(
                                  onPressed: () {},
                                  child: const Text('History', style: TextStyle(color: Config.primaryColor, fontSize: 15),))
                            ],
                          ),
                          Config.spaceSmall,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.logout_outlined, color: Colors.lightGreen[400], size: 35,),
                              const SizedBox(width: 20,),
                              TextButton(
                                  onPressed: () async {
                                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                                    final token = prefs.getString('token') ?? '';
                                    if (token.isNotEmpty && token != '')
                                      {
                                        final response = await DioProvider().logout(token);
                                        if (response == 200)
                                          {
                                            await prefs.remove('token');
                                            setState(() {
                                              MyApp.navigatorKey.currentState!.pushReplacementNamed('/');
                                            });
                                          }
                                      }
                                  },
                                  child: const Text('Logout', style: TextStyle(color: Config.primaryColor, fontSize: 15),))
                            ],
                          )
                        ],
                      )
                    ),
                  ),
                ),
              ),
            ))
      ],
    );
  }
}
