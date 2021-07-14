class UserData {
  String? id;
  String? email;
  String? type;
  String? name;
  String? location;
  String? currentLocation;
  String? phone;
  String? lati;
  String? currentLati;
  String? longi;
  String? currentLongi;
  String? gender;
  String? bloodType;
  String? age;
  String? occupation;
  String? joinDate;
  bool vaccinated;
  VaccineData? vaccineData;

  UserData({
    this.email,
    this.id,
    this.location,
    this.name,
    this.type,
    this.phone,
    this.lati,
    this.longi,
    this.gender,
    this.vaccineData,
    this.vaccinated = false,
    this.age,
    this.occupation,
    this.bloodType,
    this.currentLati,
    this.currentLocation,
    this.currentLongi,
    this.joinDate,
  });
}

class VaccineData {
  String dose;
  String dateOfVaccination;
  String vaccineType;

  VaccineData({
    required this.dose,
    required this.dateOfVaccination,
    required this.vaccineType,
  });
}
