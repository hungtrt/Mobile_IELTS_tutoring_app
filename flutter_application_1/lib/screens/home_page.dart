import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/appointment_card.dart';
import 'package:flutter_application_1/components/doctor_card.dart';
import 'package:flutter_application_1/providers/dio_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/config.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }}


class _HomePageState extends State<HomePage> {
  Map<String, dynamic> user = {};
  List<Map<String, dynamic>> medCat = [
    {
      "icon": FontAwesomeIcons.userDoctor,
      "category": "General"
    },
    {
      "icon": FontAwesomeIcons.heartPulse,
      "category": "Cardiology"
    },
    {
      "icon": FontAwesomeIcons.lungs,
      "category": "Dermatology"
    },
    {
      "icon": FontAwesomeIcons.hand,
      "category": "Gym"
    },
    {
      "icon": FontAwesomeIcons.personPregnant,
      "category": "Dental"
    },
    {
      "icon": FontAwesomeIcons.teeth,
      "category": "Respirations"
    }
  ];

  Future<void> getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token')??'';

    if (token.isNotEmpty && token != '')
      {
        final response = await DioProvider().getUser(token);
        if (response != null)
          {
            setState(() {
              user = json.decode(response);
            });
          }
      }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Scaffold(
      body: user.isEmpty ?
          const Center(
            child: CircularProgressIndicator(),
          )
      : Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      user['name'],
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/avatar.jpg'),
                      ),
                    )
                  ],
                ),
                Config.spaceMedium,
                // category listing
                const Text(
                  'Category',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Config.spaceSmall,
                SizedBox(
                    height: Config.heightSize * 0.07,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: List<Widget>.generate(medCat.length, (index) {
                        return Card(
                          margin: const EdgeInsets.only(right: 20),
                          color: Config.primaryColor,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                FaIcon(
                                  medCat[index]['icon'],
                                  color: Colors.white,
                                ),

                                const SizedBox(width: 20,),
                                Text(
                                  medCat[index]['category'],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                    )
                ),
                Config.spaceSmall,
                const Text(
                  'Appointment Today',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Config.spaceSmall,
                AppointmentCard(),
                Config.spaceSmall,
                const Text(
                  'Top Doctors',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Config.spaceSmall,
                Column(
                  children: List.generate(user['doctor'].length, (index) {
                    return DoctorCard(
                      route: 'doc_details',
                      doctor: user['doctor'][index]
                    );
                  }),)
              ],
            ),
          ),
          )
      ),
    );
  }

}