import 'package:flutter/material.dart';

class ExpenseTextForm extends StatelessWidget {
  const ExpenseTextForm({
    Key? key, required this.name,
    required this.initialValue,
    required this.icon,
    required this.enabled,
  }) : super(key: key);

  final String name;
  final String initialValue;
  final IconData icon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Colors.white70),
      initialValue: initialValue,
      enabled: enabled,
      decoration: InputDecoration(
        icon: Icon(icon, size: 25, color: Colors.white24),
        border: UnderlineInputBorder(),
        labelText: name,
      ),
    );
  }
}