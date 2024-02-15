import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/cheklist_prov.dart';
import 'dart:math' as math;

class CheckBoxListW extends StatefulWidget {
  @override
  _CheckBoxListWState createState() => _CheckBoxListWState();
}

class _CheckBoxListWState extends State<CheckBoxListW> {
  @override
  Widget build(BuildContext context) {
    final checkList = Provider.of<CheckListProv>(context, listen: false);
    final notifiedCheckList = Provider.of<CheckListProv>(context);

    return ListView.builder(
      shrinkWrap: true,
      itemCount: checkList.checkListElements.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: EdgeInsets.all(8),
          child: Row(
            children: [
              Container(
                height: 25,
                child: Checkbox(
                  shape: CircleBorder(),
                  value: notifiedCheckList.isElementsChecked(index),
                  onChanged: (value) {
                    checkList.setIsElementsChecked(index, value!);
                  },
                  activeColor: Color(0xff7CA03E),
                  checkColor: Colors.white,
                ),
              ),
              Flexible(
                child: Text(
                  notifiedCheckList.checkListElements[index],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: notifiedCheckList.isElementsChecked(index)
                        ? Color(0xff7CA03E)
                        : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Size get preferredSize {
    final checkList = Provider.of<CheckListProv>(context, listen: false);
    final itemHeight = 40; // height of each item in the list
    final itemCount = checkList.checkListElements.length;
    final maxHeight = 700; // maximum height when collapsed
    final expandedHeight = itemHeight * itemCount + 16; // calculate height when expanded
    return Size.fromHeight(math.min(expandedHeight as double, maxHeight as double));
  }
}