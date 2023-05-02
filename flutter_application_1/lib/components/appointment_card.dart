import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/models/auth_model.dart';
import 'package:flutter_application_1/providers/dio_provider.dart';
import 'package:flutter_application_1/utils/config.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppointmentCard extends StatefulWidget {
  const AppointmentCard({Key? key, required this.doctor, required this.color}) : super(key: key);
  final Map<String, dynamic> doctor;
  final Color color;
  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage('http://10.0.2.2${widget.doctor['doctor_profile']}'),
                  ),
                  const SizedBox(width: 10,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Dr ${widget.doctor['doctor_name']}',
                        style: const TextStyle(
                            color: Colors.white
                        ),
                      ),
                      const SizedBox(height: 2,),
                      Text(widget.doctor['category'], style: const TextStyle(color: Colors.black),)
                    ],
                  )
                ],
              ),
              Config.spaceSmall,
              // Schedule info
              ScheduleCard(appointment: widget.doctor['appointment']),
              Config.spaceSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Cancel', style: TextStyle(color: Colors.white),),
                        onPressed: () async {
                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                          final token = prefs.getString('token') ?? '';
                          if (token.isNotEmpty && token != '')
                            {
                              final response = await DioProvider().cancelAppointment(widget.doctor['appointment']['id'], token);
                              if (response == 200)
                                {
                                    Provider.of<AuthModel>(context, listen: false).clearAppointment();
                                    MyApp.navigatorKey.currentState!.pushNamed('main');
                                }
                            }
                        },
                      )),
                  const SizedBox(width: 20),
                  Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text('Completed', style: TextStyle(color: Colors.white),),
                        onPressed: () {
                            showDialog(context: context, builder: (context) {
                              return RatingDialog(
                                initialRating: 1.0,
                                title: const Text('Rate the Doctor', textAlign: TextAlign.center, style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold
                                ),),
                                message: const Text('Please help us to rate our Doctor', textAlign: TextAlign.center, style: TextStyle(
                                    fontSize: 15,
                                ),),
                                image: const FlutterLogo(size: 100),
                                submitButtonText: 'Submit',
                                commentHint: 'Your Reviews',
                                onSubmitted: (response) async {
                                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                                  final token = prefs.getString('token') ?? '';
                                  final ratings = await DioProvider().storeReview(response.comment, response.rating, widget.doctor['appointment']['id'],
                                      widget.doctor['doc_id'], token);
                                  if (ratings == 200 && ratings != '')
                                    {
                                      MyApp.navigatorKey.currentState!.pushNamed('main');
                                    }
                                },
                              );
                            });
                        },
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// Schedule widget
class ScheduleCard extends StatelessWidget {
  const ScheduleCard({Key? key, required this.appointment}) : super(key: key);
  final Map<String, dynamic> appointment;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10)
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.calendar_today,
              color: Colors.white,
              size: 15,
          ),
          const SizedBox(width: 5,),
          Text(
            '${appointment['day']}, ${appointment['date']}',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(width: 20,),
          const Icon(Icons.access_alarm,
            color: Colors.white,
            size: 17,
          ),
          const SizedBox(width: 5,),
          Flexible(
            child: Text(
                appointment['time'],
              style: const TextStyle(color: Colors.white)
            )),
        ],
      ),
    );
  }
}

