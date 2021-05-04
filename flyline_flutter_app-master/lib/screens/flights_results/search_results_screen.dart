import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart' as intl;
import 'package:motel/helper/helper.dart';
import 'package:motel/models/filterExplore.dart';
import 'package:motel/models/flight_information.dart';
import 'package:motel/models/locations.dart';
import 'package:motel/blocs/bloc.dart';
import 'package:motel/providers/search_provider.dart';
import 'package:motel/screens/bug_found/bug_page.dart';
import 'package:motel/screens/home/local_widgets/search_result_skeleton.dart';
import 'package:motel/screens/sort_results/search_selector.dart';
import 'package:motel/widgets/app_bar_date_dep_arr.dart';
import 'package:motel/widgets/app_bar_from_to.dart';
import 'package:motel/widgets/app_bar_pop_icon.dart';
import 'package:motel/widgets/svg_image_widget.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'local_widgets/flight_info_card.dart';

const kLabelTextColor = Color(0xFF3a3f5c);
const kPlaceHolderColor = Color(0xFFa2a1b4);

enum _TABS { ROUND_TRIP, ONE_WAY, NOMAD }

class SearchResults extends StatefulWidget {
  final List<FlightRouteObject> routes;
  final bool isRoundTrip;
  final LocationObject departure;
  final LocationObject arrival;
  final String departureCode;
  final String arrivalCode;
  final DateTime startDate;
  final DateTime endDate;
  final String flyingFrom;
  final String flyingTo;
  final String depDate;
  final String arrDate;
  final SearchType type;
  // final Stream<List<FlightInformationObject>> flightsStream;

