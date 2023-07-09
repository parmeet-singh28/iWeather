import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Worker {
  String location;

  // constructor
  Worker({required this.location}) {
    location = location;
  }

  late String temp;
  late String humidity;
  late String airSpeed;
  late String description;
  late String main;
  late String icon;

  Future<void> getData() async {
    try {
      http.Response response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$location&appid=bf4a8bfed9af86d16d886c1277027fa2'));
      Map data = convert.jsonDecode(response.body);

      // Getting Temp, Humidity
      Map tempData = data['main'];
      String getHumidity = tempData['humidity'].toString();
      double getTemperature = tempData['temp'] - 273.15;

      // Getting windspeed
      Map wind = data['wind'];
      double getAirSpeed = wind['speed'] * 3.6;

      // Getting Description
      List weatherData = data['weather'];
      Map weatherMainData = weatherData[0];
      String getMainDesc = weatherMainData['main'];
      String getDesc = weatherMainData['description'];
      String getIcon = weatherMainData['icon'].toString();

      // assigning value
      temp = getTemperature.toString();
      humidity = getHumidity;
      airSpeed = getAirSpeed.toString();
      description = getDesc;
      main = getMainDesc;
      icon = getIcon;
      // print(icon);
    } catch (e) {
      temp = "NA";
      humidity = "NA";
      airSpeed = "NA";
      description = "Can't find Data";
      main = "NA";
      icon = "10d";
    }
  }
}
