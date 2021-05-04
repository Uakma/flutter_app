import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motel/blocs/bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';

/// Author: Ali Dali
/// Last Updated: 28-07-2020

class Tag extends StatefulWidget {
  final String text;
  bool selected;
  final ValueChanged<bool> onSelected;

  Tag(this.text, {Key key, this.selected = false, this.onSelected})
      : super(key: key);

  @override
  _TagState createState() => _TagState();
}

class _TagState extends State<Tag> {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: buildMobileContent(),
      desktop: buildWebContent(),
    );
  }

  Widget buildMobileContent() {
    return Padding(
      padding: const EdgeInsets.only(top: 2, right: 8),
      child: RawMaterialButton(
        onPressed: () {
          setState(() => widget.selected = !widget.selected);
          widget.onSelected(widget.selected);
        },
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        constraints: BoxConstraints(),
        elevation: 0,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        hoverElevation: 0,
        highlightElevation: 0,
        focusElevation: 0,
        child: FittedBox(
          child: Text("+ ${widget.text}",
              style: TextStyle(
                color: widget.selected
                    ? Colors.white
                    : Color.fromRGBO(0, 174, 239, 1),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
              )),
        ),
        fillColor: Color.fromRGBO(0, 174, 239, widget.selected ? 1 : .1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  Widget buildWebContent() {
    return Padding(
      padding: EdgeInsets.only(top: 0, right: 12.w),
      child: RawMaterialButton(
        onPressed: () {
          setState(() => widget.selected = !widget.selected);
          widget.onSelected(widget.selected);
        },
        padding: EdgeInsets.symmetric(vertical: 11.w, horizontal: 22.w),
        constraints: BoxConstraints(),
        elevation: 0,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        hoverElevation: 0,
        highlightElevation: 0,
        focusElevation: 0,
        child: FittedBox(
          child: Text("+ ${widget.text}",
              style: TextStyle(
                color: widget.selected
                    ? Colors.white
                    : Color.fromRGBO(0, 174, 239, 1),
                fontSize: 12.w,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
              )),
        ),
        fillColor: Color.fromRGBO(0, 174, 239, widget.selected ? 1 : .1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.w)),
      ),
    );
  }
}
