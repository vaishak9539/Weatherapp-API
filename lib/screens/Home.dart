
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/data/image_path.dart';
import 'package:weatherapp/services/location_provider.dart';
import 'package:weatherapp/services/weather_service_provider.dart';
import 'package:weatherapp/utiles/apptext.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();

    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    locationProvider.getPosition().then(
      (_) {
        if (locationProvider.currentLocationName != null) {
          var city = locationProvider.currentLocationName!.locality;
          if (city != null) {
            Provider.of<WeatherServiceProvider>(context, listen: false)
                .fetchWeatherDataByCity(city);
          }
        }
      },
    );
  }

  var locationCity;
  var size, width, height;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    final weatherServiceProvider = Provider.of<WeatherServiceProvider>(context);
    var date = DateTime.now();

    
    if (weatherServiceProvider.isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    final weather = weatherServiceProvider.weather;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(),
      body: Stack(
        children: [
          // Background Image
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  background[weather?.weather?.isNotEmpty == true
                          ? weather!.weather![0].main
                          : "N/A"] ??
                      "assets/images/clouds.jpg",
                ),
              ),
            ),
          ),
          // Main Content
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Consumer<LocationProvider>(
                      builder: (context, locationProvider, child) {
                    locationCity = locationProvider.currentLocationName?.locality ?? "Location";
                    return ListTile(
                      leading: const Icon(Icons.location_pin, color: Colors.red),
                      title: AppText(
                        text: locationCity,
                        size: 18,
                        color: Colors.white,
                        weight: FontWeight.w700,
                      ),
                      subtitle: AppText(
                        text: DateFormat("hh:mm a").format(date),
                        size: 14,
                        color: Colors.white,
                        weight: FontWeight.w400,
                      ),
                      trailing: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    );
                  }),
                ),
                if (weather?.weather?.isNotEmpty == true)
                  Image.asset(
                    imagepath[weather!.weather![0].main ?? "N/A"] ??
                        "assets/images/clouds.png",
                    height: 180,
                  ),
                const SizedBox(height: 10),
                AppText(
                  text: weather?.main?.temp != null
                      ? "${weather!.main!.temp}\u00B0 C"
                      : "Loading...",
                  size: 32,
                  color: Colors.white,
                  weight: FontWeight.w700,
                ),
                AppText(
                  text: weather?.weather?.isNotEmpty == true
                      ? weather!.weather![0].main
                      : "N/A",
                  size: 20,
                  color: Colors.white,
                  weight: FontWeight.w500,
                ),
                AppText(
                  text: DateFormat("hh:mm a").format(date),
                  size: 18,
                  color: Colors.white,
                  weight: FontWeight.w700,
                ),
                const SizedBox(height: 20),
                Container(
                  height: height / 4,
                  width: width / 1.1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black.withOpacity(0.3),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildWeatherInfo(
                            "Temp Max",
                            weather?.main?.tempMax,
                            "temperature-high",
                          ),
                          _buildWeatherInfo(
                            "Temp Min",
                            weather?.main?.tempMin,
                            "temperature-low",
                          ),
                        ],
                      ),
                      const Divider(
                        endIndent: 66,
                        thickness: 2,
                        indent: 60,
                        color: Colors.white,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildWeatherInfo(
                            "Sunrise",
                            weather?.sys?.sunrise,
                            "sun",
                            isTime: true,
                          ),
                          _buildWeatherInfo(
                            "Sunset",
                            weather?.sys?.sunset,
                            "moon",
                            isTime: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherInfo(String title, dynamic value, String iconKey,
      {bool isTime = false}) {
    String displayValue = "N/A";
    if (value != null) {
      if (isTime) {
        DateTime dateTime =
            DateTime.fromMillisecondsSinceEpoch(value * 1000);
        displayValue = DateFormat.Hm().format(dateTime);
      } else {
        displayValue = "$value\u00B0C";
      }
    }
    return SizedBox(
      height: height / 15.9,
      width: width / 3.2,
      child: Row(
        children: [
          Image.asset(temicon[iconKey] ?? "assets/images/clouds.png", height: 45),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: AppText(
                  text: title,
                  size: 14,
                  color: Colors.white,
                  weight: FontWeight.w600,
                ),
              ),
              AppText(
                text: displayValue,
                size: 20,
                color: Colors.white,
                weight: FontWeight.bold,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

