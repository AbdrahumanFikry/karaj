// To parse this JSON data, do
//
//     final sosModel = sosModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

SosModel sosModelFromJson(String str) => SosModel.fromJson(json.decode(str));

String sosModelToJson(SosModel data) => json.encode(data.toJson());

class SosModel {
  SosModel({
    this.id,
    this.address,
    this.suffers,
    this.lng,
    this.typeIndex,
    this.injuries,
    this.subTypeIndex,
    this.batteryBalance,
    this.type,
    this.sosNeeds,
    this.beneficiary,
    this.vehicleDamaged,
    this.subType,
    this.addressData,
    this.lat,
    this.latlng,
    this.status,
    this.needTo,
    this.userId,
    this.phone,
    this.helperId,
    this.weekWifi,
  });

  String address;
  int suffers;
  String id;
  double lng;
  int typeIndex;
  int injuries;
  int subTypeIndex;
  int batteryBalance;
  String type;
  int sosNeeds;
  int beneficiary;
  int vehicleDamaged;
  String subType;
  AddressData addressData;
  double lat;
  String latlng;
  String status;
  String needTo;
  String userId;
  String phone;
  String helperId;
  String weekWifi;

  factory SosModel.fromFirestore(DocumentSnapshot doc) {
    Map json = doc.data();
    json["id"] = doc.id;
    return SosModel.fromJson(json);
  }


  factory SosModel.fromJson(Map<String, dynamic> json) => SosModel(
    id: json["id"].toString(),
    address: json["address"] == null ? null : json["address"],
    suffers: json["suffers"] == null ? null : json["suffers"],
    lng: json["lng"] == null ? null : json["lng"].toDouble(),
    typeIndex: json["typeIndex"] == null ? null : json["typeIndex"],
    injuries: json["injuries"] == null ? null : json["injuries"],
    subTypeIndex: json["subTypeIndex"] == null ? null : json["subTypeIndex"],
    batteryBalance: json["batteryBalance"] == null ? null : json["batteryBalance"],
    type: json["type"] == null ? null : json["type"],
    sosNeeds: json["sosNeeds"] == null ? null : json["sosNeeds"],
    beneficiary: json["beneficiary"] == null ? null : json["beneficiary"],
    vehicleDamaged: json["vehicleDamaged"] == null ? null : json["vehicleDamaged"],
    subType: json["subType"] == null ? null : json["subType"],
    addressData: json["addressData"] == null ? null : AddressData.fromJson(json["addressData"]),
    lat: json["lat"] == null ? null : json["lat"].toDouble(),
    latlng: json["latlng"] == null ? null : json["latlng"],
    status: json["status"] == null ? null : json["status"],
    needTo: json["needTo"] == null ? null : json["needTo"],
    userId: json["userId"] == null ? null : json["userId"],
    phone: json["phone"] == null ? null : json["phone"],
    helperId: json["helperId"] == null ? null : json["helperId"],
    weekWifi: json["weekWifi"] == null ? null : json["weekWifi"],
  );

  Map<String, dynamic> toJson() => {
    "address": address == null ? null : address,
    "suffers": suffers == null ? null : suffers,
    "id": id == null ? null : id,
    "lng": lng == null ? null : lng,
    "typeIndex": typeIndex == null ? null : typeIndex,
    "injuries": injuries == null ? null : injuries,
    "subTypeIndex": subTypeIndex == null ? null : subTypeIndex,
    "batteryBalance": batteryBalance == null ? null : batteryBalance,
    "type": type == null ? null : type,
    "sosNeeds": sosNeeds == null ? null : sosNeeds,
    "beneficiary": beneficiary == null ? null : beneficiary,
    "vehicleDamaged": vehicleDamaged == null ? null : vehicleDamaged,
    "subType": subType == null ? null : subType,
    "addressData": addressData == null ? null : addressData.toJson(),
    "lat": lat == null ? null : lat,
    "latlng": latlng == null ? null : latlng,
    "status": status == null ? null : status,
    "needTo": needTo == null ? null : needTo,
    "userId": userId == null ? null : userId,
    "phone": phone == null ? null : phone,
    "helperId": helperId == null ? null : helperId,
    "weekWifi": weekWifi == null ? null : weekWifi,
  };
}

class AddressData {
  AddressData({
    this.address,
    this.lng,
    this.lat,
    this.latlng,
  });

  String address;
  double lng;
  double lat;
  String latlng;

  factory AddressData.fromJson(Map<String, dynamic> json) => AddressData(
    address: json["address"] == null ? null : json["address"],
    lng: json["lng"] == null ? null : json["lng"].toDouble(),
    lat: json["lat"] == null ? null : json["lat"].toDouble(),
    latlng: json["latlng"] == null ? null : json["latlng"],
  );

  Map<String, dynamic> toJson() => {
    "address": address == null ? null : address,
    "lng": lng == null ? null : lng,
    "lat": lat == null ? null : lat,
    "latlng": latlng == null ? null : latlng,
  };
}
