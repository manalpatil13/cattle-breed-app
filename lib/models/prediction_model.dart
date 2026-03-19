class PredictionModel {
  final String breedName;
  final String feeding;
  final String breeding;
  final String care;
  final String dateTime;

  PredictionModel({
    required this.breedName,
    required this.feeding,
    required this.breeding,
    required this.care,
    required this.dateTime,
  });

  Map<String, dynamic> toJson() => {
        'breedName': breedName,
        'feeding': feeding,
        'breeding': breeding,
        'care': care,
        'dateTime': dateTime,
      };

  factory PredictionModel.fromJson(Map<String, dynamic> json) {
    return PredictionModel(
      breedName: json['breedName'],
      feeding: json['feeding'],
      breeding: json['breeding'],
      care: json['care'],
      dateTime: json['dateTime'],
    );
  }
}