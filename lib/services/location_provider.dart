// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherapp/services/location_service.dart';

class LocationProvider with ChangeNotifier{

  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;

  final LocationService _locationService=LocationService(); // Location service nde instance
  Placemark? _currentLocationName;
  Placemark? get currentLocationName =>_currentLocationName;


  Future<void> getPosition ()async{

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled=await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _currentPosition=null;
      notifyListeners();
      return;
    }//location Enabled aano ann check cheyyunnu

    permission= await Geolocator.checkPermission();//Location access cheyyan ull permission undo ann check cheyyunnu

    if (permission==LocationPermission.denied) {
      permission=await Geolocator.requestPermission(); // Location access cheyyanulla request varunnu (Screen il)

      if (permission==LocationPermission.denied) { 
        _currentPosition = null;
        notifyListeners();
        return;
      }//permission koduthitillenkil _current position null aayirikkum
    }

    if (permission==LocationPermission.deniedForever) {
      _currentPosition=null;
      notifyListeners();
      return;
    }//permission DeniedForever aanenkil _current position null aayirikkum

    _currentPosition=await Geolocator.getCurrentPosition();//
      print(_currentPosition);

      _currentLocationName = await _locationService.getLocationName(_currentPosition);
      print(_currentLocationName);
      notifyListeners();
  }
}