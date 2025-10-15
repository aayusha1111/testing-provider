import 'package:flutter/material.dart';

class CustomTextformfield extends StatelessWidget {
   CustomTextformfield({super.key,this.labelText,this.hintText,this.keyboardType,this.validator,this.onChanged,this.prefixIcon,this.suffixIcon,this.obscureText,this.child,this.isPassword=false,this.title,this.initialValue});

  String?labelText;
  String?hintText;
  TextInputType? keyboardType;
  Widget? suffixIcon,prefixIcon;
  String? Function(String?)? validator;
  Function(String)? onChanged;
  bool? obscureText;
  Widget? child;
  bool isPassword; 
  Widget? title;
  String? initialValue;
  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:EdgeInsets.all(12),
      child: TextFormField(
        initialValue: initialValue,
      
        keyboardType: keyboardType??TextInputType.text,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        onChanged: onChanged,
        obscureText: obscureText?? false,
        decoration: InputDecoration(
          suffixIcon:suffixIcon ,
          prefixIcon: prefixIcon,
          labelText: labelText,
          hintText: hintText,
          
          
          

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12)
          )
        ),
      )

       );
  }
}