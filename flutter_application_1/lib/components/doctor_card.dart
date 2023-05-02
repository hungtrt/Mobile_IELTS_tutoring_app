import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/screens/doctor_details.dart';
import 'package:flutter_application_1/utils/config.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({Key? key, required this.doctor, required this.isFav}) : super(key: key);

  final Map<String, dynamic> doctor;
  final bool isFav;
@override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 150,
      child: GestureDetector(
        child: Card(
          elevation: 5,
          color: Colors.white,
          child: Row(
            children: [
              SizedBox(
                width: Config.widthSize * 0.33,
                child: Image.network("http://10.0.2.2:8000${doctor['doctor_profile']}",
                    fit: BoxFit.fill)
              ),
              Flexible(child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Dr ${doctor['doctor_name']}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),),
                    Text("${doctor['category']}",
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal
                      ),),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const Icon(
                          Icons.star_border,
                          color: Colors.yellow,
                          size: 16,),
                        const Spacer(flex: 1),
                        Text(doctor['ratings'].toString()),
                        const Spacer(flex: 1),
                        const Text('Reviews'),
                        const Spacer(flex: 1),
                        Text(doctor['reviews'].toString()),
                        const Spacer(flex: 1),
                      ],
                    )
                  ],
                ),
              ))
            ],
          ),
        ),
        onTap: () {
          MyApp.navigatorKey.currentState!.push(MaterialPageRoute(builder: (_) => DoctorDetails(doctor: doctor, isFav: isFav)));
        },
      ),
    );
  }
}
