// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:weather_app/worker/worker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  late String temp;
  late String hum;
  late String airSpeed;
  late String desc;
  late String main;
  late String icon;
  late String city = "Delhi";

  void startApp(String city) async {
    // Worker
    Worker instance = Worker(location: city);
    await instance.getData();

    temp = instance.temp;
    hum = instance.humidity;
    airSpeed = instance.airSpeed;
    desc = instance.description;
    main = instance.main;
    icon = instance.icon;
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/home', arguments: {
          "temp_value": temp,
          "hum_value": hum,
          "airSpeed_value": airSpeed,
          "desc_value": desc,
          "main_value": main,
          "icon_value": icon,
          "city_value": city,
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    Map? search = ModalRoute.of(context)?.settings.arguments as Map?;
    if (search?.isNotEmpty ?? false) {
      city = search!["searchText"];
    }
    // if (city.length >= 19) {
    //   city = "Your City";
    // }
    print(city);
    startApp(city);

    return Scaffold(
        body: SafeArea(
          child: Center(
              child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  image: const AssetImage('assets/images/logo.png'),
                  height: screenHeight / 3,
                  width: screenWidth / 1.5,
                ),
                SizedBox(
                  height: screenHeight / 30,
                ),
                Text(
                  "iWeather",
                  style: TextStyle(
                      fontSize: screenHeight / 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: screenHeight / 40,
                ),
                Text(
                  "Made by Parmeet",
                  style: TextStyle(
                      fontSize: screenWidth / 22, fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: screenHeight / 20,
                ),
                SpinKitWave(
                  color: Colors.blue,
                  size: screenHeight / 15,
                ),
              ],
            ),
          )),
        ),
        backgroundColor: Colors.blue[100]);
  }
}
