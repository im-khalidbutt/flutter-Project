import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color colorName;
  final String btnName;
  final Icon iconName;
  final VoidCallback onPressed;
  const CustomButton({
    super.key,
    required this.colorName,
    required this.btnName,
    required this.onPressed,
    required this.iconName,
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(

      style: ElevatedButton.styleFrom(

        primary: Colors.blueAccent[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),


      ),
      icon: iconName,
      onPressed: onPressed,
      label:Text(btnName, style: TextStyle(color: colorName))
    );
    // return ElevatedButton(
    //     onPressed: onPressed,
    //     child: Text(
    //         btnName,
    //         style: TextStyle(color: colorName
    //         ),
    //     ),
    //   style: ElevatedButton.styleFrom(
    //     primary: Colors.red,
    //     elevation: 0,
    //     side: BorderSide(
    //       color: Colors.red,
    //     ),
    //   ),
    // );
  }
}
