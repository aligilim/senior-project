class MedicalReport {
  String? id;
  String patientId;
  String patientName;
  String doctorId;
  String doctorName;
  String diagnosis;
  String date;
  List<String> drugs;

  MedicalReport({
    this.id,
    required this.date,
    required this.diagnosis,
    required this.doctorId,
    required this.doctorName,
    required this.drugs,
    required this.patientId,
    required this.patientName,
  });
}
