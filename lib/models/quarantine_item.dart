class QuarantineItem {
  String date;
  String location;
  String latitude;
  String longitude;
  bool isHome;

  QuarantineItem({
    required this.date,
    required this.isHome,
    required this.latitude,
    required this.location,
    required this.longitude,
  });
}
