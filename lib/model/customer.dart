// To parse this JSON data, do
//
//     final customer = customerFromJson(jsonString);

import 'dart:convert';

Customer customerFromJson(String str) => Customer.fromJson(json.decode(str));

String customerToJson(Customer data) => json.encode(data.toJson());

class Customer {
  int id ;
  String name;
  int phonenb;

  Customer({
    required this.id,
    required this.name,
    required this.phonenb,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json["id"],
    name: json["name"],
    phonenb: json["phonenb"],
  );

  Map<String, dynamic> toJson() => {
    "id":id,
    "name": name,
    "phonenb": phonenb,
  };
}
