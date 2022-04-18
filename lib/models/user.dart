import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

UserModel userModelFromMap(String str) => UserModel.fromMap(json.decode(str));

String userModelToMap(UserModel data) => json.encode(data.toMap());

class UserModel {
  UserModel({
    this.id,
    this.firstName = '',
    this.lastName = '',
    this.isDriver = false,
    this.isShop = false,
    this.isSos = false,
    this.isAdmin = false,
    this.isNormalUser = false,
    this.fullAddress,
    this.phone,
    this.active,
    this.isOnline = false,
    this.isOnRide = false,
    this.onWithdraw = false,
    this.onOrderID,
    this.token,
    this.personalData,
    this.balance,
    this.totalBalance,
    this.avatar,
    this.stars,
    this.allStars,
    this.voters,
    this.bankName,
    this.accountRip,
    this.nameOwner,
  });

  String id;
  String firstName;
  String lastName;
  bool isDriver;
  bool isShop;
  bool isSos;
  bool isAdmin;
  bool isNormalUser;
  String fullAddress;
  String phone;
  int active;
  bool isOnline;
  String token;
  bool isOnRide;
  bool onWithdraw;
  String onOrderID;
  double balance;
  double totalBalance;
  Map<String, dynamic> personalData;
  String avatar;
  double stars;
  double allStars;
  int voters;
  String bankName;
  String accountRip;
  String nameOwner;

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot docX) {
    Map<String, dynamic> doc = docX.data();
    return UserModel(
      id: docX.id,
      firstName: doc["firstName"],
      lastName: doc["lastName"],
      isDriver: doc["isDriver"] ?? false,
      isShop: doc["isShop"] ?? false,
      isSos: doc["isSos"] ?? false,
      isAdmin: doc["isAdmin"] ?? false,
      isNormalUser: doc["isNormalUser"] ?? false,
      fullAddress: doc["fullAddress"],
      phone: doc["phone"],
      active: doc["active"],
      isOnline: doc["isOnline"] ?? false,
      token: doc["token"],
      isOnRide: doc["isOnRide"] ?? false,
      onWithdraw: doc["onWithdraw"] ?? false,
      onOrderID: doc["onOrderID"] ?? doc["onOrderId"],
      balance: fixDouble(doc["balance"]),
      totalBalance: fixDouble(doc["totalBalance"]) ?? 0.0,
      personalData: doc["personalData"] ?? {},
      avatar: doc["avatar"],
      allStars: fixDouble(doc["allStars"]),
      stars: fixDouble(doc["stars"]),
      voters: doc["voters"] ?? 0,
        bankName: doc["bankName"] ?? null,
        accountRip: doc["accountRip"] ?? null,
        nameOwner: doc["nameOwner"] ?? null,

    );
  }


  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    isDriver: json["isDriver"],
    isShop: json["isShop"],
    isSos: json["isSos"],
    fullAddress: json["fullAddress"],
    phone: json["phone"],
    active: json["active"],
    isOnline: json["isOnline"] ?? false,
    token: json["token"],
    isOnRide: json["isOnRide"] ?? false,
    onWithdraw: json["onWithdraw"] ?? false,
    onOrderID: json["onOrderID"],
    balance: fixDouble(json["balance"]),
    totalBalance: json["totalBalance"] ?? 0.0,
    personalData: json["personalData"] ?? {},
    avatar: json["avatar"],
    allStars: fixDouble(json["allStars"]),
    stars: fixDouble(json["stars"]),
    voters: json["voters"] ?? 0,
    bankName: json["bankName"] ?? null,
    accountRip: json["accountRip"] ?? null,
    nameOwner: json["nameOwner"] ?? null,
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "isDriver": isDriver,
    "isShop": isShop,
    "isSos": isSos,
    "isAdmin": isAdmin,
    "isNormalUser": isNormalUser,
    "fullAddress": fullAddress,
    "phone": phone,
    "active": active,
    "isOnline": isOnline ?? false,
    "isOnRide": isOnRide ?? false,
    "onWithdraw": onWithdraw ?? false,
    "onOrderID": onOrderID,
    "balance": balance ?? 0.0,
    "totalBalance": totalBalance ?? 0.0,
    "personalData": personalData ?? {},
    "avatar": avatar,
    "allStars": allStars,
    "stars": stars,
    "voters": voters,
    "bankName": bankName,
    "accountRip": accountRip,
    "nameOwner": nameOwner,
  };

}


double fixDouble(var number) {
  if(number != null) {
    String n = number.toString();
    if(n.isEmpty || n == null) {
      return 0;
    } else {
      double re = double.tryParse(number.toStringAsFixed(3));
      if(re == null) {
        return 0;
      } else {
        return re;
      }
    }
  } else {
    return 0;
  }
}