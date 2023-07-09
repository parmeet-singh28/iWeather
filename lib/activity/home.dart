// ignore_for_file: unnecessary_string_interpolations

// import 'dart:ffi';
import 'dart:math';
// import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:weather_icons/weather_icons.dart';
// import 'dart:convert' as convert;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();
  String location = 'Null, Press Button';
  String Address = 'search';
  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    // print(placemarks);
    Placemark place = placemarks[0];
    // print(place.administrativeArea);
    String loc = place.administrativeArea.toString();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/loading', arguments: {
        "searchText": loc,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = min(730, screenSize.width);
    double screenHeight = max(750, screenWidth * 2.3);

    // time
    DateTime now = DateTime.now();

    // Extracting individual components
    String day = DateFormat('dd').format(now);
    String month = DateFormat('MMMM').format(now);
    String year = DateFormat('yyyy').format(now);
    String weekday = DateFormat('EEEE').format(now);
    String time = DateFormat('hh:mm a').format(now);

    // data
    Map info = ModalRoute.of(context)?.settings.arguments as Map;
    String temp = (((info["temp_value"]).toString()));
    String icon = info["icon_value"];
    String getCity = info["city_value"];
    String hum = info["hum_value"];
    String air = ((info["airSpeed_value"]).toString());
    String desc = info["desc_value"];
    desc = desc[0].toUpperCase() + desc.substring(1, desc.length);
    getCity = getCity[0].toUpperCase() + getCity.substring(1, getCity.length);
    if (getCity.length >= 19) {
      getCity = "Your City";
    }
    if (temp != "NA") {
      temp = (info["temp_value"]).toString();
      if (temp.length >= 4) {
        temp = ((temp).substring(0, 4));
      }
      air = (info["airSpeed_value"]).toString();
      if (air.length >= 4) {
        air = ((info["airSpeed_value"]).toString()).substring(0, 4);
      }
    }

    var cityName = [
      "Delhi",
      "Hyderabad",
      "Mumbai",
      "Pune",
      "London",
      "New York",
    ];
    final random = Random();
    var city = cityName[random.nextInt(cityName.length)];
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: AppBar(
            backgroundColor: Colors.blue,
          ),
        ),
        body: SafeArea(
          // child: ,

          child: Center(
            child: Container(
              // alignment: Alignment(0, 0),
              width: screenWidth,
              height: screenHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.blue[800]!,
                    Colors.blue[100]!,
                  ],
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      // search container
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth / 50),
                      margin: EdgeInsets.symmetric(
                          horizontal: screenWidth / 15,
                          vertical: screenHeight / 40),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24)),
                      child: SingleChildScrollView(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if ((searchController.text) == "" ||
                                    (searchController.text)[0] == " ") {
                                  // print("Blank search");
                                }
                                // print(searchController.text);
                                else {
                                  Navigator.pushReplacementNamed(
                                      context, '/loading',
                                      arguments: {
                                        "searchText": searchController.text,
                                      });
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.fromLTRB(
                                    screenWidth / 50, 0, screenWidth / 50, 0),
                                child: Icon(
                                  Icons.search,
                                  color: Colors.blueAccent,
                                  size: screenWidth / 15,
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                onSubmitted: (value) {
                                  if ((searchController.text) == "" ||
                                      (searchController.text)[0] == " ") {
                                    // print("Blank search");
                                  }
                                  // print(searchController.text);
                                  else {
                                    Navigator.pushReplacementNamed(
                                        context, '/loading',
                                        arguments: {
                                          "searchText": searchController.text,
                                        });
                                  }
                                },
                                controller: searchController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Search $city"),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                Position position =
                                    await _getGeoLocationPosition();
                                // print(position.latitude);
                                GetAddressFromLatLong(position);
                              },
                              child: Container(
                                margin: EdgeInsets.fromLTRB(
                                  screenWidth / 50,
                                  0,
                                  screenWidth / 50,
                                  0,
                                ),
                                child: Icon(
                                  Icons.location_searching,
                                  color: Colors.blueAccent,
                                  size: screenWidth / 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: screenHeight / 6,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                // borderRadius: BorderRadius.circular(14)
                              ),
                              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              // padding: EdgeInsets.all(screenHeight / 30),
                              // margin: EdgeInsets.symmetric(
                              //     horizontal: screenWidth / 15),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '$time',
                                      style: TextStyle(
                                          fontSize: screenWidth / 8,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: screenHeight / 90,
                                    ),
                                    Text(
                                      '$day $month $year, $weekday',
                                      style: TextStyle(
                                          fontSize: screenWidth / 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenHeight / 70,
                    ),
                    SingleChildScrollView(
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: screenHeight / 8,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                // borderRadius: BorderRadius.circular(14)
                              ),
                              // margin: EdgeInsets.symmetric(
                              //     horizontal: screenWidth / 15),
                              // padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: SingleChildScrollView(
                                child: Row(
                                  children: [
                                    // SizedBox(
                                    //   width: screenWidth / 100,
                                    // ),
                                    SingleChildScrollView(
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: screenWidth / 4,
                                            height: screenHeight / 8,
                                            child: Image.network(
                                                'https://openweathermap.org/img/wn/$icon@2x.png'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Column(
                                    // crossAxisAlignment:
                                    //     CrossAxisAlignment.center,
                                    // textDirection: te,
                                    // children: [
                                    SizedBox(
                                      width: screenWidth - (screenWidth / 3),
                                      height: screenHeight / 8,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          '$desc\nin $getCity',
                                          style: TextStyle(
                                              fontSize: screenWidth / 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    // ],
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: screenHeight / 3,
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(14)),
                              // padding: EdgeInsets.all(screenWidth / 20),
                              padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
                              margin: EdgeInsets.symmetric(
                                  horizontal: screenWidth / 15,
                                  vertical: screenHeight / 60),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          WeatherIcons.thermometer,
                                          size: screenWidth / 13,
                                        ),
                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                              screenWidth / 9, 0, 0, 0),
                                          child: Text(
                                            "Temperature",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: screenWidth / 18),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: screenHeight / 20,
                                    ),
                                    SingleChildScrollView(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '$temp℃',
                                            style: TextStyle(
                                                fontSize: screenWidth / 5),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(14)),
                              // padding: EdgeInsets.all(screenHeight / 50),
                              padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                              margin: EdgeInsets.fromLTRB(
                                  screenWidth / 15, 0, screenWidth / 70, 0),
                              height: screenHeight / 3.8,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SingleChildScrollView(
                                      child: Row(
                                        children: [
                                          Icon(
                                            WeatherIcons.day_windy,
                                            size: screenWidth / 17,
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                screenWidth / 10,
                                                screenHeight / 80,
                                                0,
                                                0),
                                            child: Text(
                                              "Wind\nSpeed",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: screenWidth / 25),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: screenHeight / 35),
                                    Text(
                                      '$air',
                                      style: TextStyle(
                                          fontSize: screenWidth / 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "km/hr",
                                      style: TextStyle(
                                          fontSize: screenWidth / 20,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(14)),
                              // padding: EdgeInsets.all(screenHeight / 30),
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              margin: EdgeInsets.fromLTRB(
                                  screenWidth / 70, 0, screenWidth / 15, 0),
                              height: screenHeight / 3.8,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Icon(
                                            WeatherIcons.humidity,
                                            size: screenWidth / 17,
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                screenWidth / 50,
                                                screenHeight / 90,
                                                0,
                                                0),
                                            child: Text(
                                              "Humidity",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: screenWidth / 22,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: screenHeight / 40),
                                    Column(
                                      children: [
                                        Text(
                                          '$hum',
                                          style: TextStyle(
                                              fontSize: screenWidth / 10,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "Percent",
                                          style: TextStyle(
                                              fontSize: screenWidth / 25,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenHeight / 40,
                    ),
                    Container(
                        padding: EdgeInsets.all(screenHeight / 40),
                        child: const Text("Made by Parmeet")),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
