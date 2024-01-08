import 'package:flutter/material.dart';
import 'package:untitled2/model/customer.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:untitled2/pages/registerCustomer.dart';
import 'package:untitled2/pages/EditCustomer.dart';
class Customersshow extends StatefulWidget {
  const Customersshow({Key? key}) : super(key: key);

  @override
  State<Customersshow> createState() => _CustomersState();
}

class _CustomersState extends State<Customersshow> {
  List<Customer> customers = [];
  List<Customer> filteredCustomers = [];
  TextEditingController _nameController = TextEditingController();
  int currentPage = 1;
  int customersPerPage = 10;

  Future<List<Customer>> getCustomers() async {
    // Replace this URL with your actual customer API endpoint
    var response = await http.get(Uri.parse("http://localhost:8081/api/hello"));
    var jsonData = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      List<Customer> retrievedCustomers = [];
      for (Map<String, dynamic> index in jsonData) {
        retrievedCustomers.add(Customer.fromJson(index));
      }
      return retrievedCustomers;
    } else {
      throw Exception('Failed to fetch customers');
    }
  }

  @override
  void initState() {
    super.initState();

    getCustomers().then((retrievedCustomers) {
      setState(() {
        customers = retrievedCustomers;
        filteredCustomers = List.from(customers);
      });
    }).catchError((error) {
      print('Error fetching customers: $error');

    });
  }



  @override
  Widget build(BuildContext context) {
    List<Customer> displayedCustomers = customers
        .skip((currentPage - 1) * customersPerPage)
        .take(customersPerPage)
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Customers'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterCutsomer()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Customer>>(
        future: getCustomers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: displayedCustomers.length,
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
                          'ID: ${filteredCustomers[index].id}',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        Text(
                          'Name: ${filteredCustomers[index].name}',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),

                    IconButton(
                                icon: Icon(Icons.edit),
                              onPressed: () {

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditCustomer(
                                  customerId: filteredCustomers[index].id,
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
          return Center(child: Text('No data'));
        },
      ),
    );
  }
}