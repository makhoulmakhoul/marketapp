
import 'package:flutter/material.dart';
import 'package:untitled2/service.dart';
class RegisterCutsomer extends StatefulWidget {
  const RegisterCutsomer({super.key});

  @override
  State<RegisterCutsomer> createState() => _RegisterCutsomerState();
}

class _RegisterCutsomerState extends State<RegisterCutsomer> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phonenbController = TextEditingController();
  Service service =Service();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("register Customer"),
      ),
      body:  Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            Text("name"),
            SizedBox(height: 10,),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder() ,
                  hintText: "enter customer name "),
            ),
            Text("PhoneNumeber"),
            SizedBox(height: 10,),
            TextField(
              controller: phonenbController,
              decoration: InputDecoration(
                  border: OutlineInputBorder() ,
                  hintText: "enter customer phone number "),
            ),
            SizedBox(height: 5,),
            ElevatedButton(onPressed: () async {
              try {
                var response = await service.saveCustomer(nameController.text, phonenbController.text);
                if (response.statusCode == 201) {
                  Navigator.pushNamed(context, '/main');
                } else {

                  print('Failed to save customers - ${response.statusCode}: ${response.body}');
                }
              } catch (e) {

                print('Error saving customer: $e');
              }
            },
                child:
                Text("Save",
                  style:
                  TextStyle(
                      fontSize: 25),
                ))

          ],

        ),
      ),


    );
  }
}
