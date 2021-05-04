import 'package:flutter/material.dart';
import 'package:motel/utils/constants.dart';

/// Author: Ali Dali
/// Last Updated: 28-07-2020

class TimeFilters extends StatefulWidget {
  final String cityFrom;
  final String cityTo;
  final bool isRoundTrip;
  final List<String> sortValues;
  final Function(List<String>) onConfrim;

  TimeFilters(
      {Key key,
      this.cityFrom,
      this.cityTo,
      this.onConfrim,
      this.isRoundTrip,
      this.sortValues})
      : super(key: key);

  @override
  _TimeFiltersState createState() => _TimeFiltersState();
}

class _TimeFiltersState extends State<TimeFilters> {
  List<String> _sortValues = [];

  @override
  void initState() {
    _sortValues.addAll(widget.sortValues);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Time Preferences',
                    style: TextStyle(
                      color: Color(0xff0e3178),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    '',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: Color.fromRGBO(14, 49, 120, 1),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Text(
                      "Tap a time tag to filter your search results \nby a specific time of day.",
                      style: TextStyle(
                        fontFamily: "Gilroy",
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(142, 150, 159, 1),
                        height: 1.6,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  child: FlatButton(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                    ),
                    onPressed: () {
                      widget.onConfrim(_sortValues);
                      Navigator.pop(context);
                    },
                    color: Color.fromRGBO(0, 174, 239, .1),
                    child: Text(
                      'Confirm Selection(s)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            Text(
              '${widget.cityFrom} - ${widget.cityTo}',
              style: TextStyle(
                color: Color(0xff333333),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            Divider(),
            _buildTimeTags(),
            (!widget.isRoundTrip) ? Offstage() : SizedBox(height: 25),
            (!widget.isRoundTrip)
                ? Offstage()
                : Text(
                    '${widget.cityTo} - ${widget.cityFrom}',
                    style: TextStyle(
                      color: Color(0xff333333),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
            (!widget.isRoundTrip) ? Offstage() : Divider(),
            (!widget.isRoundTrip)
                ? Offstage()
                : _buildTimeTags(isRoundTrip: true),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeTags({bool isRoundTrip = false}) {
    return Column(
      children: <Widget>[
        Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Text(
              'Take-off',
              style: TextStyle(
                color: Color(0xffbbc4dc),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _tag(
                text: 'Morning',
                selected: isRoundTrip == true
                    ? _sortValues.contains(SortOptions.dest_takeOffMorning)
                    : _sortValues.contains(SortOptions.takeOffMorning),
                onPressed: isRoundTrip == true
                    ? () {
                        setState(() {
                          if (_sortValues
                              .contains(SortOptions.dest_takeOffMorning)) {
                            _sortValues.remove(SortOptions.dest_takeOffMorning);
                          } else {
                            if (_sortValues
                                .contains(SortOptions.dest_takeOffEvening)) {
                              _sortValues
                                  .remove(SortOptions.dest_takeOffEvening);
                            }
                            if (_sortValues
                                .contains(SortOptions.dest_takeOffAfterNoon)) {
                              _sortValues
                                  .remove(SortOptions.dest_takeOffAfterNoon);
                            }
                            _sortValues.add(SortOptions.dest_takeOffMorning);
                          }
                        });
                      }
                    : () {
                        setState(() {
                          if (_sortValues
                              .contains(SortOptions.takeOffMorning)) {
                            _sortValues.remove(SortOptions.takeOffMorning);
                          } else {
                            if (_sortValues
                                .contains(SortOptions.takeOffEvening)) {
                              _sortValues.remove(SortOptions.takeOffEvening);
                            }
                            if (_sortValues
                                .contains(SortOptions.takeOffAfterNoon)) {
                              _sortValues.remove(SortOptions.takeOffAfterNoon);
                            }
                            _sortValues.add(SortOptions.takeOffMorning);
                          }
                        });
                      },
              ),
            ),
            Expanded(
              child: _tag(
                text: 'Afternoon',
                selected: isRoundTrip == true
                    ? _sortValues.contains(SortOptions.dest_takeOffAfterNoon)
                    : _sortValues.contains(SortOptions.takeOffAfterNoon),
                onPressed: isRoundTrip == true
                    ? () {
                        setState(() {
                          if (_sortValues
                              .contains(SortOptions.dest_takeOffAfterNoon)) {
                            _sortValues
                                .remove(SortOptions.dest_takeOffAfterNoon);
                          } else {
                            if (_sortValues
                                .contains(SortOptions.dest_takeOffEvening)) {
                              _sortValues
                                  .remove(SortOptions.dest_takeOffEvening);
                            }
                            if (_sortValues
                                .contains(SortOptions.dest_takeOffMorning)) {
                              _sortValues
                                  .remove(SortOptions.dest_takeOffMorning);
                            }
                            _sortValues.add(SortOptions.dest_takeOffAfterNoon);
                          }
                        });
                      }
                    : () {
                        setState(() {
                          if (_sortValues
                              .contains(SortOptions.takeOffAfterNoon)) {
                            _sortValues.remove(SortOptions.takeOffAfterNoon);
                          } else {
                            if (_sortValues
                                .contains(SortOptions.takeOffEvening)) {
                              _sortValues.remove(SortOptions.takeOffEvening);
                            }
                            if (_sortValues
                                .contains(SortOptions.takeOffMorning)) {
                              _sortValues.remove(SortOptions.takeOffMorning);
                            }
                            _sortValues.add(SortOptions.takeOffAfterNoon);
                          }
                        });
                      },
              ),
            ),
            Expanded(
              child: _tag(
                text: 'Evening',
                selected: isRoundTrip == true
                    ? _sortValues.contains(SortOptions.dest_takeOffEvening)
                    : _sortValues.contains(SortOptions.takeOffEvening),
                onPressed: isRoundTrip == true
                    ? () {
                        setState(() {
                          if (_sortValues
                              .contains(SortOptions.dest_takeOffEvening)) {
                            _sortValues.remove(SortOptions.dest_takeOffEvening);
                          } else {
                            if (_sortValues
                                .contains(SortOptions.dest_takeOffMorning)) {
                              _sortValues
                                  .remove(SortOptions.dest_takeOffMorning);
                            }
                            if (_sortValues
                                .contains(SortOptions.dest_takeOffAfterNoon)) {
                              _sortValues
                                  .remove(SortOptions.dest_takeOffAfterNoon);
                            }
                            _sortValues.add(SortOptions.dest_takeOffEvening);
                          }
                        });
                      }
                    : () {
                        setState(() {
                          if (_sortValues
                              .contains(SortOptions.takeOffEvening)) {
                            _sortValues.remove(SortOptions.takeOffEvening);
                          } else {
                            if (_sortValues
                                .contains(SortOptions.takeOffMorning)) {
                              _sortValues.remove(SortOptions.takeOffMorning);
                            }
                            if (_sortValues
                                .contains(SortOptions.takeOffAfterNoon)) {
                              _sortValues.remove(SortOptions.takeOffAfterNoon);
                            }
                            _sortValues.add(SortOptions.takeOffEvening);
                          }
                        });
                      },
              ),
            ),
          ],
        ),
        Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Text(
              'Landing',
              style: TextStyle(
                color: Color(0xffbbc4dc),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _tag(
                text: 'Morning',
                selected: isRoundTrip == true
                    ? _sortValues.contains(SortOptions.dest_landingMorning)
                    : _sortValues.contains(SortOptions.landingMorning),
                onPressed: isRoundTrip == true
                    ? () {
                        setState(() {
                          if (_sortValues
                              .contains(SortOptions.dest_landingMorning)) {
                            _sortValues.remove(SortOptions.dest_landingMorning);
                          } else {
                            if (_sortValues
                                .contains(SortOptions.dest_landingEvening)) {
                              _sortValues
                                  .remove(SortOptions.dest_landingEvening);
                            }
                            if (_sortValues
                                .contains(SortOptions.dest_landingAfterNoon)) {
                              _sortValues
                                  .remove(SortOptions.dest_landingAfterNoon);
                            }
                            _sortValues.add(SortOptions.dest_landingMorning);
                          }
                        });
                      }
                    : () {
                        setState(() {
                          if (_sortValues
                              .contains(SortOptions.landingMorning)) {
                            _sortValues.remove(SortOptions.landingMorning);
                          } else {
                            if (_sortValues
                                .contains(SortOptions.landingEvening)) {
                              _sortValues.remove(SortOptions.landingEvening);
                            }
                            if (_sortValues
                                .contains(SortOptions.landingAfterNoon)) {
                              _sortValues.remove(SortOptions.landingAfterNoon);
                            }
                            _sortValues.add(SortOptions.landingMorning);
                          }
                        });
                      },
              ),
            ),
            Expanded(
              child: _tag(
                text: 'Afternoon',
                selected: isRoundTrip == true
                    ? _sortValues.contains(SortOptions.dest_landingAfterNoon)
                    : _sortValues.contains(SortOptions.landingAfterNoon),
                onPressed: isRoundTrip == true
                    ? () {
                        setState(() {
                          if (_sortValues
                              .contains(SortOptions.dest_landingAfterNoon)) {
                            _sortValues
                                .remove(SortOptions.dest_landingAfterNoon);
                          } else {
                            if (_sortValues
                                .contains(SortOptions.dest_landingEvening)) {
                              _sortValues
                                  .remove(SortOptions.dest_landingEvening);
                            }
                            if (_sortValues
                                .contains(SortOptions.dest_landingMorning)) {
                              _sortValues
                                  .remove(SortOptions.dest_landingMorning);
                            }
                            _sortValues.add(SortOptions.dest_landingAfterNoon);
                          }
                        });
                      }
                    : () {
                        setState(() {
                          if (_sortValues
                              .contains(SortOptions.landingAfterNoon)) {
                            _sortValues.remove(SortOptions.landingAfterNoon);
                          } else {
                            if (_sortValues
                                .contains(SortOptions.landingEvening)) {
                              _sortValues.remove(SortOptions.landingEvening);
                            }
                            if (_sortValues
                                .contains(SortOptions.landingMorning)) {
                              _sortValues.remove(SortOptions.landingMorning);
                            }
                            _sortValues.add(SortOptions.landingAfterNoon);
                          }
                        });
                      },
              ),
            ),
            Expanded(
              child: _tag(
                text: 'Evening',
                selected: isRoundTrip == true
                    ? _sortValues.contains(SortOptions.dest_landingEvening)
                    : _sortValues.contains(SortOptions.landingEvening),
                onPressed: isRoundTrip == true
                    ? () {
                        setState(() {
                          if (_sortValues
                              .contains(SortOptions.dest_landingEvening)) {
                            _sortValues.remove(SortOptions.dest_landingEvening);
                          } else {
                            if (_sortValues
                                .contains(SortOptions.dest_landingMorning)) {
                              _sortValues
                                  .remove(SortOptions.dest_landingMorning);
                            }
                            if (_sortValues
                                .contains(SortOptions.dest_landingAfterNoon)) {
                              _sortValues
                                  .remove(SortOptions.dest_landingAfterNoon);
                            }
                            _sortValues.add(SortOptions.dest_landingEvening);
                          }
                        });
                      }
                    : () {
                        setState(() {
                          if (_sortValues
                              .contains(SortOptions.landingEvening)) {
                            _sortValues.remove(SortOptions.landingEvening);
                          } else {
                            if (_sortValues
                                .contains(SortOptions.landingMorning)) {
                              _sortValues.remove(SortOptions.landingMorning);
                            }
                            if (_sortValues
                                .contains(SortOptions.landingAfterNoon)) {
                              _sortValues.remove(SortOptions.landingAfterNoon);
                            }
                            _sortValues.add(SortOptions.landingEvening);
                          }
                        });
                      },
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _tag({String text, bool selected, Function onPressed}) {
    return Padding(
      padding: const EdgeInsets.only(top: 2, right: 8),
      child: RawMaterialButton(
        onPressed: onPressed,
        //() => setState(() => _selected = !_selected),
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
          child: Text("+ $text",
              style: TextStyle(
                color: selected ? Colors.white : Color.fromRGBO(0, 174, 239, 1),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
              )),
        ),
        fillColor: Color.fromRGBO(0, 174, 239, selected ? 1 : .1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}
