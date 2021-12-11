import 'package:flutter/material.dart';

class ExpenseTile extends StatelessWidget {
  final String name;
  final String date;
  final double price;
  final Widget trailingIcon = const Icon(Icons.arrow_right);
  final Function() onTap;

  const ExpenseTile(
      {required this.onTap,
        Key? key,
        required this.name,
        required this.date,
        required this.price})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.black38,
          radius: 15,
          child: Icon(Icons.attach_money, color: Theme.of(context).primaryColor.withOpacity(0.5),),),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(price.toString(), style: const TextStyle(color: Colors.white70),
              textScaleFactor: 1.2,),
            const SizedBox(width: 15.0),
            const Text("PLN", textScaleFactor: 0.9,),
          ],
        ),
        subtitle: Row(
          children: [
            Text(name),
            Container(
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.grey,),
                child: const Padding(padding: EdgeInsets.symmetric(horizontal: 12),
                  child: SizedBox(width: 4, height: 4),)),
            Text(date),
          ],
        ),
        trailing: const Icon(Icons.arrow_right, color: Colors.white38),
        selected: false,
        onTap: onTap,
      ),
      textColor: Colors.white38,
      iconColor: Theme.of(context).primaryColor,
    );
  }
}