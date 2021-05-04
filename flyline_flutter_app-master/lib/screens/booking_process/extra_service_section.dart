import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motel/models/check_flight_response.dart';
import 'package:motel/blocs/bloc.dart';
import 'package:motel/widgets/svg_image_widget.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ExtraServiceSection extends StatefulWidget {
  ExtraServiceSection({
    Key key,
    this.title,
    this.selected,
    @required this.items,
  }) : super(key: key);

  final String title;
  final BagItem selected;
  final List<ExtraServiceItem> items;

  @override
  _ExtraServiceSectionState createState() => _ExtraServiceSectionState();
}

class _ExtraServiceSectionState extends State<ExtraServiceSection> {
  BagItem _activeItem;

  @override
  void initState() {
    _activeItem = widget.selected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: buildMobileContent(),
      desktop: buildWebContent(),
    );
  }

  Widget buildMobileContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (widget.title != null)
            Padding(
              padding: const EdgeInsets.only(
                bottom: 18.0,
                left: 8,
              ),
              child: Text.rich(
                TextSpan(children: [
                  TextSpan(
                    text: widget.title,
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      color: Color(0xff3a3f5c),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  TextSpan(
                    text: '     (Tap as many as needed)',
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      color: Color.fromRGBO(142, 150, 159, 1),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ]),
                textAlign: TextAlign.start,
              ),
            ),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: widget.items
                .map(
                  (e) => InkWell(
                    onTap: () {
                      if (_activeItem == e.bag) {
                        setState(() => _activeItem = null);
                        e.onChange(_activeItem);
                      } else {
                        setState(() => _activeItem = e.bag);
                        e.onChange(
                            _activeItem ?? BagItem(null, null, null, null));
                      }
                    },
                    borderRadius: BorderRadius.circular(27),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(27),
                        border: Border.all(
                          width: 2,
                          color: (_activeItem?.uuid ?? '') == e.bag.uuid
                              ? Color.fromRGBO(4, 174, 238, 1)
                              : Colors.white,
                        ),
                      ),
                      width: (MediaQuery.of(context).size.width - 42) / 2,
                      height: 120,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SvgImageWidget.asset(e.icon),
                          Text(
                            e.bag.category == 'auto_checking'
                                ? 'Auto Check-In'
                                : (e.bag.indices?.length ?? 1) == 1
                                    ? '${categoryTitle(e.definitions[e.bag.indices.first] ?? e.bag)}'
                                    : e.bag.indices.every((element) =>
                                            e.definitions[element].category ==
                                            e.bag.category)
                                        ? '${categoryTitle(e.bag)}'
                                        : e.bag.indices
                                            .map((i) =>
                                                '${categoryTitle(e.definitions[i])} ')
                                            .join(' + '),
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              color: Color.fromRGBO(0, 174, 239, 1),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          Text(
                            '\$${(e?.bag?.price?.amount ?? (flyLinebloc.account.isPremium ? 0.0 : 5.0)).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              color: Color.fromRGBO(58, 63, 92, 1),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }

  Widget buildWebContent() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (widget.title != null)
            Padding(
              padding: const EdgeInsets.only(
                bottom: 18.0,
                left: 8,
              ),
              child: Text.rich(
                TextSpan(children: [
                  TextSpan(
                    text: widget.title,
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      color: Color.fromRGBO(58, 63, 92, 1),
                      fontSize: 16.w,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  TextSpan(
                    text: '     (Tap as many as needed)',
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      color: Color.fromRGBO(187, 196, 220, 1),
                      fontSize: 12.w,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ]),
                textAlign: TextAlign.start,
              ),
            ),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: widget.items
                .map(
                  (e) => InkWell(
                    onTap: () {
                      if (_activeItem == e.bag) {
                        setState(() => _activeItem = null);
                        e.onChange(_activeItem);
                      } else {
                        setState(() => _activeItem = e.bag);
                        e.onChange(
                            _activeItem ?? BagItem(null, null, null, null));
                      }
                    },
                    borderRadius: BorderRadius.circular(27.w),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(27.w),
                        border: Border.all(
                          width: 2,
                          color: (_activeItem?.uuid ?? '') == e.bag.uuid
                              ? Color.fromRGBO(4, 174, 238, 1)
                              : Color.fromRGBO(237, 238, 246, 1),
                        ),
                      ),
                      width: (MediaQuery.of(context).size.width - 42) / 2,
                      height: 120,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SvgImageWidget.asset(e.icon),
                          Text(
                            e.bag.category == 'auto_checking'
                                ? 'Auto Check-In'
                                : (e.bag.indices?.length ?? 1) == 1
                                    ? '${categoryTitle(e.definitions[e.bag.indices.first] ?? e.bag)}'
                                    : e.bag.indices.every((element) =>
                                            e.definitions[element].category ==
                                            e.bag.category)
                                        ? '${categoryTitle(e.bag)}'
                                        : e.bag.indices
                                            .map((i) =>
                                                '${categoryTitle(e.definitions[i])} ')
                                            .join(' + '),
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              color: Color.fromRGBO(0, 174, 239, 1),
                              fontSize: 14.w,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          Text(
                            '\$${(e?.bag?.price?.amount ?? (flyLinebloc.account.isPremium ? 0.0 : 5.0)).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              color: Color.fromRGBO(58, 63, 92, 1),
                              fontSize: 12.w,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }

  String categoryTitle(BagItem bag) {
    switch (bag?.category ?? '') {
      case 'personal_item':
        return 'Personal Item';
      case 'cabin_bag':
        return 'Cabin Bag';
      case 'hand_bag':
        return 'Hand Bag';
      case 'hold_bag':
        return '${bag.indices?.length ?? 1} Checked Bag(s)';
      default:
        return 'Auto-Check-In';
    }
  }
}

class ExtraServiceItem {
  ExtraServiceItem({
    @required this.icon,
    @required this.onChange,
    @required this.bag,
    this.definitions,
  });

  final String icon;
  final Function(BagItem) onChange;
  final BagItem bag;
  final List<dynamic> definitions;
}

class EmptyExtraServiceSection extends StatelessWidget {
  final String title;

  EmptyExtraServiceSection({this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(30),
            child: Row(
              children: <Widget>[
                ScreenTypeLayout(
                  mobile: Container(
                    padding: EdgeInsets.all(0.0),
                    width: 50,
                    child: SvgImageWidget.asset('assets/svg/one_checked.svg')),
                  desktop: Container(
                    padding: EdgeInsets.all(0.0),
                    width: 50.w,
                    child: SvgImageWidget.asset('assets/svg/one_checked.svg')),
                ),
                ScreenTypeLayout(
                  mobile: Container(
                    padding: EdgeInsets.all(0.0),
                    width: 50,
                    child: SvgImageWidget.asset('assets/svg/one_checked.svg')),
                  desktop: Container(
                    padding: EdgeInsets.all(0.0),
                    width: 50.w,
                    child: SvgImageWidget.asset('assets/svg/one_checked.svg')),
                ),
                SizedBox(
                  width: 25,
                ),
                Expanded(
                  child: ScreenTypeLayout(
                    mobile: Text(
                      "If you're looking to add baggage and extras to your booking, go to the airline's website after booking your flight.",
                      style: TextStyle(
                        fontFamily: "Gilroy",
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(142, 150, 159, 1),
                        height: 1.6,
                      ),
                    ),
                    desktop: Text(
                      "If you're looking to add baggage and extras to your booking, go to the airline's website after booking your flight.",
                      style: TextStyle(
                        fontFamily: "Gilroy",
                        fontSize: 12.w,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(112, 112, 112, 1),
                        height: 1.6,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(27),
              border: Border.all(
                width: 2,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
