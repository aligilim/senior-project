class DBItem {
  bool fever;
  bool tiredness;
  bool dryCough;
  bool difficultyInBreathing;
  bool soreThroat;
  bool noneSympton;
  bool pains;
  bool runnyNose;
  bool age0To9;
  bool age10to19;
  bool age20to24;
  bool age25to59;
  bool age60;
  bool male;
  bool female;
  bool other;
  bool severityMild;
  bool severityModerate;
  bool severityNone;
  bool severitySevere;
  String country;

  DBItem({
    required this.age0To9,
    required this.age10to19,
    required this.age20to24,
    required this.age25to59,
    required this.age60,
    required this.male,
    required this.female,
    required this.other,
    required this.country,
    required this.difficultyInBreathing,
    required this.dryCough,
    required this.runnyNose,
    required this.fever,
    required this.noneSympton,
    required this.pains,
    required this.severityMild,
    required this.severityModerate,
    required this.severityNone,
    required this.severitySevere,
    required this.soreThroat,
    required this.tiredness,
  });
}
