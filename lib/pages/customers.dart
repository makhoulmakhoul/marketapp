import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:untitled2/model/customer.dart';
import 'package:untitled2/model/product.dart';
import 'package:untitled2/model/ProductDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/service.dart';

class customers extends StatefulWidget {
  const customers({super.key});

  @override
  State<customers> createState() => _customersState();
}

class _customersState extends State<customers> {
  Service service = Service();
  int selectedCustomerId = 2;
  List<Customer> customers = [];
  List<Product> allProducts = [];
  List<int> selectedProductIds = [];
  List<ProductDetail> selectedProductDetails = [];
  int currentPage = 1;
  int productsPerPage = 3; // Change this as needed
  Future<List<Product>> getProducts() async {
    var response = await http.get(Uri.parse("http://localhost:8081/api/pro"));
    var jsonData = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      List<Product> retrievedProducts = [];
      for (Map<String, dynamic> index in jsonData) {
        retrievedProducts.add(Product.fromJson(index));
      }
      return retrievedProducts;
    } else {
      throw Exception('Failed to fetch products');
    }
  }
  Future<List<Customer>> getcustomers() async {
    var response = await http.get(Uri.parse("http://localhost:8081/api/hello"));
    var jsonData = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      List<Customer> retrievedcustomers = [];
      for (Map<String, dynamic> index in jsonData) {
        retrievedcustomers.add(Customer.fromJson(index));
      }
      return retrievedcustomers;
    } else {
      throw Exception('Failed to fetch customers');
    }
  }
  @override
  void initState() {
    super.initState();
    // Call getProducts() in initState to populate the products list
    getcustomers().then((retrievedcustomers) {
      setState(() {
        customers = retrievedcustomers;
      } ,
      );
    }).catchError((error) {
      print('Error fetching customers: $error');
      // Handle error if needed
    });
    getProducts().then((retrievedProducts) {
      setState(() {
        allProducts = retrievedProducts;
      });
    }).catchError((error) {
      print('Error fetching products: $error');
      // Handle error if needed
    });
  }


  Widget build(BuildContext context) {
    List<Product> displayedProducts = allProducts
        .skip((currentPage - 1) * productsPerPage)
        .take(productsPerPage)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Customer and Products'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<int>(
              value: selectedCustomerId,
              items: customers.map<DropdownMenuItem<int>>((Customer customer) {
                return DropdownMenuItem<int>(
                  value: customer.id,
                  child: Text(
                    'Customer ID: ${customer.id}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue, // Customize the color
                    ),
                  ),
                );
              }).toList(),
              onChanged: (int? newValue) {
                setState(() {
                  selectedCustomerId = newValue!;
                });
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: displayedProducts.length,
                itemBuilder: (context, index) {
                  final productId = displayedProducts[index].id;
                  final isSelected = selectedProductDetails
                      .any((detail) => detail.productId == productId);
                  int quantity = 0;
                  if (isSelected) {
                    quantity = selectedProductDetails
                        .firstWhere((detail) => detail.productId == productId)
                        .quantity;
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Checkbox(
                          value: isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value ?? false) {
                                selectedProductDetails.add(ProductDetail(
                                  productId: productId,
                                  quantity: 1, // Default quantity as 1
                                ));
                              } else {
                                selectedProductDetails
                                    .removeWhere((detail) => detail.productId == productId);
                              }
                            });
                          },
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Product ID: $productId - ${displayedProducts[index].name}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Qty',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (String value) {
                              final qty = int.tryParse(value) ?? 0;
                              setState(() {
                                if (qty > 0) {
                                  selectedProductDetails.removeWhere(
                                          (detail) => detail.productId == productId);
                                  selectedProductDetails.add(ProductDetail(
                                    productId: productId,
                                    quantity: qty,
                                  ));
                                } else {
                                  selectedProductDetails
                                      .removeWhere((detail) => detail.productId == productId);
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: currentPage > 1
                      ? () {
                    setState(() {
                      currentPage--; // Decrement to go to the previous page
                    });
                  }
                      : null,
                  child: Text('Previous Page'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: displayedProducts.length >= productsPerPage
                      ?() {
                    setState(() {
                      currentPage++; // Increment to go to the next page
                    });
                  }:null,
                  child: Text('Next Page'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Perform actions with selectedCustomerId and selectedProductDetails
                  print('Selected Customer ID: $selectedCustomerId');
                  print('Selected Products with Quantities: $selectedProductDetails');
                  service.sendOrderToServer(selectedCustomerId, selectedProductDetails.map((detail) => detail.toJson()).toList());
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Save',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
