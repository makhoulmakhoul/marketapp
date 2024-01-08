import 'dart:developer';
import 'dart:js_interop_unsafe';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'model/product.dart';
import 'model/customer.dart';
import 'model/ProductDetail.dart';
import 'pages/products.dart';
import 'pages/customers.dart';
import 'pages/registerCustomer.dart';
import 'pages/registerproduct.dart';
import 'pages/search.dart';
import 'pages/showcust.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './service.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),

      routes: {
        '/main':(context)=>MainPage(),
        '/customer': (context) => Customersshow(),
        '/products':(context)=> Products(),
        '/customers':(context)=>customers(),
        '/searchproduct':(context)=>Search(),

      },// or any other initial route or widget
    );
  }
}

class MainPage extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/customer');
              },
              child: Text('Customers'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/products');
              },
              child: Text('products'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/customers');
              },
              child: Text('create Invoice'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/searchproduct');
              },
              child: Text('searchproduct'),
            ),
          ],
        ),
      ),
    );
  }
}



