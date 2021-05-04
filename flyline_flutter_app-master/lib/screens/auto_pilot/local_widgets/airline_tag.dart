import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motel/blocs/bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';

/// Author: Ali Dali
/// Last Updated: 28-07-2020

class AirLineTag extends StatefulWidget {
  final String name;
  final bool clickable;
  final bool isLastItemIndex;
  final ValueChanged<bool> onExpandList;
  final int lastShowCounter;

  const AirLineTag(this.name,
      {Key key,
      this.clickable = true,
      this.isLastItemIndex = false,
      this.onExpandList,
      this.lastShowCounter})
      : super(key: key);

  @override
  _AirLineTagState createState() => _AirLineTagState();
}

class _AirLineTagState extends State<AirLineTag> {
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    if (widget.clickable) {
      List<String> preferredAirlines = flyLinebloc.preferredAirlines ?? [];
      if (preferredAirlines.contains(widget.name)) {
        _selected = true;
      }
    }

    return GestureDetector(
      onTap: () => widget.clickable
          ? setState(() {
              if (widget.isLastItemIndex) {
                widget.onExpandList(true);
              } else {
                _selected = !_selected;

                List<String> preferredAirlines =
                    flyLinebloc.preferredAirlines ?? [];
                if (_selected) {
                  preferredAirlines.add(widget.name);
                } else {
                  preferredAirlines.remove(widget.name);
                }
                flyLinebloc.setPreferredAirlines(preferredAirlines);
              }
            })
          : null,
      child: ScreenTypeLayout(
        mobile: buildMobileContent(),
        desktop: buildWebContent(),
      ),
    );
  }

  Widget buildMobileContent() {
    return Container(
        margin: const EdgeInsets.only(right: 12),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: _selected
              ? Theme.of(context).primaryColor
              : Color.fromRGBO(229, 247, 254, 1),
        ),
        child: Stack(
          children: <Widget>[
            Center(
              child: (widget.isLastItemIndex)
                  ? Text(
                      "${widget.lastShowCounter}",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    )
                  : Image.asset(
                      'assets/images/preferred_airline_logos/${widget.name.toUpperCase()}.png',
                      height: 25,
                      width: 25,
                    ),
            ),
            if (widget.clickable)
              Positioned(
                top: 2.5,
                left: 2.5,
                child: Text(
                  '+',
                  style: TextStyle(
                      color: _selected
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ),
          ],
        ),
      );
  }

  Widget buildWebContent() {
    return Container(
        margin: EdgeInsets.only(right: 16.w),
        width: 50.w,
        height: 50.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.w),
          color: _selected
              ? Theme.of(context).primaryColor
              : Color.fromRGBO(229, 247, 254, 1),
        ),
        child: Stack(
          children: <Widget>[
            Center(
              child: (widget.isLastItemIndex)
                  ? Text(
                      "${widget.lastShowCounter}",
                      style: TextStyle(
                          fontSize: 20.w,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    )
                  : Image.asset(
                      'assets/images/preferred_airline_logos/${widget.name.toUpperCase()}.png',
                      height: 22.w,
                      width: 22.w,
                    ),
            ),
            if (widget.clickable)
              Positioned(
                top: 5.w,
                left: 5.w,
                child: Text(
                  '+',
                  style: TextStyle(
                      color: _selected
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.w),
                ),
              ),
          ],
        ),
      );
  }
}
