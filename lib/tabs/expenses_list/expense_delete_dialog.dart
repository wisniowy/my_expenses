import 'package:flutter/material.dart';

showOnDeleteDialog(BuildContext context, Function onAccept, Function onCancel) {
  AlertDialog alert = AlertDialog(
    content: const Text("Are you sure you want to delete this item?",
        style: TextStyle(fontSize: 18, color: Colors.white38,)),
    actions: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          DialogButton(iconData: Icons.check, text: "Ok", onPressed: () {onAccept();}),
          DialogButton(iconData: Icons.clear, text: "Cancel", onPressed: () {onCancel();}),
        ],)
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}


class DialogButton extends StatelessWidget {
  const DialogButton({
    Key? key,
    required this.text,
    required this.iconData,
    required this.onPressed,
  }) : super(key: key);


  final String text;
  final IconData iconData;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return InputChip(
      label: Text(text, style: const TextStyle(fontSize: 18, color: Colors.white38,),
      ),
      avatar: Icon(iconData, size: 20, color: Colors.white54.withOpacity(0.3)),
      onPressed: () {onPressed();},
    );
  }
}