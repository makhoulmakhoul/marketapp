// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';


class Product {
  int id ;
  String name;
  double price;
  String desc;


  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.desc,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    name: json["name"],
    price: json["price"]?.toDouble(),
    desc: json["desc"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
    "desc": desc,
  };
}
