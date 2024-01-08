import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'model/product.dart';

class Service {

  Future<http.Response> saveCustomer(String name, String phonenb) async {
    try {
      var uri = Uri.parse("http://localhost:8081/api/customers");
      Map<String, String> headers = {
        "content-Type": "application/json; charset=UTF-8"
      };
      Map data = {
        'name': '$name',
        'phonenb': '$phonenb',
      };
      var body = json.encode(data);
      var response = await http.post(uri, headers: headers, body: body);
      return response;
    } catch (e) {
      // Handle any exceptions that might occur during the request
      print('Error saving customer: $e');
      throw Exception('Failed to save customer: $e');
    }
  }

  Future<http.Response> saveProduct(String name, String descrp,
      double price) async {
    try {
      var uri = Uri.parse("http://localhost:8081/api/products");
      Map<String, String> headers = {
        "content-Type": "application/json; charset=UTF-8"
      };
      Map data = {
        'name': '$name',
        'desc': '$descrp',
        'price': '$price'
      };
      var body = json.encode(data);
      var response = await http.post(uri, headers: headers, body: body);
      return response;
    } catch (e) {
      // Handle any exceptions that might occur during the request
      print('Error saving product: $e');
      throw Exception('Failed to save customer: $e');
    }
  }


  Future<void> sendOrderToServer(int customerId,
      List<Map<String, dynamic>> productDetails) async {
    final String url = 'http://localhost:8081/api/invoices'; // Replace with your actual endpoint URL

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'customerId': customerId,
          'productDetails': productDetails,
        }),
      );

      if (response.statusCode == 200) {
        print('Order successfully sent!');
      } else {
        print('Failed to send order: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error sending order: $error');
    }
  }

  Future<http.Response> editcustomer(int custid, String name,
      String phonenb) async {
    try {
      var uri = Uri.parse("http://localhost:8081/api/$custid");
      Map<String, String> headers = {
        "content-Type": "application/json; charset=UTF-8"
      };
      Map data = {
        'name': '$name',
        'phonenb': '$phonenb',
      };
      var body = json.encode(data);
      var response = await http.put(uri, headers: headers, body: body);
      return response;
    } catch (e) {
      // Handle any exceptions that might occur during the request
      print('Error editing customer: $e');
      throw Exception('Failed to edit customer: $e');
    }
  }
  Future<http.Response> editproduct(int proid, String name,
      String price , String desc) async {
    try {
      var uri = Uri.parse("http://localhost:8081/api/pro/$proid");
      Map<String, String> headers = {
        "content-Type": "application/json; charset=UTF-8"
      };
      Map data = {
        'name': '$name',
        'price':'$price',
        'desc':'$desc'
      };
      var body = json.encode(data);
      var response = await http.put(uri, headers: headers, body: body);
      return response;
    } catch (e) {
      // Handle any exceptions that might occur during the request
      print('Error editing product: $e');
      throw Exception('Failed to edit product: $e');
    }
  }
}