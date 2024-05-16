import 'package:flutter/material.dart';

class UiHelper{
  static CustomTextField(TextEditingController controller, String text, IconData iconData, bool toHide){
    return TextField(
      controller: controller,
      obscureText: toHide,
      decoration: InputDecoration(
        hintText: text,
        suffixIcon: Icon(iconData),
        suffixIconColor: Colors.blueAccent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        )
    )
    );
  }

  static CustomButton(VoidCallback voidCallback, String text){
    return SizedBox(
      height: 50,
      width: 150,
      child: ElevatedButton(
        onPressed: (){
          voidCallback();
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        ),
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        )
      ),
    );
  }

  static CustomAlertBox(BuildContext context, String text){
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text(text),
        actions: [
          TextButton(onPressed: (){ Navigator.pop(context);}, child: const Text("OK"))
        ],
        surfaceTintColor: Colors.blueAccent,
      );
    });
  }
}