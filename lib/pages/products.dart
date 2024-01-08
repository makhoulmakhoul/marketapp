import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:untitled2/model/product.dart';
import 'package:untitled2/pages/registerproduct.dart';
import 'package:untitled2/pages/EditProduct.dart';

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  List<Product> products = [];
  List<Product> filteredProducts = [];
  TextEditingController _nameController = TextEditingController();
  List<Product> cartItems = [];
  int currentPage = 1;
  int productsPerPage = 10;

  Future<List<Product>> getProducts() async {
    try {
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
    } catch (e) {
      print('Error fetching data: $e');
    }
  return [];
  }

    @override
    void initState() {
      super.initState();
      // we use this bcz wjen we open the page the function getproduct will call automatically
      getProducts().then((retrievedProducts) {
        setState(() {
          products = retrievedProducts;
          filteredProducts = List.from(products);
        });
      }).catchError((error) {
        print('Error fetching products: $error');
        // Handle error if needed
      });
    }

  Future<void> searchProduct(String name) async {
    try {
      var response = await http.get(Uri.parse("http://localhost:8081/api/pro/$name"));
      var jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        List<Product> searchedProducts = [];
        for (Map<String, dynamic> productData in jsonData) {
          searchedProducts.add(Product.fromJson(productData));
        }

        setState(() {
          if (name.isEmpty) {
            filteredProducts = products;
          } else {
            filteredProducts = searchedProducts;
          }
        });
      } else {
        throw Exception('Failed to fetch products');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  @override
    Widget build(BuildContext context) {
      List<Product> displayedProducts = products
          .skip((currentPage - 1) * productsPerPage)
          .take(productsPerPage)
          .toList();

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: TextField(
            onChanged: (value) => searchProduct(value),
            decoration: InputDecoration(
              labelText: 'search',
              suffixIcon: Icon(Icons.search),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add_circle),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterProduct()),
                );
              },
            ),
          ],
        ),
        body: FutureBuilder<List<Product>>(
          future: getProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: displayedProducts.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 4,
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'ID: ${filteredProducts[index].id}',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          Text(
                            'Name: ${filteredProducts[index].name}',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          Text(
                            'Description: ${filteredProducts[index].desc}',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          Text(
                            'Price: ${filteredProducts[index].price}',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProduct(
                                    proId: filteredProducts[index].id,
                                  ),
                                ),
                              );
                            },

                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return Center(
                child: Text('No products'));
          },
        ),
      );
    }

}
