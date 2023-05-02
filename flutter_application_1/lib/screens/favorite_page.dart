import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/doctor_card.dart';
import 'package:provider/provider.dart';

import '../models/auth_model.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
          child: Column(
            children: [
              const Text(
                'My Favorite Doctors',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 20,),
              Expanded(
                  child: Consumer<AuthModel>(
                    builder: (context, auth, child) {
                      return ListView.builder(
                          itemCount: auth.getFavDoc.length,
                          itemBuilder: (context, index) {
                            return DoctorCard(doctor: auth.getFavDoc[index], isFav: true,);
                          },
                      );
                    },
                    ),
                  ),
            ],
          ),
        ));
  }
}
