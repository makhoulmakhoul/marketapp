import 'package:flutter/material.dart';
import 'package:untitled2/service.dart';

class RegisterProduct extends StatefulWidget {
  const RegisterProduct({Key? key}) : super(key: key);

  @override
  State<RegisterProduct> createState() => _RegisterProductState();
}

class _RegisterProductState extends State<RegisterProduct> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Service service = Service();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register Product"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            Text("Name"),
            SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter product name",
              ),
            ),
            SizedBox(height: 10),
            Text("Price"),
            SizedBox(height: 10),
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter product price",
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 10),
            Text("Description"),
            SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter product description",
              ),
              maxLines: 3,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                try {
                  var response = await service.saveProduct(
                    nameController.text,
                    descriptionController.text ,
                    double.parse(priceController.text) ,

                  );
                  if (response.statusCode == 201) {
                    print('Product saved successfully!');
                  } else {
                    print('Failed to save product - ${response.statusCode}: ${response.body}');
                  }
                } catch (e) {
                  print('Error saving product: $e');
                }
              },
              child: Text(
                "Save",
                style: TextStyle(fontSize: 25),
              ),
            ),
          ],
        ),
      ),
    );
  }
}