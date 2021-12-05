import 'package:flutter/material.dart';
import 'package:my_expenses/expandable_fab.dart';


class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final orangeColor = const Color(0xffFF8527);
  int _selectedIdx = 0;


  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      child: SizedBox(
        height: 57,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconBottomBar(
                  text: "Home",
                  icon: Icons.insert_chart,
                  selected: _selectedIdx == 0,
                  onPressed: () {
                    setState(() {
                      _selectedIdx = 0;
                    });
                  }),

              // ExpandableFab(
              //   distance: 112.0,
              //   children: [
              //     ActionButton(
              //       onPressed: () => {},
              //       icon: const Icon(Icons.format_size),
              //     ),
              //     ActionButton(
              //       onPressed: () => {},
              //       icon: const Icon(Icons.insert_photo),
              //     ),
              //     ActionButton(
              //       onPressed: () => {},
              //       icon: const Icon(Icons.videocam),
              //     ),
              //   ],
              // ),
              IconBottomBar(
                  text: "Cart",
                  icon: Icons.home,
                  selected: _selectedIdx == 2,
                  onPressed: () {
                    setState(() {
                      _selectedIdx = 2;
                    });
                  }),
              IconBottomBar(
                  text: "Calendar",
                  icon: Icons.settings,
                  selected: _selectedIdx == 3,
                  onPressed: () {
                    setState(() {
                      _selectedIdx = 3;
                    });
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class IconBottomBar extends StatelessWidget {
  const IconBottomBar(
      {Key? key,
        required this.text,
        required this.icon,
        required this.selected,
        required this.onPressed})
      : super(key: key);
  final String text;
  final IconData icon;
  final bool selected;
  final Function() onPressed;

  final orangeColor = const Color(0xffFF8527);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: 28,
            color: selected ? Theme.of(context).primaryColor : Colors.black54,
          ),
        ),
      ],
    );
  }
}

class IconBottomBar2 extends StatelessWidget {
  const IconBottomBar2(
      {Key? key,
        required this.text,
        required this.icon,
        required this.selected,
        required this.onPressed})
      : super(key: key);
  final String text;
  final IconData icon;
  final bool selected;
  final Function() onPressed;
  final orangeColor = const Color(0xffFF8527);
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: orangeColor,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 25,
          color: Colors.white,
        ),
      ),
    );
  }
}
