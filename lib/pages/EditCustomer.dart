import 'package:flutter/material.dart';
import 'package:untitled2/service.dart';
import 'package:untitled2/model/customer.dart'; // Import your Customer model

class EditCustomer extends StatefulWidget {
  final int customerId;
  Service service =Service();

 EditCustomer({required this.customerId});

  @override
  State<EditCustomer> createState() => _EditCustomerState();
}

class _EditCustomerState extends State<EditCustomer> {
  Service service =Service();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Customer'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  try {

                    var response = await service.editcustomer(widget.customerId,_nameController.text, _phoneController.text);
                    if (response.statusCode == 200) {

                      Navigator.pushNamed(context, '/customer');
                    } else {
                      print('Failed to edit customers - ${response.statusCode}: ${response.body}');
                    }
                  } catch (e) {

                    print('Error editing customer: $e');
                  }
                }
              , child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
