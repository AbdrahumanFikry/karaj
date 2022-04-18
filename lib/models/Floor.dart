// To parse this JSON data, do
//
//     final floorModel = floorModelFromMap(jsonString);

import 'dart:convert';

FloorModel floorModelFromMap(String str) => FloorModel.fromMap(json.decode(str));

String floorModelToMap(FloorModel data) => json.encode(data.toMap());

class FloorModel {
  FloorModel({
    this.id,
    this.name,
    this.timestamp,
    this.isFrom,
    this.isTo,
    this.fromPrice,
    this.toPrice,
    this.price,
  });

  int id;
  String name;
  int timestamp;
  bool isFrom;
  bool isTo;
  double fromPrice;
  double toPrice;
  double price;

  factory FloorModel.fromMap(Map<String, dynamic> json) => FloorModel(
    id: json["id"] == null ? 0 : json["id"],
    name: json["name"] == null ? '' : json["name"],
    timestamp: json["timestamp"] == null ? 0 : json["timestamp"],
    isFrom: json["isFrom"] == null ? false : json["isFrom"],
    isTo: json["isTo"] == null ? false : json["isTo"],
    fromPrice: json["fromPrice"] == null ? 0 : json["fromPrice"].toDouble(),
    toPrice: json["toPrice"] == null ? 0 : json["toPrice"].toDouble(),
    price: json["price"] == null ? 0 : json["price"].toDouble(),
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? 0 : id,
    "name": name == null ? '' : name,
    "timestamp": timestamp == null ? 0 : timestamp,
    "isFrom": isFrom == null ? false : isFrom,
    "isTo": isTo == null ? false : isTo,
    "fromPrice": fromPrice == null ? 0 : fromPrice,
    "toPrice": toPrice == null ? 0 : toPrice,
    "price": price == null ? 0 : price,
  };
}
