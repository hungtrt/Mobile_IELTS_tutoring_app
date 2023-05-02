import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/dio_provider.dart';
import 'package:flutter_application_1/utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage ({Key? key}) : super(key: key);

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}
enum FilterStatus {Upcoming, Complete, Cancel}
class _AppointmentPageState extends State<AppointmentPage> {
  FilterStatus status = FilterStatus.Upcoming;
  Alignment _alignment = Alignment.centerLeft;
  List<dynamic> schedules = [];
  String token = '';
  Future<void> getAppointments() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    final appointment = await DioProvider().getAppointment(token);
    if (appointment != 'Error')
      {
        setState(() {
          schedules = json.decode(appointment);
        });
      }
  }

  @override
  void initState() {
    getAppointments();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredSchedules = schedules.where((var schedule) {
      switch(schedule["status"])
          {
        case 'upcoming':
          schedule['status'] = FilterStatus.Upcoming;
          break;
        case 'complete':
          schedule['status'] = FilterStatus.Complete;
          break;
        case 'cancel':
          schedule['status'] = FilterStatus.Cancel;
          break;
      }
      return schedule['status'] == status;
    }).toList();
    return SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20,top: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Appointment Schedule',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),
              ),
              Config.spaceSmall,
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for(FilterStatus filterStatus in FilterStatus.values)
                          Expanded(child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (filterStatus == FilterStatus.Upcoming) {
                                  status = FilterStatus.Upcoming;
                                  _alignment = Alignment.centerLeft;
                                }
                                else if (filterStatus == FilterStatus.Complete)
                                {
                                  status = FilterStatus.Complete;
                                  _alignment = Alignment.center;
                                }
                                else if (filterStatus == FilterStatus.Cancel)
                                {
                                  status = FilterStatus.Cancel;
                                  _alignment = Alignment.centerRight;
                                }
                              });
                            },
                            child: Center(
                              child: Text(filterStatus.name),
                            ),
                          ))
                      ],
                    ),
                  ),
                  AnimatedAlign(
                    alignment: _alignment,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Config.primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          status.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,

                          ),
                        ),
                      ),
                    ),)

                ],
              ),
              Config.spaceSmall,
              Expanded(
                child: ListView.builder(
                  itemCount: filteredSchedules.length,
                  itemBuilder: ((context, index) {
                    var schedule = filteredSchedules[index];
                    bool isLastElement = filteredSchedules.length + 1 == index;
                    return Card(
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              color: Colors.grey
                          ),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      margin: !isLastElement ? const EdgeInsets.only(bottom: 20) : EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage("http://10.0.2.2:8000${schedule['doctor_profile']}"),
                                ),
                                const SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      schedule['doctor_name'],
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700
                                      ),
                                    ),
                                    const SizedBox(height: 5,),
                                    Text(
                                      schedule['category'],
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: 15,),
                            ScheduleCard(date: schedule['date'], day: schedule['day'], time: schedule['time']),
                            const SizedBox(height: 15,),
                            status == FilterStatus.Upcoming ?
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      final response = await DioProvider().cancelAppointment(schedule['id'], token);
                                      if (response == 200)
                                        {
                                          setState(() {
                                            getAppointments();
                                          });
                                        }
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                          color: Config.primaryColor
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20,),
                                Expanded(
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: Config.primaryColor,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pushNamed('booking_page', arguments: {"appointment_id": schedule['id']});
                                    },
                                    child: const Text(
                                      'Reschedule',
                                      style: TextStyle(
                                          color: Colors.white
                                      ),
                                    ),
                                  ),
                                ),
                          ],
                        )
                        :
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed('booking_page', arguments: {"doctor_id": schedule['doc_id']});
                                },
                                child: const Text(
                                  'Book Again',
                                  style: TextStyle(
                                  color: Config.primaryColor
                                  ),
                                ),
                              ),
                            ),
                          ]
                        )
                        ]
                      ),
                    ));
                  }),
                ),
              ),
            ],
          ),
        ));
  }
}

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({Key? key, required this.date, required this.day, required this.time}) : super(key: key);
  final String date;
  final String day;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10)
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Icon(Icons.calendar_today,
            color: Config.primaryColor,
            size: 15,
          ),
          const SizedBox(width: 5,),
          Text(
            '$day, $date',
            style: const TextStyle(color: Config.primaryColor),
          ),
          const SizedBox(width: 20,),
          const Icon(Icons.access_alarm,
            color: Config.primaryColor,
            size: 17,
          ),
          const SizedBox(width: 5,),
          Flexible(
              child: Text(
                  time,
                  style: const TextStyle(color: Config.primaryColor)
              )),
        ],
      ),
    );
  }
}