
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:weatherapp/model/weather_model.dart';
import 'package:weatherapp/secrets/api_endpoints.dart';
import 'package:http/http.dart' as http;
class WeatherServiceProvider with ChangeNotifier{

WeatherModel?_weather;
WeatherModel? get weather => _weather;

bool _isLoading=false;
bool get isLoading => _isLoading;

String _error ="";
String get error => _error;

Future<void> fetchWeatherDataByCity(String city)async{
  _isLoading = true;
  _error ="";
    //https://api.openweathermap.org/data/2.5/weather?q=Kozhikode&appid=72c81ef907591967affa2e3aefe1e150&units=metric

      try {
        final String apiUrl = "${ApiEndpoints().cityUrl}$city&appid=${ApiEndpoints().apiKey}${ApiEndpoints().unit}";
        final response=await http.get(Uri.parse(apiUrl));

        if (response.statusCode==200) {
          final data = jsonDecode(response.body);

          _weather = WeatherModel.fromJson(data);
          notifyListeners();
          

        }else{
          _error = "Faild to load data";
        }
      } catch (e) {
        _error = "an error occurred : $e";
      }finally{
        _isLoading = false;
        notifyListeners();
      }
}
}



