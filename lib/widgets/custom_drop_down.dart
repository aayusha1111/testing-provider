import 'package:flutter/material.dart';

class CustomDropDown extends StatelessWidget {
   CustomDropDown({super.key,this.onChanged,this.labelText,this.itemList,this.validator});
  Function(dynamic)? onChanged;
  String? labelText;
  List<String>?itemList;
  String? Function(String?)? validator;
  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: itemList?.map((item)=>DropdownMenuItem(value: item,child: Text(item)))
        .toList(),
        validator: validator,
        
        
         onChanged: onChanged),
    );
  }
}