  SearchResults({
    this.isRoundTrip,
    this.departure,
    this.arrival,
    this.departureCode,
    this.arrivalCode,
    this.startDate,
    this.endDate,
    this.flyingFrom,
    this.flyingTo,
    this.depDate,
    this.arrDate,
    this.routes,
    this.type,
    // this.flightsStream,
  });

  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults>
    with TickerProviderStateMixin {
  bool _clickedSearch = false;
  final myController = TextEditingController();
  AnimationController animationController;
  AnimationController _animationController;
  AnimationController loadingProgressAnimationController;
  Animation<double> animation;
  double loadingIndicatorValue = 0;
  ScrollController scrollController = ScrollController();
  int room = 1;
  int ad = 1;
  int children = 0;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(Duration(days: 5));
  bool isMap = false;
  _TABS activeTab = _TABS.ROUND_TRIP;
  String departureDate;
  String arrivalDate;
  int adults = 0;
  int kids = 0;
  String cabin = "economy";

  final formatDates = intl.DateFormat("dd MMM ");
  final formatTime = intl.DateFormat("hh : mm a");
  final formatAllDay = intl.DateFormat("dd/MM/yyyy");

  LocationObject selectedDeparture;
  LocationObject selectedArrival;

  LocationObject departure;
  LocationObject arrival;
  static var classOfServicesList = [
    "Economy",
    "Premium Economy",
    "Business",
    "First Class"
  ];
  static var classOfServicesValueList = ["M", "W", "C", "F"];

  var selectedClassOfService = classOfServicesList[0];
  var selectedClassOfServiceValue = classOfServicesValueList[0];

  final searchBarHieght = 158.0;
  final filterBarHieght = 52.0;

  int offset = 0;
  int perPage = 20;
  List<FlightInformationObject> originalFlights = List();
  List<FlightInformationObject> listOfFlights = List();
  bool _loadMore = false;
  bool _isLoading = false;
  bool _displayLoadMore = true;

  Map<String, dynamic> airlineCodes;

  FilterExplore filterExplore;
  GlobalKey stickyKey = GlobalKey();
  double heightBox = -1;

  // String get getTypeName => widget.type == SearchType.FARE
  //     ? "   FlyLine Fare"
  //     : widget.type == SearchType.EXCLUSIVE
  //         ? "   FlyLine Exclusive"
  //         : "   Meta Fare";

  // Color get getTypeColor => widget.type == SearchType.FARE
  //     ? Color.fromRGBO(14, 49, 120, 1)
  //     : widget.type == SearchType.EXCLUSIVE
  //         ? Color.fromRGBO(0, 174, 239, 1)
  //         : Color.fromRGBO(68, 207, 87, 1);

  // Color get getTypeBgColor => widget.type == SearchType.FARE
  //     ? Color.fromRGBO(14, 49, 120, 0.2)
  //     : widget.type == SearchType.EXCLUSIVE
  //         ? Color.fromRGBO(0, 174, 239, 0.1)
  //         : Color.fromRGBO(68, 207, 87, 0.1);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String cabins = "economy";

  // Stream<List<FlightInformationObject>> flightsStream;

  @override
  void initState() {

    this.getCity();
    this.getAirlineCodes();

    // if (flightsStream == null) {
    //   flightsStream = widget.flightsStream;
    // }

    offset = 0;
    originalFlights = List();
    listOfFlights = List();
    _clickedSearch = true;
    _isLoading = true;
    listOfFlights.add(null);
    _displayLoadMore = true;

    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    _animationController =
        AnimationController(duration: Duration(milliseconds: 0), vsync: this);
    scrollController.addListener(() {
      if (context != null) {
        if (scrollController.offset <= 0) {
          _animationController.animateTo(0.0);
        } else if (scrollController.offset > 0.0 &&
            scrollController.offset < searchBarHieght) {
          _animationController
              .animateTo((scrollController.offset / searchBarHieght));
        } else {
          _animationController.animateTo(1.0);
        }
      }

      
    });

    loadingProgressAnimationController = AnimationController(
        duration: const Duration(milliseconds: 10000), vsync: this);
      animation = Tween(begin: 0.0, end: 0.95).animate(loadingProgressAnimationController)
      ..addListener(() {
        setState(() {
          loadingIndicatorValue = loadingProgressAnimationController.value;
        });
      });
      loadingProgressAnimationController.forward();

    
    super.initState();

    

    // flightsStream.listen((List<FlightInformationObject> onData) {
      
    // });

    SchedulerBinding.instance.addPostFrameCallback((_) => this.getKey());
  }

  void onFlightsStreamChanged(List<FlightInformationObject> onData) {
    if (onData != null) {
        if (_clickedSearch || _loadMore) {
          setState(() {
            this._loadMore = false;
            this._clickedSearch = false;
            if (listOfFlights.length != 0) {
              if (listOfFlights[listOfFlights.length - 1] == null) {
                listOfFlights.removeLast();
              }
            }
            this._isLoading = false;
            originalFlights.addAll(onData);
            _displayLoadMore = true;
            if ((offset + perPage) > originalFlights.length) {
              listOfFlights.addAll(
                  originalFlights.getRange(offset, originalFlights.length));
              _displayLoadMore = false;
            } else {
              listOfFlights
                  .addAll(originalFlights.getRange(offset, offset + perPage));
            }
            offset = offset + perPage;
          });
        }
      }
  }

  // void getFlightsStream() {
  //                     try {
  //                       flyLinebloc
  //                           .searchFlight(
  //                             widget.searchFlightObject
  //                           )
  //                           .then((_) => setState (() {
  //                                 // flyLinebloc.loadingOverlay.hide();
  //                                 final currency =
  //       Provider.of<SettingsBloc>(context, listen: false).selectedCurrency;
  //     List<String> sortValues = [SortOptions.soonest];
                            //       flightsStream = Rx.combineLatest3<
                            // List<FlightInformationObject>,
                            // List<FlightInformationObject>,
                            // List<FlightInformationObject>,
                            // List<FlightInformationObject>>(
                            //   flyLinebloc.flightsMetaItems(
                            //     currency, sortValues, widget.isRoundTrip),
                            //   flyLinebloc.flightsExclusiveItems(
                            //     currency, sortValues, widget.isRoundTrip),
                            //   flyLinebloc.flightsFareItems(
                            //     currency, sortValues, widget.isRoundTrip),
                            //   (a, b, c) => a + b + c,
                            // ).asBroadcastStream();
  //                                 flightsStream.listen((List<FlightInformationObject> onData) {
  //     if (onData != null) {
  //       if (_clickedSearch || _loadMore) {
  //         setState(() {
  //           this._loadMore = false;
  //           this._clickedSearch = false;
  //           if (listOfFlights.length != 0) {
  //             if (listOfFlights[listOfFlights.length - 1] == null) {
  //               listOfFlights.removeLast();
  //             }
  //           }
  //           this._isLoading = false;
  //           originalFlights.addAll(onData);
  //           _displayLoadMore = true;
  //           if ((offset + perPage) > originalFlights.length) {
  //             listOfFlights.addAll(
  //                 originalFlights.getRange(offset, originalFlights.length));
  //             _displayLoadMore = false;
  //           } else {
  //             listOfFlights
  //                 .addAll(originalFlights.getRange(offset, offset + perPage));
  //           }
  //           offset = offset + perPage;
  //         });
  //       }
  //     }
  //   });
  //                           }));
  //                     } catch (e) {
  //                       setState(() {
  //                         // flyLinebloc.loadingOverlay.hide();
  //                         print('get flights stream error: ${e.toString()}');
  //                       });
  //                     }
  // }

  void getKey() {
    var keyContext = stickyKey.currentContext;
    if (keyContext != null) {
      final box = keyContext.findRenderObject() as RenderBox;
      setState(() {
        heightBox = box.size.height;
      });
    }
  }

  void getAirlineCodes() async {
    airlineCodes = json.decode(await DefaultAssetBundle.of(context)
        .loadString("jsonFile/airline_codes.json"));
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void getCity() async {
    startDate = widget.startDate ?? DateTime.now();
    endDate = widget.endDate ?? DateTime.now().add(Duration(days: 2));
    // if (widget.departure != null) {
      // selectedDeparture = departure = LocationObject(widget.departureCode,
      //     widget.departureCode, "city", widget.departure, "", null);
      selectedDeparture = widget.departure;
    // }

    // if (widget.arrival != null) {
      selectedArrival = widget.arrival;
      // selectedArrival = arrival = LocationObject(widget.arrivalCode,
      //     widget.arrivalCode, "city", widget.arrival, "", null);
    // }

    departureDate = widget.depDate;
    arrivalDate = widget.arrDate;
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  searchForLocation(query, isDeparture) async {
    flyLinebloc.locationItems.add(List<LocationObject>());
    flyLinebloc.locationQuery(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: GestureDetector(
              child: SvgImageWidget.asset(
                'assets/svg/filter.svg',
                width: 20,
                height: 20
              ),
              onTap: () {
                Navigator.push(context, PageRouteBuilder(
                  pageBuilder: (c, a1, a2) => SearchSelector(
                    flyingFrom: widget.flyingFrom,
                    flyingTo: widget.flyingTo,
                    departureDate: DateTime.parse(widget.depDate),
                    isRoundTrip: widget.isRoundTrip,
                    // onUpdateFilter: (stream) {
                    //   setState(() {
                    //     flightsStream = stream;
                    //   });
                    // },
                  ),
                  transitionsBuilder: (c, anim, a2, child) => SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(0.0, 1.0),
                      end: Offset(0.0, 0.0)).animate(anim),
                      child: child,
                    ),
                    transitionDuration: Duration(milliseconds: 500),
                ));
              },
            ),
          )
        ],
        leading: FlatButton(
          padding: EdgeInsets.all(0),
          child: Image.asset(
            'assets/images/back-arrow.png',
            scale: 28,
          ),
          onPressed: () => Navigator.of(context).pop()
        ),
      ),
      key: scaffoldKey,
      backgroundColor: Color.fromRGBO(247, 249, 252, 1),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: getAppBarUI(),
            ),
            if (flyLinebloc.numberOfPassengers > 1)
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Text(
                  'Flight Price is total for all passengers',
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    color: Color(0xFFBBC4DC),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
            Expanded(
              child: Container(
                child: Consumer<SearchProvider>(
                  builder: (_, SearchProvider provider, Widget child) {
                    return StreamBuilder<List<FlightInformationObject>>(
                      stream: provider.flightsStream,
                      builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data.length == 0) return BugPage();
                        if (snapshot.hasData) {
                          // onFlightsStreamChanged(snapshot.data);
                          snapshot.data.sort((a, b) => a.price.compareTo(b.price));
                          return ListView.builder(
                            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                            scrollDirection: Axis.vertical,
                            itemCount: offset != 0
                              ? snapshot.data.length + 1
                              : snapshot.data.length,
                            itemBuilder: (context, index) {
                              if (index != snapshot.data.length) {
                                var flight = snapshot.data[index];
                                if (flight == null && _isLoading) {
                                  return null;
                                }
                                return FlightInfoCard(
                                  flight: flight,
                                  type: flight.kind == null
                                    ? SearchType.EXCLUSIVE
                                    : (
                                        flight.kind == "tripadvisor" ||
                                        flight.kind == "skyscanner" ||
                                        flight.kind == "kayak"
                                      )
                                        ? SearchType.META
                                        : SearchType.FARE,
                                  typeOfTripSelected: this.widget.isRoundTrip ? 0 : 1,
                                  ad: ad,
                                  children: children,
                                  depDate: widget.depDate,
                                  arrDate: widget.arrDate,
                                  selectedClassOfService: selectedClassOfService,
                                );
                              } else {
                                return getLoadMoreButton();
                              }
                            },
                          );
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                          scrollDirection: Axis.vertical,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return SearchResultSkeleton();
                          },
                        );
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  List<Widget> loadItems(
    List<FlightRouteObject> routes,
    List<FlightRouteObject> returns,
  ) {
    List<Widget> lists = List();

    for (var i = 0; i < routes.length - 1; i++) {
      FlightRouteObject route = routes[i];
      lists.add(
        Text(
          '${route.flyTo} ',
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
      );
    }
    return lists;
  }

  List<Widget> loadItemsOneStop(
    List<FlightRouteObject> routes,
  ) {
    List<Widget> lists = List();

    for (var i = 0; i < routes.length - 1; i++) {
      FlightRouteObject route = routes[i];
      var flightTime = Helper.duration(route.duration);
      var flightduration = flightTime.toString();
      lists.add(
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            children: [
              TextSpan(text: '${route.flyTo}  '),
              TextSpan(text: flightduration),
            ],
          ),
        ),
      );
    }
    return lists;
  }

  Widget getFlightDetailItems(
    List<FlightRouteObject> departures,
    List<FlightRouteObject> returns,
  ) {
    List<Widget> lists = List();
    lists.addAll(loadItems(departures, returns));
    //lists.addAll(loadItems(returns.reversed.toList(), 'Return', flight));
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: lists);
  }

  Widget getFlightDetailItemsOneStop(
    List<FlightRouteObject> departures,
    List<FlightRouteObject> returns,
  ) {
    List<Widget> lists = List();
    lists.addAll(loadItemsOneStop(
      departures,
    ));
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: lists);
  }

  Widget getAppBarUI() {
    List<FlightRouteObject> departures = List();
    List<String> departureStopOverCity = List();
    List<FlightRouteObject> returns = List();
    List<String> returnStopOverCity = List();
    var flight = listOfFlights[0];

    if (flight != null) {
      for (FlightRouteObject route in flight.routes) {
        print("1");
        departures.add(route);
        if (route.cityTo != flight.cityTo) {
          departureStopOverCity.add(route.cityTo);
        } else {
          break;
        }
      }

      if (widget.isRoundTrip) {
        for (FlightRouteObject route in flight.routes.reversed) {
          print("2");
          returns.add(route);
          if (route.cityFrom != flight.cityTo) {
            returnStopOverCity.add(route.cityTo);
          } else {
            break;
          }
        }
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: Column(
                      children: <Widget>[
                        AppBarFromTo(
                          flyFrom: widget.flyingFrom,//flight.flyFrom ?? flight.cityFrom,
                          flyTo: widget.flyingTo//flight.flyTo ?? flight.cityTo,
                        ),
                        AppBarDateDepArr(
                          depDate: intl.DateFormat('${intl.DateFormat.MONTH}, ${intl.DateFormat.DAY}').format(DateTime.parse(widget.depDate)),
                          arrDate: widget.isRoundTrip 
                                    ? intl.DateFormat('${intl.DateFormat.MONTH}, ${intl.DateFormat.DAY}').format(DateTime.parse(widget.arrDate))
                                    : null,
                        ),
                      ],
                    ),
                  ),
                  AppBarPopIcon(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getLoadMoreButton() {
    if (!_displayLoadMore) {
      return Container();
    }
    return Column(children: <Widget>[
      InkWell(
        child: Container(
          height: 40,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
          child: Center(
            child: Text("Load More",
                style: TextStyle(
                    color: const Color(0xFF00AFF5),
                    fontSize: 19.0,
                    fontWeight: FontWeight.bold)),
          ),
        ),
        onTap: () {
          if (!_loadMore) {
            setState(() {
              _loadMore = true;
              _isLoading = true;
            });

            if (filterExplore != null) {
              var items = this.originalFlights.where((i) {
                var airlineBool = filterExplore.airlines.map((item) =>
                    item["isSelected"] && i.airlines.contains(item["code"]));

                return i.price >= filterExplore.priceFrom.round() &&
                    i.price <= filterExplore.priceTo.round() &&
                    airlineBool.contains(true);
              }).toList();

              if ((offset + perPage) > items.length) {
                listOfFlights.addAll(items.getRange(offset, items.length));
                _displayLoadMore = false;
              } else {
                listOfFlights.addAll(items.getRange(offset, offset + perPage));
                _displayLoadMore = true;
              }
            } else {
              if ((offset + perPage) > originalFlights.length) {
                listOfFlights.addAll(
                    originalFlights.getRange(offset, originalFlights.length));
                _displayLoadMore = false;
              } else {
                listOfFlights
                    .addAll(originalFlights.getRange(offset, offset + perPage));
                _displayLoadMore = true;
              }
            }
            setState(() {
              offset = offset + perPage;
              _loadMore = false;
              _isLoading = false;
            });
          }
        },
      ),
      SizedBox(height: 38)
    ]);
  }

  refreshDepartureValue(value, isDeparture) {
    if (this.mounted)
      setState(() {
        if (isDeparture)
          selectedDeparture = value;
        else
          selectedArrival = value;
      });
  }

  handleFilter() {
    if (originalFlights.length != 0) {
      if (filterExplore == null) {
        filterExplore = FilterExplore(this.originalFlights, this.airlineCodes);
      }
    }
  }

  void filter(FilterExplore filter) {
    var stop = filter.accomodationListData[0].isSelected
        ? 1
        : filter.accomodationListData[1].isSelected
            ? 2
            : filter.accomodationListData[2].isSelected ? 3 : 0;

    var items = this.originalFlights.where((i) {
      var airlineBool = filter.airlines
          .where((item) =>
              item["isSelected"] &&
              item["title"] != null &&
              i.airlines.contains(item["code"]))
          .toList();
      
      int a2b = i.routes.where((r) => r.returnFlight == 0).toList().length;
      int b2a = i.routes.where((r) => r.returnFlight == 1).toList().length;

      return (i.price >= filter.priceFrom.round() &&
              i.price <= filter.priceTo.round()) &&
          airlineBool.length != 0 &&
          (stop == 0 || (stop > 0 && (a2b == stop || b2a == stop)));
    }).toList();

    setState(() {
      listOfFlights = List();
      _displayLoadMore = true;
      if (offset > items.length) {
        listOfFlights.addAll(items.getRange(0, items.length));
        _displayLoadMore = false;
      } else {
        listOfFlights.addAll(items.getRange(0, offset - perPage));
      }
      filterExplore = filter;
    });
  }
}

class Loader extends StatefulWidget {
  final double radius;
  final double dotRadius;

  Loader({this.radius = 30.0, this.dotRadius = 6.0});

  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  Animation<double> animationRotation;
  Animation<double> animationRadiusIn;
  Animation<double> animationRadiusOut;
  AnimationController controller;

  double radius;
  double dotRadius;

  @override
  void initState() {
    super.initState();

    radius = widget.radius;
    dotRadius = widget.dotRadius;

    controller = AnimationController(
        lowerBound: 0.0,
        upperBound: 1.0,
        duration: const Duration(milliseconds: 3000),
        vsync: this);

    animationRotation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );

    animationRadiusIn = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.75, 1.0, curve: Curves.elasticIn),
      ),
    );

    animationRadiusOut = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 0.25, curve: Curves.elasticOut),
      ),
    );

    controller.addListener(() {
      setState(() {
        if (controller.value >= 0.75 && controller.value <= 1.0)
          radius = widget.radius * animationRadiusIn.value;
        else if (controller.value >= 0.0 && controller.value <= 0.25)
          radius = widget.radius * animationRadiusOut.value;
      });
    });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {}
    });

    controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 100.0,
      //color: Colors.black12,
      child: Center(
        child: RotationTransition(
          turns: animationRotation,
          child: Container(
            //color: Colors.limeAccent,
            child: Center(
              child: Stack(
                children: <Widget>[
                  Transform.translate(
                    offset: Offset(0.0, 0.0),
                    child: Dot(
                      radius: radius,
                      color: Colors.black12,
                    ),
                  ),
                  Transform.translate(
                    child: Dot(
                      radius: dotRadius,
                      color: Colors.amber,
                    ),
                    offset: Offset(
                      radius * cos(0.0),
                      radius * sin(0.0),
                    ),
                  ),
                  Transform.translate(
                    child: Dot(
                      radius: dotRadius,
                      color: Colors.deepOrangeAccent,
                    ),
                    offset: Offset(
                      radius * cos(0.0 + 1 * pi / 4),
                      radius * sin(0.0 + 1 * pi / 4),
                    ),
                  ),
                  Transform.translate(
                    child: Dot(
                      radius: dotRadius,
                      color: Colors.pinkAccent,
                    ),
                    offset: Offset(
                      radius * cos(0.0 + 2 * pi / 4),
                      radius * sin(0.0 + 2 * pi / 4),
                    ),
                  ),
                  Transform.translate(
                    child: Dot(
                      radius: dotRadius,
                      color: Colors.purple,
                    ),
                    offset: Offset(
                      radius * cos(0.0 + 3 * pi / 4),
                      radius * sin(0.0 + 3 * pi / 4),
                    ),
                  ),
                  Transform.translate(
                    child: Dot(
                      radius: dotRadius,
                      color: Colors.yellow,
                    ),
                    offset: Offset(
                      radius * cos(0.0 + 4 * pi / 4),
                      radius * sin(0.0 + 4 * pi / 4),
                    ),
                  ),
                  Transform.translate(
                    child: Dot(
                      radius: dotRadius,
                      color: Colors.lightGreen,
                    ),
                    offset: Offset(
                      radius * cos(0.0 + 5 * pi / 4),
                      radius * sin(0.0 + 5 * pi / 4),
                    ),
                  ),
                  Transform.translate(
                    child: Dot(
                      radius: dotRadius,
                      color: Colors.orangeAccent,
                    ),
                    offset: Offset(
                      radius * cos(0.0 + 6 * pi / 4),
                      radius * sin(0.0 + 6 * pi / 4),
                    ),
                  ),
                  Transform.translate(
                    child: Dot(
                      radius: dotRadius,
                      color: Colors.blueAccent,
                    ),
                    offset: Offset(
                      radius * cos(0.0 + 7 * pi / 4),
                      radius * sin(0.0 + 7 * pi / 4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class Dot extends StatelessWidget {
  final double radius;
  final Color color;

  Dot({this.radius, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: radius,
        height: radius,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
