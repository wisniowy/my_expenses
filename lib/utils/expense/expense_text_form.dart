import 'package:flutter/material.dart';

class ExpenseTextForm extends StatelessWidget {
  const ExpenseTextForm({
    Key? key, required this.name,
    required this.initialValue,
    required this.icon,
    required this.enabled,
    required this.onSaved,
    this.textInputType = TextInputType.name,
  }) : super(key: key);

  final String name;
  final String initialValue;
  final IconData icon;
  final bool enabled;
  final Function onSaved;
  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType,
      onSaved: (value) {onSaved(value);},
      onFieldSubmitted: (value) {onSaved(value);},
      style: TextStyle(color: Colors.white70),
      cursorColor: Theme.of(context).primaryColor.withOpacity(0.6),
      initialValue: initialValue,
      enabled: enabled,
      decoration: InputDecoration(
        icon: Icon(icon, size: 25, color: Colors.white24),
        border: UnderlineInputBorder(),
        labelText: name,
        focusColor: Theme.of(context).primaryColor,
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.6))),
      ),
    );
  }
}