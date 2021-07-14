import 'package:flutter/material.dart';

class GridItemWidget extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final BuildContext context;
  final IconData iconData;
  final String text;
  final VoidCallback onPressed;
  const GridItemWidget({
    Key? key,
    required this.primaryColor,
    required this.secondaryColor,
    required this.context,
    required this.iconData,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 140,
        height: 180,
        decoration: BoxDecoration(
            color: primaryColor, borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Icon(
                iconData,
                size: 80,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              width: 140,
              height: 40,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
