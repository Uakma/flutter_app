import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:motel/models/auto_pilot_alert.dart';
import 'package:motel/blocs/bloc.dart';
import 'package:motel/widgets/svg_image_widget.dart';

import 'auto_pilot_skeleton.dart';

class AutoPilotAlertWidget extends StatefulWidget {
  @override
  _AutoPilotAlertWidgetState createState() => _AutoPilotAlertWidgetState();
}

class _AutoPilotAlertWidgetState extends State<AutoPilotAlertWidget> {
  @override
  Widget build(BuildContext context) {
    final _dateFormatter = DateFormat('${DateFormat.MONTH}, ${DateFormat.DAY}');
    return StreamBuilder<List<AutoPilotAlert>>(
      stream: flyLinebloc.autopilotAlert,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0)
            return SliverToBoxAdapter(child: Container());
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.only(top: 22),
                      height: 100,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 37,
                              width: 37,
                              child: Container(
                                padding: const EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                                child: SvgImageWidget.asset(
                                  "assets/svg/home/auto_pilot.svg",
                                  height: 26,
                                  width: 26,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 26),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 6),
                                      child: Text(
                                        'Autopilot Alert',
                                        style: TextStyle(
                                          fontFamily: 'Gilroy',
                                          fontSize: 12,
                                          color: Color(0xFF44CF57),
                                          fontWeight: FontWeight.w600,
                                        ),
                                        softWrap: true,
                                        maxLines: 1,
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 6.0),
                                      child: Text.rich(
                                        TextSpan(
                                            text:
                                                '${snapshot.data[index].placeFrom.code}  to ${snapshot.data[index].placeTo.code} - ',
                                            style: TextStyle(
                                              fontFamily: 'Gilroy',
                                              fontSize: 18,
                                              color: Color(0xFF0E3178),
                                              fontWeight: FontWeight.w700,
                                            ),
                                            children: [
                                              TextSpan(
                                                text:
                                                    '\$${snapshot.data[index].price}',
                                                style: TextStyle(
                                                  color: Color(0xFF44CF57),
                                                ),
                                              )
                                            ]),
                                        style: TextStyle(
                                          fontFamily: 'Gilroy',
                                          fontSize: 18,
                                          color: Color(0xFF0E3178),
                                          fontWeight: FontWeight.w700,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 4.0),
                                      child: Text(
                                        '${_dateFormatter.format(snapshot.data[index].departureDate)}' +
                                            (snapshot.data[index].returnDate !=
                                                    null
                                                ? '  - ${_dateFormatter.format(snapshot.data[index].returnDate)}'
                                                : ''),
                                        style: TextStyle(
                                          fontFamily: 'Gilroy',
                                          fontSize: 12,
                                          color: Color.fromRGBO(142, 150, 159, 1),
                                          fontWeight: FontWeight.w500,
                                        ),
                                        softWrap: true,
                                        maxLines: 5,
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                print("deleting the item");
                                _cancel(snapshot.data[index].id);
                              },
                              child: SvgImageWidget.asset(
                                "assets/svg/home/cancel.svg",
                                color: Colors.red,
                                height: 12,
                                width: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              childCount: snapshot.data.length,
            ),
          );
        }
        return SliverToBoxAdapter(child: Padding(
          padding:
          const EdgeInsets.only(left: 18.0, right: 18.0, top: 22),
          child: AutoPilotSkeleton(),
        ));
      },
    );
  }

  void _cancel(int id) {
    flyLinebloc.deleteAutopilotAlert(id).then((value) {
      if (value['success'] == true) {
        print("delete success");
        setState(() {
          flyLinebloc.autopilotAlerts();
        });
      } else {
        if (value['message'] != null) {
          print("delete errors" + value['message']);
          _showErrorMsg(value['message']);
        } else {
          print('Unknown error');
          _showErrorMsg('Unknown error');
        }
      }
    }).catchError((e) => print(e));
  }

  void _showErrorMsg(String msg) {
    Flushbar(
      icon: Icon(
        Icons.info_outline,
        size: 28.0,
        color: Colors.blueAccent,
      ),
      messageText: Text(
        msg,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          color: Colors.white,
          fontSize: 14.0,
        ),
      ),
      duration: Duration(seconds: 3),
      isDismissible: true,
    )..show(context);
  }
}
