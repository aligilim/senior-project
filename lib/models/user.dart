class UserData {
  String? id;
  String? email;
  String? type;
  String? name;
  String? location;
  String? photo;
  String? phone;
  String? lati;
  String? longi;
  String gender;
  String? BloodType;
  String? age;
  String? occupation;
  bool vaccinated;
  int? dose;
  String? dateOfVaccination;
  String? vaccineType;

  UserData({
    this.email,
    this.id,
    this.location,
    this.name,
    this.type,
    this.photo,
    this.phone,
    this.lati,
    this.longi,
    this.gender = 'unknown',
    this.vaccinated = false,
  });
}
