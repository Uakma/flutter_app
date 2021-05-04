import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motel/utils/constants.dart';
import 'package:motel/models/check_flight_response.dart';
import 'package:motel/models/current_trip_data.dart';
import 'package:motel/models/traveler_information.dart';
import 'package:motel/screens/trip_details/local_widgets/trip_details_price_footer.dart';
import 'package:motel/blocs/bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'extra_service_section.dart';

class BaggageDetailsScreen extends StatefulWidget {
  BaggageDetailsScreen(
      {Key key, @required this.onEnd, @required this.type})
      : super(key: key);

  final Function onEnd;
  final String type;

  @override
  _BaggageDetailsScreenState createState() => _BaggageDetailsScreenState();
}

class _BaggageDetailsScreenState extends State<BaggageDetailsScreen> {
  PageController _controller = PageController(initialPage: 0);
  bool _ended = false;
  CurrentTripData currentTripData = flyLinebloc.getCurrentTripData;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      onPageChanged: (_) =>
          setState(() => currentTripData = flyLinebloc.getCurrentTripData),
      children: flyLinebloc.getCurrentTripData.travelersInfo.map((e) {
        int currentTravelerIndex = currentTripData.travelersInfo.indexOf(e);
        return ScreenTypeLayout(
          mobile: buildMobileContent(currentTravelerIndex, e),
          desktop: buildWebContent(currentTravelerIndex, e),
        );
      }).toList(),
    );
  }

  Widget buildMobileContent(int currentTravelerIndex, TravelerInformation e) {
    return Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${e.firstName} ${e.lastName}',
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              color: Color(0xff3a3f5c),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                      ),
                      ..._getBaggageWidgets(currentTravelerIndex, e),
                    ],
                  ),
                ),
              ),
            ),
            if (!_ended)
              StreamBuilder<CurrentTripData>(
                stream: flyLinebloc.outCurrentTripData,
                builder: (context, snapshot) {
                  if (snapshot.hasData)
                    return TripDetailsPriceFooter(
                      total: snapshot.data.totalPrice +
                          snapshot.data.travelersInfo
                              .map((e) =>
                                  (e?.handBag?.price?.amount ?? 0.00) +
                                  (e?.holdBag?.price?.amount ?? 0.00) +
                                  ((e?.autoChecking ?? false)
                                      ? (flyLinebloc?.account?.isPremium ??
                                              false)
                                          ? 0.00
                                          : 5.00
                                      : 0))
                              .toList()
                              .reduce((value, element) => value + element),
                      onTap: () {
                        if (currentTravelerIndex ==
                            snapshot.data.travelersInfo.length - 1) {
                          setState(() {
                            _ended = true;
                          });
                          widget.onEnd();
                        } else {
                          _controller.nextPage(
                            duration: Duration(milliseconds: 200),
                            curve: ElasticInCurve(),
                          );
                        }
                      },
                    );
                  return Container();
                },
              ),
          ],
        );
  }

  Widget buildWebContent(int currentTravelerIndex, TravelerInformation e) {
    return SingleChildScrollView(
      child: Container(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 56.h, horizontal: 45.w),
                    decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(20.w),
                       border: Border.all(
                         width: 2,
                         color: Color.fromRGBO(237, 238, 246, 1)
                       )
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${e.firstName} ${e.lastName}',
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                color: Color(0xff3a3f5c),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ),
                        ..._getBaggageWidgets(currentTravelerIndex, e),
                      ],
                    ),
                  ),
                ),
    );
  }

  List<Widget> _getBaggageWidgets(
      int currentTravelerIndex, TravelerInformation e) {
    return widget.type == FlightType.DUFFEL
        ? [EmptyExtraServiceSection(title: "Select Baggage",)]
        : [
            ExtraServiceSection(
              title: "Select Baggage",
              selected:
                  currentTripData.travelersInfo[currentTravelerIndex].handBag,
              items: flyLinebloc.getCurrentTripData.flightResponse.baggage
                  .combinations.handBag
                  .where((bag) =>
                      bag.conditions.passengerGroups.contains(e.ageCategory))
                  .map((bag) => ExtraServiceItem(
                        icon: 'assets/svg/carry_on.svg',
                        bag: bag,
                        definitions: bag.indices
                            .map((e) => (e is int)
                                ? flyLinebloc.getCurrentTripData.flightResponse
                                    .baggage.definitions.handBag[e]
                                : e)
                            .toList(),
                        onChange: (selected) {
                          if (bag.category == 'hand_bag')
                            currentTripData.travelersInfo[currentTravelerIndex]
                                .handBag = selected;
                          else
                            currentTripData.travelersInfo[currentTravelerIndex]
                                .holdBag = selected;
                          flyLinebloc.setCurrentTripData(currentTripData);
                        },
                      ))
                  .toList(),
            ),
            ExtraServiceSection(
              selected:
                  currentTripData.travelersInfo[currentTravelerIndex].holdBag,
              items: flyLinebloc.getCurrentTripData.flightResponse.baggage
                  .combinations.holdBag
                  .sublist(1)
                  .where((bag) =>
                      bag.conditions.passengerGroups.contains(e.ageCategory))
                  .map((bag) => ExtraServiceItem(
                        icon: 'assets/svg/one_checked.svg',
                        definitions: bag.indices
                            .map((e) => (e is int)
                                ? flyLinebloc.getCurrentTripData.flightResponse
                                    .baggage.definitions.holdBag[e]
                                : e)
                            .toList(),
                        bag: bag,
                        onChange: (selected) {
                          if (bag.category == 'hand_bag')
                            currentTripData.travelersInfo[currentTravelerIndex]
                                .handBag = selected;
                          else
                            currentTripData.travelersInfo[currentTravelerIndex]
                                .holdBag = selected;
                          flyLinebloc.setCurrentTripData(currentTripData);
                        },
                      ))
                  .toList(),
            ),
            ExtraServiceSection(
              title: "Ancillary Items",
              selected: (currentTripData
                          .travelersInfo[currentTravelerIndex]?.autoChecking ??
                      false)
                  ? BagItem(
                      'auto_checking',
                      null,
                      null,
                      null,
                      uuid: 'auto_checking',
                    )
                  : null,
              items: [
                ExtraServiceItem(
                  icon: 'assets/svg/auto_checkin.svg',
                  bag: BagItem(
                    'auto_checking',
                    null,
                    null,
                    null,
                    uuid: 'auto_checking',
                  ),
                  onChange: (selected) {
                    currentTripData.travelersInfo[currentTravelerIndex]
                        .autoChecking = selected != null;
                    flyLinebloc.setCurrentTripData(currentTripData);
                  },
                ),
              ],
            )
          ];
  }
}
