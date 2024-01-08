import 'package:flutter/material.dart';
import 'package:untitled2/service.dart';
import 'package:untitled2/model/product.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _nameController = TextEditingController();
  List<Product> cartItems = [];

  Future<void> searchProduct(String name) async {
    try {
      var response = await http.get(Uri.parse("http://localhost:8081/api/pro/$name"));
      var jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        List<Product> products = [];
        for (Map<String, dynamic> productData in jsonData) {
          products.add(Product.fromJson(productData));
        }
        setState(() {
          cartItems = products;
        });
      } else {
        throw Exception('Failed to fetch products');
      }
    } catch (e) {
      print('Error: $e');
      // Handle error here, e.g., show a snackbar or display an error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Enter Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String name = _nameController.text;
                searchProduct(name);
              },
              child: const Text('Search'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Icon(Icons.shopping_cart),
                      title: Text(cartItems[index].name),
                      subtitle: Text('price: ${cartItems[index].price.toString()}'),
                      // Add more details as needed
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

