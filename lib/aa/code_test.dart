import 'package:flutter/widgets.dart';

void main() async {
  getName().then((value) => print("Name is $value"));
}

Future<String> getName() {
  // var aa = getNameFromNetwork().then((value) => Future.value(int.parse(value)));
  // var bb = getNameFromNetwork().then((value) => int.parse(value));
  // return getNameFromNetwork().then((value) => Future.value(int.parse(value)));
  debugPrint("Get Name Block Works...........");
  return Future.value("Nyan Win Naing");
}

Future<String> getNameFromNetwork() {
  return Future.value("211");
}