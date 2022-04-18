// To parse this JSON data, do
//
//     final distanceModel = distanceModelFromMap(jsonString);

import 'dart:convert';

DistanceModel distanceModelFromMap(String str) => DistanceModel.fromMap(json.decode(str));

String distanceModelToMap(DistanceModel data) => json.encode(data.toMap());

class DistanceModel {
  DistanceModel({
    this.id,
    this.timestamp,
    this.from,
    this.to,
    this.startEnginePrice,
    this.pricePerKm,
  });

  int id;
  int timestamp;
  double from;
  double to;
  double startEnginePrice;
  double pricePerKm;

  factory DistanceModel.fromMap(Map<String, dynamic> json) => DistanceModel(
    id: json["id"] == null ? 0 : json["id"],
    timestamp: json["timestamp"] == null ? 0 : json["timestamp"],
    from: json["from"] == null ? 0 : json["from"].toDouble(),
    to: json["to"] == null ? 0 : json["to"].toDouble(),
    startEnginePrice: json["startEnginePrice"] == null ? 0 : json["startEnginePrice"].toDouble(),
    pricePerKm: json["pricePerKm"] == null ? 0 : json["pricePerKm"].toDouble(),
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? 0 : id,
    "timestamp": timestamp == null ? 0 : timestamp,
    "from": from == null ? 0 : from,
    "to": to == null ? 0 : to,
    "startEnginePrice": startEnginePrice == null ? 0 : startEnginePrice,
    "pricePerKm": pricePerKm == null ? 0 : pricePerKm,
  };
}
