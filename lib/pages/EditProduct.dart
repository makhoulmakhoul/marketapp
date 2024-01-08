import 'package:flutter/material.dart';
import 'package:untitled2/service.dart';
import 'package:untitled2/model/customer.dart'; // Import your Customer model
class EditProduct extends StatefulWidget {
  final int proId ;
   EditProduct({required this.proId});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  @override
  Widget build(BuildContext context) {
    Service service =Service();
    TextEditingController _nameController = TextEditingController();
    TextEditingController _priceController = TextEditingController();
    TextEditingController _descController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
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
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _descController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {

                  var response = await service.editproduct(widget.proId,_nameController.text, _priceController.text ,_descController.text );
                  if (response.statusCode == 200) {

                    Navigator.pushNamed(context, '/products');
                  } else {
                    print('Failed to edit product - ${response.statusCode}: ${response.body}');
                  }
                } catch (e) {

                  print('Error editing product: $e');
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
