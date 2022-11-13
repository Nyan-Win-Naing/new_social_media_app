void main() async {
  print(await getName());
}

Future<int> getName() {
  var aa = getNameFromNetwork().then((value) => Future.value(int.parse(value)));
  var bb = getNameFromNetwork().then((value) => int.parse(value));
  return getNameFromNetwork().then((value) => Future.value(int.parse(value)));
}

Future<String> getNameFromNetwork() {
  return Future.value("211");
}