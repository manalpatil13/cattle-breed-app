class PredictionModel {
  final String breedName;
  final String feeding;
  final String breeding;
  final String care;
<<<<<<< HEAD
  final String milk;
=======
>>>>>>> 21917f0651e5ead9e628e9b8bcf320b116806c9e
  final String dateTime;

  PredictionModel({
    required this.breedName,
    required this.feeding,
    required this.breeding,
    required this.care,
<<<<<<< HEAD
    required this.milk,
=======
>>>>>>> 21917f0651e5ead9e628e9b8bcf320b116806c9e
    required this.dateTime,
  });

  Map<String, dynamic> toJson() => {
        'breedName': breedName,
        'feeding': feeding,
        'breeding': breeding,
        'care': care,
<<<<<<< HEAD
        'milk': milk,
=======
>>>>>>> 21917f0651e5ead9e628e9b8bcf320b116806c9e
        'dateTime': dateTime,
      };

  factory PredictionModel.fromJson(Map<String, dynamic> json) {
    return PredictionModel(
<<<<<<< HEAD
      breedName: json['breedName'] ?? '',
      feeding:   json['feeding']  ?? '',
      breeding:  json['breeding'] ?? '',
      care:      json['care']     ?? '',
      milk:      json['milk']     ?? '',
      dateTime:  json['dateTime'] ?? '',
=======
      breedName: json['breedName'],
      feeding: json['feeding'],
      breeding: json['breeding'],
      care: json['care'],
      dateTime: json['dateTime'],
>>>>>>> 21917f0651e5ead9e628e9b8bcf320b116806c9e
    );
  }
}