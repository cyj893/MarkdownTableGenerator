import 'package:flutter/material.dart';

class DescriptionContainer extends StatelessWidget {

  const DescriptionContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey[100],
        border: Border(top: BorderSide(color: Colors.blueGrey[300]!)),
      ),
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("Non commercial | Released under the MIT License"),
          Text("Ver 0.1"),
        ],
      ),
    );
  }

}
