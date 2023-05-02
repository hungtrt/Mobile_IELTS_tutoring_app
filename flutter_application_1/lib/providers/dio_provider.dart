import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
class DioProvider {
  // get token
  Future<dynamic> getToken(String email, String password) async {
    try {
      var response = await Dio().post('http://10.0.2.2:8000/api/login',
      data: {'email': email, 'password': password});
      if (response.statusCode == 200 && response.data != '')
        {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', response.data);
          return true;
        }
      else
        {
          return false;
        }
    }
    catch(error)
    {
      return error;
    }
  }

  // get user data
  Future<dynamic> getUser(String token) async{
    try {
      var user = await Dio().get('http://10.0.2.2:8000/api/user',
      options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (user.statusCode == 200 && user.data != '')
      {
        return json.encode(user.data);
      }
    }
    catch(error)
    {
      return error;
    }
  }

  // register user
  Future<dynamic> registerUser(String username, String email, String password) async{
    try {
      var user = await Dio().post('http://10.0.2.2:8000/api/register',
          data: {'username': username, 'email': email, 'password': password});
      if (user.statusCode == 201 && user.data != '')
      {
        return true;
      }
      else
      {
        return false;
      }
    }
    catch(error)
    {
      return error;
    }
  }

  // book appointment
  Future<dynamic> bookAppointment(String date, String day, String time, int doctor, String token) async {
      try
          {
            var response = await Dio().post('http://10.0.2.2:8000/api/book',
                data: {'date': date, 'day': day, 'time': time, 'doctor_id': doctor},
                options: Options(headers: {'Authorization': 'Bearer $token'}));

            if (response.statusCode == 200 && response.data != '')
            {
              return response.statusCode;
            }
            else
            {
              return 'Error';
            }
          }
      catch (error) {
        return error;
      }

  }

  // get all appointments of user
  Future<dynamic> getAppointment(String token) async {
    try
    {
      var response = await Dio().get('http://10.0.2.2:8000/api/appointments',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '')
      {
        return json.encode(response.data);
      }
      else
      {
        return 'Error';
      }
    }
    catch (error) {
      return error;
    }

  }

  // store reviews
  Future<dynamic> storeReview(String reviews, double ratings, int id, int doctor, String token) async {
    try
    {
      var response = await Dio().post('http://10.0.2.2:8000/api/reviews',
          data: {'ratings': ratings, 'reviews': reviews, 'appointment_id': id, 'doctor_id': doctor},
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '')
      {
        return response.statusCode;
      }
      else
      {
        return 'Error';
      }
    }
    catch (error) {
      return error;
    }

  }

  // store favorite doctor
  Future<dynamic> storeFavorite(String token, List<dynamic> favList) async {
    try
    {
      var response = await Dio().post('http://10.0.2.2:8000/api/fav',
          data: {'favList': favList},
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '')
      {
        return response.statusCode;
      }
      else
      {
        return 'Error';
      }
    }
    catch (error) {
      return error;
    }

  }

  // logout
  Future<dynamic> logout(String token) async {
    try
    {
      var response = await Dio().post('http://10.0.2.2:8000/api/logout',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '')
      {
        return response.statusCode;
      }
      else
      {
        return 'Error';
      }
    }
    catch (error) {
      return error;
    }

  }

  // cancel appointment
  Future<dynamic> cancelAppointment(int id, String token) async {
    try
    {
      var response = await Dio().post('http://10.0.2.2:8000/api/cancelBook',
          data: {'id': id},
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '')
      {
        return response.statusCode;
      }
      else
      {
        return 'Error';
      }
    }
    catch (error) {
      return error;
    }

  }

  // update appointment
  Future<dynamic> updateAppointment(String date, String day, String time, int id, String token) async {
    try
    {
      var response = await Dio().post('http://10.0.2.2:8000/api/updateBook',
          data: {'id': id, 'date': date, 'day': day, 'time': time},
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '')
      {
        return response.statusCode;
      }
      else
      {
        return 'Error';
      }
    }
    catch (error) {
      return error;
    }

  }
}