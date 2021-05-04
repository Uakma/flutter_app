import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:motel/models/flight_information.dart';
import 'package:motel/models/locations.dart';
import 'package:motel/blocs/bloc.dart';
import 'package:motel/widgets/svg_image_widget.dart';

class LocationSearchUI extends StatefulWidget {
  LocationSearchUI({
    Key key,
    this.onChange,
    this.controller,
    this.hintText = '',
    this.backgroundColor = const Color(0xFFF7F9FC),
    this.onClear,
    this.style = const TextStyle(
      fontStyle: FontStyle.normal,
      fontFamily: 'Gilroy',
      color: Color(0xFF333333),
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    this.fillColor,
    this.hintStyle = const TextStyle(
      fontWeight: FontWeight.w500,
      fontFamily: "Gilroy",
      color: Color(0xFFBBC4DC),
    ),
    this.isWeb = false
  }) : super(key: key);

  final Function(LocationObject value) onChange;
  final void Function(TextEditingController) onClear;
  final hintText;
  final TextEditingController controller;
  final TextStyle style;
  final TextStyle hintStyle;
  final Color backgroundColor;
  final Color fillColor;
  final bool isWeb;

  @override
  _LocationSearchUIState createState() => _LocationSearchUIState();
}

class _LocationSearchUIState extends State<LocationSearchUI> {
  List<FlightInformationObject> listOfFlights = List();
//  TextEditingController controller;
  BorderRadius defaultBorderRadius = BorderRadius.circular(15);
  bool showClose = false;

  @override
  void initState() {
//    controller = controller ?? TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isWeb) defaultBorderRadius = BorderRadius.circular(8);
    return Stack(children: <Widget>[
      TypeAheadFormField<LocationObject>(
        autovalidate: true,
        hideSuggestionsOnKeyboardHide: true,
        keepSuggestionsOnLoading: false,
        debounceDuration: Duration(seconds: 1),
        transitionBuilder: (context, suggestionsBox, controller) {
          return suggestionsBox;
        },
        onSuggestionSelected: (location) {
          widget.controller.text =
              '${location.name} ${location.subdivisionName} ${location.countryCode} ';
          widget.onChange(location);
        },
        getImmediateSuggestions: true,
        suggestionsBoxDecoration: SuggestionsBoxDecoration(
          color: Colors.white,
          borderRadius: defaultBorderRadius,
          elevation: 8,
        ),
        textFieldConfiguration: TextFieldConfiguration(
          controller: widget.controller,
          onChanged: (val) {
            if (val != '') {
              setState(() {
                showClose = true;
              });
            } else {
              setState(() {
                showClose = false;
              });
            }
          },
          autofocus: false,
          style: widget.style,
          decoration: InputDecoration(
            fillColor: widget.fillColor ?? Color.fromRGBO(247, 249, 252, 1),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: defaultBorderRadius,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: widget.isWeb ? 10 : 20, horizontal: widget.isWeb ? 10 : 20),
            enabledBorder: OutlineInputBorder(
              borderRadius: defaultBorderRadius,
              borderSide: BorderSide(color: Colors.transparent, width: 0.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: defaultBorderRadius,
              borderSide: BorderSide(color: Color(0xFF0E3178), width: 1.0),
            ),
            hintText: widget.hintText,
            hintStyle: widget.hintStyle,
          ),
          textAlign: TextAlign.start,
        ),
        suggestionsCallback: (search) async {
          if (search.length > 0) {
            return flyLinebloc.locationQuery(search);
          } else
            return null;
        },
        itemBuilder: (context, location) {
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF8F8FC),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading: SvgImageWidget.asset("assets/svg/home/pin.svg",
                      height: widget.isWeb ? 11 : 22.0,
                      width: widget.isWeb ? 11 : 22.0,
                    ),
                    title: Text(
                      '${location.name} ${location.subdivisionName} ${location.countryCode}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      Row(
        children: <Widget>[
          Expanded(
            child: Align(
              alignment: FractionalOffset.centerRight,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: widget.isWeb ? 5 : 10, horizontal: widget.isWeb ? 8 : 15),
                child: Visibility(
                    visible: widget.controller.text.toString().length > 0,

                      child: InkWell(
                        child: Padding(
                          padding: EdgeInsets.all(widget.isWeb ? 5.0 : 10.0),
                          child: SvgImageWidget.asset(
                            'assets/svg/home/clear_field.svg',
                            width: widget.isWeb ? 6 : 12,
                          ),
                        ),
                        onTap: () {
                          widget.controller.text = "";
                          widget.onClear(widget.controller);
                        },

                  ),
                ),
              ),
            ),
          ),
        ],
      )
    ]);
  }
}
