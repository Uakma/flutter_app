import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart' as ui_help;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';
import 'package:motel/blocs/settings_bloc.dart';
import 'package:motel/helper/data_helper.dart';
import 'package:motel/main.dart';
import 'package:motel/providers/search_provider.dart';
import 'package:motel/screens/date_picker/datepicker_screen.dart';
import 'package:motel/screens/auto_pilot/local_widgets/reservation_details_wrapper.dart';
import 'package:motel/screens/flights_results/search_results_screen.dart';
import 'package:motel/screens/home/local_widgets/blue_button.dart';
import 'package:motel/screens/home/local_widgets/home_intro_widget.dart';
import 'package:motel/screens/home/local_widgets/intro_text_box_widget.dart';
import 'package:motel/screens/home/local_widgets/web_bottom_button.dart';
import 'package:motel/screens/home/local_widgets/web_search_widget.dart';
import 'package:motel/screens/introduction/introductionScreen.dart';
import 'package:motel/screens/log_in/log_in.dart';
import 'package:motel/screens/sign_up/sign_up.dart';
import 'package:motel/utils/constants.dart';
import 'package:motel/widgets/button_bar_widget.dart';
import 'package:motel/widgets/expanded_section.dart';
import 'package:motel/widgets/location_search_ui.dart';
import 'package:motel/widgets/svg_image_widget.dart';
import 'package:motel/widgets/value_incrementer.dart';
import 'package:motel/widgets/web_bottom_widget.dart';
import 'package:motel/widgets/web_header_widget.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:rxdart/rxdart.dart';
import '../../theme/appTheme.dart';
import '../../models/flight_information.dart';
import '../../models/locations.dart';
import '../../blocs/bloc.dart';


const kLabelTextColor = Color(0xff0E3178);
const kPlaceHolderColor = Color(0xffBBC4DC);
final Color bottomMenuActiveColor = HexColor("#0E3178");
final Color bottomMenuNormalColor = HexColor("#BBC4DC");
enum _TABS { ROUND_TRIP, ONE_WAY, NOMAD }

/// actual animation will just run 1/3 of total time
const transitionAnimationTime = 2500; // in miliseconds

enum WebMenuItem {
  SignIn,
  SignUp,
  Home,
  Wallet,
  Trips,
  AppiOS,
  AppAndroid,
  Help,
  Instagram,
  Twitter,
  Medium,
  Facebook
}

class HomeScreen extends StatefulWidget {
  final String departure;
  final String arrival;
  final String departureCode;
  final String arrivalCode;
  final DateTime startDate;
  final DateTime endDate;

  HomeScreen({
    Key key,
    this.arrival,
    this.departure,
    this.arrivalCode,
    this.departureCode,
    this.startDate,
    this.endDate,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, RouteAware {
  ButtonMarker selectedButton = ButtonMarker.user;
  bool isSwitched = true;
  FocusNode navi = FocusNode();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPopNext() {
    if (flyLinebloc.isLoggedIn) {
      flyLinebloc.accountInfo();
      flyLinebloc.flightSearchHistory();
      flyLinebloc.autopilotAlerts();
    } else {
      flyLinebloc.logout();
    }
    super.didPopNext();
  }

  bool _isSearched = false;

  bool get isRoundTrip => typeOfTripSelected == 0;
  final myController = TextEditingController();
  AnimationController animationController;
  AnimationController _animationController;
  ScrollController scrollController = ScrollController();
  int room = 1;
  int children = 0;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(Duration(days: 5));
  bool isMap = false;
  _TABS activeTab = _TABS.ROUND_TRIP;
  String departureDate;
  String arrivalDate;
  String cabin = "economy";
  final formatDates = intl.DateFormat("dd MMM");
  final formatTime = intl.DateFormat("hh : mm a");
  final formatAllDay = intl.DateFormat("dd/MM/yyyy");
  var typeOfTripSelected = 0;
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
  int offset = 20;
  int perPage = 20;
  List<FlightInformationObject> originalFlights = List();
  List<FlightInformationObject> listOfFlights = List();
  List<FlightRouteObject> returns = List();
  List<bool> _clickFlight = List();
  bool _loadMore = false;
  bool _isLoading = false;
  bool _displayLoadMore = true;
  bool _isBothSelected = true;
  Map<String, dynamic> airlineCodes;
  var filterExplore;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey stickyKey = GlobalKey();
  double heightBox = -1;

  final Color selectedMenuColor = Color.fromRGBO(14, 49, 120, 1);
  WebMenuItem selectedMenu = WebMenuItem.Home;

  /// if true intro screen will be shown otherwise flight detail view will shown
  bool isIntroModeOn = true;
  AnimationController _transitionController;
  AnimationController _slideSearchTransitionController;
  Animation _slidingAnimationIntoPart;
  Animation _slidingAnimationFlightDetailPart;
  Animation _slidingAnimationBottomAppBar;
  Animation _slidingAnimationWebContent;
  Animation _slidingAnimationWebSearch;
  Animation _slidingAnimationWebBottom;

  initStreams() {
    flyLinebloc.setAdults(1);
    flyLinebloc.setChildren(0);
  }

  void _showSnackBar(message, context) {
    final snackBar =
    SnackBar(content: Text(message));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  void initState() {
    initStreams();
    if (flyLinebloc.isLoggedIn) {
      flyLinebloc.accountInfo();
      flyLinebloc.flightSearchHistory();
      flyLinebloc.autopilotAlerts();
      flyLinebloc.initStore();
      generateFCMToken();
    } else {
      flyLinebloc.logout();
    }
    animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _animationController = AnimationController(
      duration: Duration(milliseconds: 0),
      vsync: this,
    );
    scrollController.addListener(() {
      if (context != null) {
        if (scrollController.offset <= 0) {
          _animationController.animateTo(0.0);
        } else if (scrollController.offset > 0.0 &&
            scrollController.offset < searchBarHieght) {
          // we need around searchBarHieght scrolling values in 0.0 to 1.0
          _animationController
              .animateTo((scrollController.offset / searchBarHieght));
        } else {
          _animationController.animateTo(1.0);
        }
      }
    });

    _transitionController = AnimationController(
        duration: Duration(milliseconds: transitionAnimationTime), vsync: this);
    _slideSearchTransitionController = AnimationController(
        duration: Duration(milliseconds: transitionAnimationTime), vsync: this);
    _slidingAnimationIntoPart =
        Tween<Offset>(begin: Offset(0, 0), end: Offset(-1, 0)).animate(
      CurvedAnimation(
        parent: _transitionController,
        curve: Interval(0.33, 0.66, curve: Curves.fastOutSlowIn),
      ),
    );
    _slidingAnimationFlightDetailPart =
        Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0)).animate(
      CurvedAnimation(
          parent: _transitionController,
          curve: Interval(0.33, 0.66, curve: Curves.fastOutSlowIn)),
    );
    _slidingAnimationBottomAppBar =
        Tween<Offset>(begin: Offset(0, 0), end: Offset(0.0, 1.0)).animate(
      CurvedAnimation(
        parent: _transitionController,
        curve: Interval(0.33, 0.66, curve: Curves.fastOutSlowIn),
      ),
    );
    _slidingAnimationWebContent =
        Tween<Offset>(begin: Offset(0, 0), end: Offset(0.0, -0.6)).animate(
      CurvedAnimation(
        parent: _slideSearchTransitionController,
        curve: Interval(0.33, 0.66, curve: Curves.fastOutSlowIn),
      ),
    );
    _slidingAnimationWebSearch =
        Tween<Offset>(begin: Offset(0, 2), end: Offset(0.0, 0.4)).animate(
      CurvedAnimation(
        parent: _slideSearchTransitionController,
        curve: Interval(0.33, 0.66, curve: Curves.fastOutSlowIn),
      ),
    );
    _slidingAnimationWebBottom =
        Tween<Offset>(begin: Offset(0, 0), end: Offset(0.0, 1.0)).animate(
      CurvedAnimation(
        parent: _slideSearchTransitionController,
        curve: Interval(0.33, 0.66, curve: Curves.fastOutSlowIn),
      ),
    );

    this.getCity();
    this.getAirlineCodes();

    _controller.addListener(() {
      setState(() {
        _imageOffset = 1.0 -
            min(
              max(0.0, (248.0 - _controller.position.extentAfter) / 248.0),
              1.0,
            );
      });
    });
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) => this.getKey());
  }

  double _imageOffset = 1;

  void getKey() {
    var keyContext = stickyKey.currentContext;
    if (keyContext != null) {
      // widget is visible
      final box = keyContext.findRenderObject() as RenderBox;
      setState(() {
        heightBox = box.size.height;
      });
      print("height" + box.size.height.toString());
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
    if (widget.departure != null) {
      selectedDeparture = departure = LocationObject(
        widget.departureCode,
        widget.departureCode,
        "city",
        widget.departure,
        "",
        null,
      );
    }
    if (widget.arrival != null) {
      selectedArrival = arrival = LocationObject(
        widget.arrivalCode,
        widget.arrivalCode,
        "city",
        widget.arrival,
        "",
        null,
      );
    }
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  searchForLocation(query, isDeparture) async {
    flyLinebloc.locationItems.add(List<LocationObject>());
    flyLinebloc.locationQuery(query);
  }

  void tapMenuAction(WebMenuItem menuType) {
    switch (menuType) {
      case WebMenuItem.SignIn:
        Navigator.of(context).pop();
        showDialog(
          context: context, 
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: (MediaQuery.of(context).size.width - 557.h) / 2,
                vertical: (MediaQuery.of(context).size.height - 640.h) / 2,
              ),
              child: LoginScreen(),
            )
          )
        );
        break;
      case WebMenuItem.SignUp:
        Navigator.of(context).pop();
        showDialog(
          context: context, 
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: (MediaQuery.of(context).size.width - 557.h) / 2,
                vertical: (MediaQuery.of(context).size.height - 640.h) / 2,
              ),
              child: SignUpScreen(),
            )
          )
        );
        break;
      default:
        break;
    }
  }

  String getMenuTitle(WebMenuItem menuType) {
    switch (menuType) {
      case WebMenuItem.SignIn:
      return 'Sign In';
      case WebMenuItem.SignUp:
        return 'Sign Up';
      case WebMenuItem.Home:
        return 'Home';
      case WebMenuItem.Wallet:
        return 'Wallet';
      case WebMenuItem.Trips:
        return 'Trips';
      case WebMenuItem.AppiOS:
        return 'iOS App';
      case WebMenuItem.AppAndroid:
        return 'Android App';
      case WebMenuItem.Help:
        return 'Help Center';
      case WebMenuItem.Instagram:
        return 'Instagram';
      case WebMenuItem.Twitter:
        return 'Twitter';
      case WebMenuItem.Medium:
        return 'Medium';
      case WebMenuItem.Facebook:
        return 'Faceook';
    }
    return '';
  }

  Widget getMenuIcon(WebMenuItem menuType) {
    switch (menuType) {
      case WebMenuItem.SignIn:
        return Image.asset(
          'assets/images/ic_user_web.png',
          width: 26.w * 2 / 3,
          height: 26.w * 2 / 3,
          color: selectedMenu == WebMenuItem.SignIn 
            ? selectedMenuColor : null
        );
      case WebMenuItem.SignUp:
        return Image.asset(
          'assets/images/ic_user_web.png',
          width: 26.w * 2 / 3,
          height: 26.w * 2 / 3,
          color: selectedMenu == WebMenuItem.SignUp 
            ? selectedMenuColor : null
        );
      case WebMenuItem.Home:
        return SvgImageWidget.asset(
          'assets/icons/home.svg',
          width: 25.3.w * 2 / 3,
          height: 25.3.w * 2 / 3,
          color: selectedMenu == WebMenuItem.Home 
            ? selectedMenuColor : null
        );
      case WebMenuItem.Wallet:
        return SvgImageWidget.asset(
          'assets/icons/wallet.svg',
          width: 25.w * 2 / 3,
          height: 25.w * 2 / 3,
          color: selectedMenu == WebMenuItem.Wallet 
            ? selectedMenuColor : null
        );
      case WebMenuItem.Trips:
        return SvgImageWidget.asset(
          'assets/icons/trips.svg',
          width: 21.3.w * 2 / 3,
          height: 24.9.w * 2 / 3,
          color: selectedMenu == WebMenuItem.Trips 
            ? selectedMenuColor : null
        );
      case WebMenuItem.AppiOS:
        return SvgImageWidget.asset(
          'assets/svg/apple.svg',
          width: 22.2.w * 2 / 3,
          height: 25.4.w * 2 / 3,
          color: selectedMenu == WebMenuItem.AppiOS 
            ? selectedMenuColor : null
        );
      case WebMenuItem.AppAndroid:
        return SvgImageWidget.asset(
          'assets/svg/playstore.svg',
          width: 23.8.w * 2 / 3,
          height: 26.7.w * 2 / 3,
          color: selectedMenu == WebMenuItem.AppAndroid 
            ? selectedMenuColor : null
        );
      case WebMenuItem.Help:
        return Image.asset(
          'assets/images/ic_info_web.png',
          width: 26.w * 2 / 3,
          height: 26.w * 2 / 3,
          color: selectedMenu == WebMenuItem.Help 
            ? selectedMenuColor : null
        );
      case WebMenuItem.Instagram:
        return Image.asset(
          'assets/images/ic_instagram_web.png',
          width: 26.w * 2 / 3,
          height: 26.w * 2 / 3,
          color: selectedMenu == WebMenuItem.Instagram 
            ? selectedMenuColor : null
        );
      case WebMenuItem.Twitter:
        return Image.asset(
          'assets/images/ic_twitter_web.png',
          width: 26.w * 2 / 3,
          height: 26.w * 2 / 3,
          color: selectedMenu == WebMenuItem.Twitter 
            ? selectedMenuColor : null
        );
      case WebMenuItem.Medium:
        return Image.asset(
          'assets/images/ic_medium_web.png',
          width: 26.w * 2 / 3,
          height: 26.w * 2 / 3,
          color: selectedMenu == WebMenuItem.Medium 
            ? selectedMenuColor : null
        );
      case WebMenuItem.Facebook:
        return Image.asset(
          'assets/images/ic_facebook_web.png',
          width: 26.w * 2 / 3,
          height: 26.w * 2 / 3,
          color: selectedMenu == WebMenuItem.Facebook 
            ? selectedMenuColor : null
        );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 1920, height: 1080, allowFontScaling: true);
    ScreenUtil.init(context, width: 1280, height: 888, allowFontScaling: true);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        drawer: buildDrawer(),
        endDrawer: buildEndDrawer(),
        body: ScreenTypeLayout(
          mobile: buildMobileBody(),
          desktop: buildWebBody(),
        ),
      ),
    );
  }

  Widget buildEndDrawer() {
    return Container(
      width: 280,
      // height: MediaQuery.of(context).size.height,
      child: Drawer(
        child: DatePickerScreen(
                                          shouldChooseMultipleDates:
                                              activeTab == _TABS.ROUND_TRIP || activeTab == _TABS.NOMAD,
                                          departurePlace:
                                              selectedDeparture ?? null,
                                          arrivalPlace: selectedArrival ?? null,
                                          departure: departureDate == null
                                              ? DateTime.now()
                                              : DateTime.parse(departureDate),
                                          arrival: arrivalDate == null
                                              ? DateTime.now()
                                              : DateTime.parse(arrivalDate),
                                          selected: arrivalDate == null
                                              ? false
                                              : true,
                                          showMonth: departureDate == null
                                              ? DateTime.now().month
                                              : DateTime.parse(departureDate)
                                                  .month,
                                          adults: flyLinebloc.outAdults.value,
                                          children:
                                              flyLinebloc.outChildren.value,
                                          didSelectDate: (dateResult) async {
                                            if (dateResult == null) return;
                                            setState(() {
                                              departureDate =
                                                  dateResult.departureDate.toString();
                                              if (activeTab == _TABS.ROUND_TRIP &&
                                                  dateResult.returnDate != null)
                                                arrivalDate =
                                                    dateResult.returnDate.toString();
                                              if (activeTab == _TABS.NOMAD &&
                                                  dateResult.returnDate != null)
                                                arrivalDate =
                                                    dateResult.returnDate.toString();
                                            });
                                            if (activeTab == _TABS.NOMAD) {
                                                flyLinebloc.setDepartureDate(DateTime.parse(departureDate));
                                                if (arrivalDate != null) {
                                                  flyLinebloc.setReturnDate(DateTime.parse(arrivalDate));
                                                } else {
                                                  flyLinebloc.setReturnDate(null);
                                                }
                                                
                                                // Set default value
                                                flyLinebloc.setProbability(60);
                                                flyLinebloc.setMaxPrice(550);
                                                flyLinebloc.getPriceData(flyLinebloc.departureLocation.code, flyLinebloc.arrivalLocation.code, "", flyLinebloc.outAdults.value.toString(), flyLinebloc.outChildren.value.toString());
                                              }
                                          },
                                        ),
      ),
    );
  }

  Widget buildDrawer() {
    return Container(
      width: 198.w,
      child: Drawer(
        child: Column(
          children: [
            Container(
              height: 72.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 28.w),
                child: Row(
                  children: [
                    WebAppIcon(),
                    Expanded(
                      child: Container(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Hide',
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 12.w,
                              color: Color.fromRGBO(51, 51, 51, 1),
                              fontWeight: FontWeight.bold
                            ),
                            textAlign: TextAlign.right
                          ),
                        )
                      ),
                    ),
                    SizedBox(
                      width: 24.w
                    )
                  ],
                )
              ),
            ),
            Container(
              height: 1,
              color: Color.fromRGBO(229, 229, 229, 0.5)
            ),
            Container(
              padding: EdgeInsets.only(top: 10.h),
              height: 139.h * 2 /3,
              child: Column(
                children: [
                  buildDrawerMenuItem(WebMenuItem.SignIn),
                  buildDrawerMenuItem(WebMenuItem.SignUp),
                ],
              ),
            ),
            Container(
              height: 1,
              color: Color.fromRGBO(229, 229, 229, 0.5)
            ),
            Container(
              padding: EdgeInsets.only(top: 10.h),
              height: 204.h * 2 /3,
              child: Column(
                children: [
                  buildDrawerMenuItem(WebMenuItem.Home),
                  buildDrawerMenuItem(WebMenuItem.Wallet),
                  buildDrawerMenuItem(WebMenuItem.Trips),
                ],
              ),
            ),
            Container(
              height: 1,
              color: Color.fromRGBO(229, 229, 229, 0.5)
            ),
            Container(
              padding: EdgeInsets.only(top: 10.h),
              height: 204.h * 2 /3,
              child: Column(
                children: [
                  buildDrawerMenuItem(WebMenuItem.AppiOS),
                  buildDrawerMenuItem(WebMenuItem.AppAndroid),
                  buildDrawerMenuItem(WebMenuItem.Help),
                ],
              ),
            ),
            Container(
              height: 1,
              color: Color.fromRGBO(229, 229, 229, 0.5)
            ),
            Container(
              padding: EdgeInsets.only(top: 10.h),
              height: 264.h * 2 /3,
              child: Column(
                children: [
                  buildDrawerMenuItem(WebMenuItem.Instagram),
                  buildDrawerMenuItem(WebMenuItem.Twitter),
                  buildDrawerMenuItem(WebMenuItem.Medium),
                  buildDrawerMenuItem(WebMenuItem.Facebook),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildDrawerMenuItem(WebMenuItem menuType) {
    return Container(
      height: 40.h,
      child: InkWell(
        onTap: () {
          if (menuType != WebMenuItem.SignIn && menuType != WebMenuItem.SignUp) {
            setState(() {
            selectedMenu = menuType;
          });
          }
          
          tapMenuAction(menuType);
        },
        child: Row(
          children: [
            Container(
              width: 64.w,
              child: Container(
                child: getMenuIcon(menuType),
              ),
            ),
            Expanded(
              child: Container(
                child: Text(
                  getMenuTitle(menuType),
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 12.w,
                    color: selectedMenu == menuType 
                      ? selectedMenuColor 
                      : Color.fromRGBO(187, 196, 220, 1),
                    fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.left,
                )
              )
            )
          ],
        ),
      )
    );
  }

  Widget buildWebHomeContent() {
    return SizedBox(
                width: 698,
                height: 250,
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Text(
                            'Travel planning ',
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 30,
                              color: Color.fromRGBO(0, 174, 239, 1),
                              fontWeight: FontWeight.bold
                            )
                          ),
                          Text(
                            'on autopilot',
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 30,
                              color: Color.fromRGBO(14, 49, 120, 1),
                              fontWeight: FontWeight.bold
                            )
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 350),
                      child: tabsHeader(),
                    ),
                    SizedBox(height: 15),
                    Container(
                      child: Row(
                        children: [
                          Container(
                            width: 184,
                            height: 36,
                            child: buildSelectDepartureField(isWeb: true)
                          ),
                          SizedBox(width: 5),
                          Container(
                            width: 184,
                            height: 36,
                            child: buildSelectArrivalField(isWeb: true)
                          ),
                          SizedBox(width: 5),
                          Container(
                            child: InkWell(
                              child: Container(
                                width: activeTab == _TABS.NOMAD ? 150 : 95,
                                height: 36,
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                margin: const EdgeInsets.only(right: 5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color: (_isBothSelected)
                                            ? Colors.white
                                            : Colors.red),
                                    borderRadius: BorderRadius.circular(8),
                                    color: Color(0xFFF7F9FC)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        departureDate != null
                                            ? DateFormat("MM-dd-yyyy").format(
                                                DateTime.parse(departureDate))
                                            : (activeTab == _TABS.NOMAD ? "Select Trip Dates" : "Dep Date"),
                                        style: departureDate != null
                                            ? TextStyle(
                                                fontStyle: FontStyle.normal,
                                                fontFamily: 'Gilroy',
                                                color: Color(0xFF333333),
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                              )
                                            : TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "Gilroy",
                                                fontSize: 10,
                                                color: Color(0xffBBC4DC),
                                              ),
                                      ),
                                    ),
                                    Container(height: 5)
                                  ],
                                ),
                              ),
                              onTap: () async {
                                _slideSearchTransitionController.reverse();
                                if (selectedArrival != null &&
                                    selectedDeparture != null) {_scaffoldKey.currentState.openEndDrawer();
                                } else {
                                  setState(() {
                                    if (selectedDeparture != null &&
                                        selectedArrival != null) {
                                      _isBothSelected = true;
                                    } else {
                                      _isBothSelected = false;
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                          SizedBox(width: 5),
                          activeTab == _TABS.ONE_WAY || activeTab == _TABS.NOMAD
                              ? Container()
                              : Expanded(
                                  child: InkWell(
                                    child: Container(
                                      width: 95,
                                      height: 36,
                                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                      margin: const EdgeInsets.only(left: 5),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: (_isBothSelected)
                                                  ? Colors.white
                                                  : Colors.red),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Color(0xFFF7F9FC)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            child: Text(
                                              arrivalDate != null
                                                  ? DateFormat("MM-dd-yyyy")
                                                      .format(DateTime.parse(
                                                          arrivalDate
                                                              .toString()))
                                                  : "Ret Date",
                                              style: arrivalDate != null
                                                  ? TextStyle(
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontFamily: 'Gilroy',
                                                      color: Color(0xFF333333),
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    )
                                                  : TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: "Gilroy",
                                                      fontSize: 10,
                                                      color: Color(0xffBBC4DC),
                                                    ),
                                            ),
                                          ),
                                          Container(
                                            height: 23,
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () async {
                                      _slideSearchTransitionController.reverse();
                                      if (selectedArrival != null &&
                                          selectedDeparture != null) {_scaffoldKey.currentState.openEndDrawer();
                                      } else {
                                        setState(() {
                                          if (selectedDeparture != null &&
                                              selectedArrival != null) {
                                            _isBothSelected = true;
                                          } else {
                                            _isBothSelected = false;
                                          }
                                        });
                                      }
                                    },
                                  ),
                                ),
                          SizedBox(width: 12),
                          Container(
                            width: activeTab == _TABS.NOMAD ? 128 : 105,
                            child: BlueButtonWidget(
                              width: activeTab == _TABS.NOMAD ? 128 : 105,
                              height: 31,
                              text: (activeTab == _TABS.NOMAD)
                                ? "Set Reservation\nPreferences"
                                : "Search",
                              onPressed: () {
                                if (activeTab == _TABS.NOMAD) {
                                  if (selectedDeparture == null || selectedArrival == null || departureDate == null)
                                    return;

                                  flyLinebloc.setDepartureLocation(selectedDeparture);
                                  flyLinebloc.setArrivalLocation(selectedArrival);

                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ReservationsDetailsWrapper()));
                                } else {
                                  _slideSearchTransitionController.forward();

                                  context.read<SearchProvider>().setSearching(true);

                                  final currency = Provider.of<SettingsBloc>(context, listen: false).selectedCurrency;
                                  List<String> sortValues = [SortOptions.soonest];
                                  context.read<SearchProvider>().setFlightsStream(Rx.combineLatest3<
                                    List<FlightInformationObject>,
                                    List<FlightInformationObject>,
                                    List<FlightInformationObject>,
                                    List<FlightInformationObject>>(
                                      flyLinebloc.flightsMetaItems(
                                        currency, sortValues, isRoundTrip),
                                      flyLinebloc.flightsExclusiveItems(
                                        currency, sortValues, isRoundTrip),
                                      flyLinebloc.flightsFareItems(
                                        currency, sortValues, isRoundTrip),
                                      (a, b, c) => a + b + c,
                                    ).asBroadcastStream());

                                  try {
                                    flyLinebloc
                                        .searchFlight(
                                          selectedDeparture.type +
                                              ":" +
                                              selectedDeparture.code,
                                          selectedArrival.type + ":" + selectedArrival.code,
                                          DateTime.parse(departureDate),
                                          DateTime.parse(departureDate),
                                          isRoundTrip ? "round" : "oneway",
                                          isRoundTrip ? DateTime.parse(arrivalDate) : null,
                                          isRoundTrip ? DateTime.parse(arrivalDate) : null,
                                          flyLinebloc.outAdults.value,
                                          "0",
                                          "0",
                                          selectedClassOfServiceValue,
                                          "USD",
                                          this.offset.toString(),
                                          this.perPage.toString(),
                                        )
                                        .then((_) {
                                          context.read<SearchProvider>().setSearching(false);
                                        });
                                  } catch (e) {
                                    // setState(() {
                                      // flyLinebloc.loadingOverlay.hide();
                                    // });
                                    context.read<SearchProvider>().setSearching(false);
                                  }
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 79,
                            height: 26,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  cabin = "economy";
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(
                                    0, 
                                    174, 
                                    239, 
                                    cabin == "economy" ? 1 : 0.1
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              color: Color.fromRGBO(
                                                  247, 249, 252, 1),
                                              width: 1.2))),
                                  child: Center(
                                    child: Text(
                                      cabin == "economy" ? "Economy" : "+ Economy",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Gilroy',
                                          fontSize: 9,
                                          color: cabin == "economy"
                                              ? Colors.white
                                              : Color.fromRGBO(0, 174, 239, 1)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 6),
                          Container(
                            width: 96,
                            height: 26,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  cabin = "business";
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(
                                    0, 
                                    174, 
                                    239, 
                                    cabin == "business" ? 1 : 0.1
                                  ),
                                  borderRadius: BorderRadius.circular(15)
                                ),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              color: Color.fromRGBO(
                                                  247, 249, 252, 1),
                                              width: 1.2))),
                                  child: Center(
                                    child: Text(
                                      cabin == "business" ? "Business Class" : "+ Business Class",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Gilroy',
                                          fontSize: 9,
                                          color: cabin == "business"
                                              ? Colors.white
                                              : Color.fromRGBO(0, 174, 239, 1)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 6),
                          Container(
                            width: 80,
                            height: 26,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  cabin = "fClass";
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(
                                    0, 
                                    174, 
                                    239, 
                                    cabin == "fClass" ? 1 : 0.1
                                  ),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 0),
                                  child: Center(
                                    child: Text(
                                      cabin == "fClass" ? "First Class" : "+ First Class",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Gilroy Bold',
                                          fontSize: 9,
                                          color: cabin == "fClass"
                                              ? Colors.white
                                              : Color.fromRGBO(0, 174, 239, 1)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          Container(
                            color: Color.fromRGBO(247, 249, 252, 1),
                            width: 2,
                            height: 25,
                          ),
                          SizedBox(width: 15),
                          Container(
                            width: 120,
                            height: 26,
                            child: WebValueIncrementer(
                              stream: flyLinebloc.outAdults,
                              setter: flyLinebloc.setAdults,
                              title: 'Adults',
                            )
                          ),
                          SizedBox(width: 10),
                          Container(
                            width: 114,
                            height: 26,
                            child: WebValueIncrementer(
                              stream: flyLinebloc.outChildren,
                              setter: flyLinebloc.setChildren,
                              title: 'Kids',
                            )
                          )
                        ],
                      )
                    )
                  ],
                )
              );
  }

  Widget buildWebBody() {
    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              _slideSearchTransitionController.reverse();
            },
            child: Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: Center(
                child: SlideTransition(
                  child: buildWebHomeContent(),
                  position: _slidingAnimationWebContent,
                ),
              ) 
            )
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              child: WebBottomWidget(),
              position: _slidingAnimationWebBottom,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SlideTransition(
              child: Container(
                width: 698,
                // height: 500,
                child: Column(
                  children: [
                    Container(
                      height: 1,
                      margin: EdgeInsets.only(bottom: 30.w),
                      color: Color.fromRGBO(237, 238, 246, 1),
                    ),
                    Expanded(                      
                      child: Container(
                        child: WebSearchWidget(
                          depDate: departureDate,
                          retDate: arrivalDate,
                          children: flyLinebloc.outChildren.value,
                          adults: flyLinebloc.outAdults.value,
                          room: 0,
                          selectedClassOfService: selectedClassOfService,
                          typeOfTripSelected: typeOfTripSelected,
                        ),
                      )
                    )
                  ],
                ),
              ),
              position: _slidingAnimationWebSearch,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: WebHeaderWidget(
              leftButton: GestureDetector(
                child: SvgImageWidget.asset(
                  'assets/svg/home/menu.svg',
                  width: 31.h,
                  height: 20.h,
                ),
                onTap: () {
                  _scaffoldKey.currentState.openDrawer();
                },
              ),
              rightButton: BlueButtonWidget(
                width: 132.w,
                height: 43.h,
                text: 'Sign in',
                onPressed: () {
                  showDialog(
                    context: context, 
                    child: Material(
                      type: MaterialType.transparency,
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: (MediaQuery.of(context).size.width - 557.h) / 2,
                          vertical: (MediaQuery.of(context).size.height - 640.h) / 2,
                        ),
                        child: IntroductionScreen(
                          onTapSignIn: () {
                            Navigator.of(context).pop();
                            showDialog(
                              context: context, 
                              child: Material(
                                type: MaterialType.transparency,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: (MediaQuery.of(context).size.width - 557.h) / 2,
                                    vertical: (MediaQuery.of(context).size.height - 640.h) / 2,
                                  ),
                                  child: LoginScreen(),
                                )
                              )
                            );
                          },
                          onTapSignUp: () {
                            Navigator.of(context).pop();
                            showDialog(
                              context: context, 
                              child: Material(
                                type: MaterialType.transparency,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: (MediaQuery.of(context).size.width - 557.h) / 2,
                                    vertical: (MediaQuery.of(context).size.height - 640.h) / 2,
                                  ),
                                  child: SignUpScreen(),
                                )
                              )
                            );
                          }
                        ),
                      )
                    )
                  );
                },
              ),
            ),
          ),
          
        ],
      )
    );
  }

  Widget buildMobileBody() {
    return InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Container(
            child: Column(
              children: <Widget>[
                getAppBarUI(),
                Expanded(
                  child: Container(
                    color: Color(0xFFF7F9FC),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        selectJourney(),
                        Expanded(
                          child: Stack(
                            children: [
                              SlideTransition(
                                position: _slidingAnimationFlightDetailPart,
                                child: tabsContent(),
                              ),
                              SlideTransition(
                                position: _slidingAnimationIntoPart,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 110),
                                  child: HomeIntroWidget(
                                    navigator: navi,
                                    setTab: (value) {
                                      if (value == 2) {
                                        setState(() {
                                          activeTab = _TABS.NOMAD;
                                        });
                                      }
                                      if (value == 1) {
                                        setState(() {
                                          activeTab = _TABS.ROUND_TRIP;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: SlideTransition(
                                  position: _slidingAnimationBottomAppBar,
                                  child: BottomBar(
                                    currentPage: BottomPage.Home,
                                    context: context,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
  }

  Widget tabsHeader() {
    return Container(
//        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color(0xffffffff),
              blurRadius: 0,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    typeOfTripSelected = 0;
                    activeTab = _TABS.ROUND_TRIP;
                    context.read<SearchProvider>().setRoundTrip(typeOfTripSelected == 0);
                  });
                  _slideSearchTransitionController.reverse();
                },
                child: Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent)),
                    child: Center(
                        child: Column(
                      children: <Widget>[
                        Text(
                          "Round-trip",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Gilroy',
                            fontSize: 14,
                            color: activeTab == _TABS.ROUND_TRIP
                                ? Color(0xff0E3178)
                                : Color(0xffBBC4DC),
                          ),
                        ),
                        Container(
                          width: 30,
                          margin: EdgeInsets.only(top: 15),
                        ),
                      ],
                    ))),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    typeOfTripSelected = 1;
                    activeTab = _TABS.ONE_WAY;
                    context.read<SearchProvider>().setRoundTrip(typeOfTripSelected == 0);
                  });
                  _slideSearchTransitionController.reverse();
                },
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent)),
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Center(
                        child: Column(
                      children: <Widget>[
                        Text(
                          "One-way",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Gilroy',
                            fontSize: 14,
                            color: activeTab == _TABS.ONE_WAY
                                ? Color(0xff0E3178)
                                : Color(0xffBBC4DC),
                          ),
                        ),
                        Container(
                          width: 30,
                          margin: EdgeInsets.only(top: 15),
                        ),
                      ],
                    ))),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    activeTab = _TABS.NOMAD;
                  });
                  _slideSearchTransitionController.reverse();
                },
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent)),
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Center(
                        child: Column(
                      children: <Widget>[
                        Text(
                          "Autopilot",
                          style: TextStyle(
                            fontFamily: "Gilroy",
                            fontWeight: FontWeight.w600,
                            color: activeTab == _TABS.NOMAD
                                ? Color(0xff0E3178)
                                : Color(0xffBBC4DC),
                          ),
                        ),
                        Container(
                          width: 30,
                          margin: EdgeInsets.only(top: 15),
                        ),
                      ],
                    ))),
              ),
            ),
          ],
        ));
  }

  double _calculateTextHeight({double fontSize = 16}) {
    final constraints = BoxConstraints(
      maxWidth: 10.0,
      minHeight: 0.0,
      minWidth: 0.0,
    );
    RenderParagraph renderParagraph = RenderParagraph(
      TextSpan(
        text: "Any Text",
        //TextStyle used in autoComplete
        style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontSize == null ? null : FontWeight.w600),
      ),
      textDirection: ui_help.TextDirection.ltr,
      maxLines: 1,
    );
    renderParagraph.layout(constraints);
    return renderParagraph.getMinIntrinsicHeight(fontSize).ceilToDouble();
  }

  double _calculateTabsHeight() {
    double topPadding = 20;
    double bottomContainerHeight = 30;
    double tabTextHeight = _calculateTextHeight(fontSize: 14);
    return topPadding + bottomContainerHeight + tabTextHeight;
  }

  double _calculateHeight() {
    double screenHeight = _screenHeight();
    double appBarHeight = AppBar().preferredSize.height + 10;
    double screenPadding = MediaQuery.of(context).padding.top +
        MediaQuery.of(context).padding.bottom; //StatusBar + Navigation Buttons
    double textFieldTextHeight = _calculateTextHeight() * 2;
    double textFieldTotalPadding = 15.0 * 2 + 15.0 * 2;
    double heightBetweenBothTextFields = 20.0 + 8; //and bottom padding
    return screenHeight -
        (screenPadding +
            appBarHeight +
            textFieldTextHeight +
            textFieldTotalPadding +
            heightBetweenBothTextFields +
            _calculateTabsHeight());
  }

  double _screenHeight() => MediaQuery.of(context).size.height;
  ScrollController _controller = ScrollController();

  Widget tabsContent() {
    double height = _calculateHeight();
    double spacing = height > 400 ? ((height - 400) / 4) : 20;
    return (Container(
      color: Color.fromRGBO(247, 249, 252, 1),
      //height: height - 6,
      child: (activeTab == _TABS.NOMAD)
          ? Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 150,
                      child:
                          CustomScrollView(controller: _controller, slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 18.0, right: 18.0, top: 22),
                            child: IntroTextBoxWidget(
                              "Autopilot Reminder",
                              "If you have a successful autopilot reservation but decide not to confirm, you can cancel free of charge.",
                              "assets/svg/home/auto_pilot.svg",
                            ),
                          ),
                        ),
                      ])),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "Adult(s)",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Gilroy',
                                fontSize: 18,
                                color: kLabelTextColor),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            "Children",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Gilroy',
                                fontSize: 18,
                                color: kLabelTextColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    margin: EdgeInsets.only(bottom: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: ValueIncrementer(
                            stream: flyLinebloc.outAdults,
                            setter: flyLinebloc.setAdults,
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: ValueIncrementer(
                            stream: flyLinebloc.outChildren,
                            setter: flyLinebloc.setChildren,
                          ),
                        ),
                      ],
                    ),
                  ),
                  getSearchButton(),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 20, top: spacing),
                      child: Text(
                        "Trip Date(s)",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Gilroy',
                            fontSize: 18,
                            color: kLabelTextColor),
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: InkWell(
                              child: Container(
                                padding: const EdgeInsets.all(15.0),
                                margin: const EdgeInsets.only(right: 5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color: (_isBothSelected)
                                            ? Colors.white
                                            : Colors.red),
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        departureDate != null
                                            ? DateFormat("MM-dd-yyyy").format(
                                                DateTime.parse(departureDate))
                                            : "Departure Date",
                                        style: departureDate != null
                                            ? TextStyle(
                                                fontStyle: FontStyle.normal,
                                                fontFamily: 'Gilroy',
                                                color: Color(0xFF333333),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              )
                                            : TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "Gilroy",
                                                color: Color(0xffBBC4DC),
                                              ),
                                      ),
                                    ),
                                    Container(height: 23)
                                  ],
                                ),
                              ),
                              onTap: () async {
                                if (selectedArrival != null &&
                                    selectedDeparture != null) {
                                  DateResult newDateTime = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => DatePickerScreen(
                                          shouldChooseMultipleDates:
                                              activeTab == _TABS.ROUND_TRIP,
                                          departurePlace:
                                              selectedDeparture ?? null,
                                          arrivalPlace: selectedArrival ?? null,
                                          departure: departureDate == null
                                              ? DateTime.now()
                                              : DateTime.parse(departureDate),
                                          arrival: arrivalDate == null
                                              ? DateTime.now()
                                              : DateTime.parse(arrivalDate),
                                          selected: arrivalDate == null
                                              ? false
                                              : true,
                                          showMonth: departureDate == null
                                              ? DateTime.now().month
                                              : DateTime.parse(departureDate)
                                                  .month,
                                          adults: flyLinebloc.outAdults.value,
                                          children:
                                              flyLinebloc.outChildren.value,
                                        ),
                                      ));

                                  if (newDateTime == null) return;
                                  setState(() {
                                    departureDate =
                                        newDateTime.departureDate.toString();
                                    if (activeTab == _TABS.ROUND_TRIP &&
                                        newDateTime.returnDate != null)
                                      arrivalDate =
                                          newDateTime.returnDate.toString();
                                  });
                                } else {
                                  setState(() {
                                    if (selectedDeparture != null &&
                                        selectedArrival != null) {
                                      _isBothSelected = true;
                                    } else {
                                      _isBothSelected = false;
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                          activeTab == _TABS.ONE_WAY
                              ? Container()
                              : Expanded(
                                  child: InkWell(
                                    child: Container(
                                      padding: const EdgeInsets.all(15.0),
                                      margin: const EdgeInsets.only(left: 5),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: (_isBothSelected)
                                                  ? Colors.white
                                                  : Colors.red),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.white),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            child: Text(
                                              arrivalDate != null
                                                  ? DateFormat("MM-dd-yyyy")
                                                      .format(DateTime.parse(
                                                          arrivalDate
                                                              .toString()))
                                                  : "Return Date",
                                              style: arrivalDate != null
                                                  ? TextStyle(
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontFamily: 'Gilroy',
                                                      color: Color(0xFF333333),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    )
                                                  : TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: "Gilroy",
                                                      color: Color(0xffBBC4DC),
                                                    ),
                                            ),
                                          ),
                                          Container(
                                            height: 23,
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () async {
                                      if (selectedArrival != null &&
                                          selectedDeparture != null) {
                                        DateResult newDateTime =
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      DatePickerScreen(
                                                    shouldChooseMultipleDates:
                                                        activeTab ==
                                                            _TABS.ROUND_TRIP,
                                                  ),
                                                ));
                                        if (newDateTime == null) return;
                                        setState(() {
                                          departureDate = newDateTime
                                              .departureDate
                                              .toString();
                                          if (activeTab == _TABS.ROUND_TRIP &&
                                              newDateTime.returnDate != null)
                                            arrivalDate = newDateTime.returnDate
                                                .toString();
                                        });
                                      } else {
                                        setState(() {
                                          if (selectedDeparture != null &&
                                              selectedArrival != null) {
                                            _isBothSelected = true;
                                          } else {
                                            _isBothSelected = false;
                                          }
                                        });
                                      }
                                    },
                                  ),
                                ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: spacing, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              "Adult(s)",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Gilroy',
                                  fontSize: 18,
                                  color: kLabelTextColor),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Children",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Gilroy',
                                  fontSize: 18,
                                  color: kLabelTextColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: ValueIncrementer(
                              stream: flyLinebloc.outAdults,
                              setter: flyLinebloc.setAdults,
                            ),
                          ),
                          Expanded(
                            child: ValueIncrementer(
                              stream: flyLinebloc.outChildren,
                              setter: flyLinebloc.setChildren,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: spacing, bottom: 20),
                      child: Text(
                        "Cabin Class",
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: kLabelTextColor,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Color(0xffffff),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  cabin = "economy";
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: cabin == "economy"
                                        ? Colors.white
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        bottomLeft: Radius.circular(15))),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 18),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              color: Color.fromRGBO(
                                                  247, 249, 252, 1),
                                              width: 1.2))),
                                  child: Center(
                                    child: Text(
                                      "Economy",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Gilroy',
                                          fontSize: 14,
                                          color: cabin == "economy"
                                              ? Color(0xff0E3178)
                                              : Color(0xffBBC4DC)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  cabin = "business";
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: cabin == "business"
                                      ? Colors.white
                                      : Colors.transparent,
                                ),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 18),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              color: Color.fromRGBO(
                                                  247, 249, 252, 1),
                                              width: 1.2))),
                                  child: Center(
                                    child: Text(
                                      "Business",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Gilroy',
                                          fontSize: 14,
                                          color: cabin == "business"
                                              ? Color(0xff0E3178)
                                              : Color(0xffBBC4DC)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  cabin = "fClass";
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: cabin == "fClass"
                                        ? Colors.white
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(15),
                                        bottomRight: Radius.circular(15))),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 18),
                                  child: Center(
                                    child: Text(
                                      "First Class",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Gilroy Bold',
                                          fontSize: 14,
                                          color: cabin == "fClass"
                                              ? Color(0xff0E3178)
                                              : Color(0xffBBC4DC)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: spacing * 1.5,
                    ),
                    getSearchButton(),
                  ],
                ),
              ),
            ),
    ));
  }

  Widget getSearchButton() {
    final currency =
        Provider.of<SettingsBloc>(context, listen: true).selectedCurrency;
      List<String> sortValues = [SortOptions.soonest];
    return Container(
      margin: EdgeInsets.only(left: 16.0, right: 16, top: 10, bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Color(0xff00AEEF),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            child: Text(
              (activeTab == _TABS.NOMAD)
                  ? "Set Reservation Preferences"
                  : "Search Flights",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Gilroy',
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            onPressed: (activeTab == _TABS.NOMAD)
                ? () {
                    if (selectedDeparture == null || selectedArrival == null)
                      return;

                    flyLinebloc.setDepartureLocation(selectedDeparture);
                    flyLinebloc.setArrivalLocation(selectedArrival);

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ReservationsDetailsWrapper()));
                  }
                : () {

              if (selectedDeparture == null) {
                _showSnackBar("Select Departure City or Airport", context);
                return;
              } else if (selectedArrival == null) {
                _showSnackBar("Select Arrival City or Airport", context);
                return;
              }  else if (departureDate == null) {
                _showSnackBar("Select Departure Date", context);
                return;
              } else if ((isRoundTrip && arrivalDate == null)) {
                _showSnackBar("Select Return Date", context);
                return;
              }
                    if (selectedDeparture != null &&
                        selectedArrival != null &&
                        departureDate != null &&
                        (!isRoundTrip || arrivalDate != null)) {
                      flyLinebloc.loadingOverlay.show(context);
                      setState(() {
                        offset = 0;
                        originalFlights = List();
                        listOfFlights = List();
                        _isLoading = true;
                        listOfFlights.add(null);
                        _displayLoadMore = false;
                      });

                      try {
                        flyLinebloc
                            .searchFlight(
                              selectedDeparture.type +
                                  ":" +
                                  selectedDeparture.code,
                              selectedArrival.type + ":" + selectedArrival.code,
                              DateTime.parse(departureDate),
                              DateTime.parse(departureDate),
                              isRoundTrip ? "round" : "oneway",
                              isRoundTrip ? DateTime.parse(arrivalDate) : null,
                              isRoundTrip ? DateTime.parse(arrivalDate) : null,
                              flyLinebloc.outAdults.value,
                              "0",
                              "0",
                              selectedClassOfServiceValue,
                              "USD",
                              this.offset.toString(),
                              this.perPage.toString(),
                            )
                            .then((_) => setState(() {
                                  flyLinebloc.loadingOverlay.hide();
                                }));
                      } catch (e) {
                        setState(() {
                          flyLinebloc.loadingOverlay.hide();
                        });
                      }
                    }

                    // Navigator.of(context).push(MaterialPageRoute(
                    //   builder: (BuildContext context) => SearchSelector(
                    //     flyingFrom: selectedDeparture.code,
                    //     flyingTo: selectedArrival.code,
                    //     departureDate: DateTime.parse(departureDate),
                    //     arrivalDate:
                    //         isRoundTrip ? DateTime.parse(arrivalDate) : null,
                    //     isRoundTrip: isRoundTrip ? true : false,
                    //   ),
                    // ));

                    // final SearchFlightObject searchFlightObject = SearchFlightObject(
                    //   selectedDeparture.type +
                    //               ":" +
                    //               selectedDeparture.code,
                    //           selectedArrival.type + ":" + selectedArrival.code,
                    //           DateTime.parse(departureDate),
                    //           DateTime.parse(departureDate),
                    //           isRoundTrip ? "round" : "oneway",
                    //           isRoundTrip ? DateTime.parse(arrivalDate) : null,
                    //           isRoundTrip ? DateTime.parse(arrivalDate) : null,
                    //           flyLinebloc.outAdults.value,
                    //           0,
                    //           0,
                    //           selectedClassOfServiceValue,
                    //           "USD",
                    //           this.offset.toString(),
                    //           this.perPage.toString(),
                    // );
                    
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) {
                        return SearchResults(
                          type: SearchType.META,
                          flyingFrom: selectedDeparture.code,
                          flyingTo: selectedArrival.code,
                          depDate: departureDate,
                          arrDate: isRoundTrip
                            ? arrivalDate
                            : null,
                          isRoundTrip: isRoundTrip,
                          // flightsStream: Rx.combineLatest3<
                          //   List<FlightInformationObject>,
                          //   List<FlightInformationObject>,
                          //   List<FlightInformationObject>,
                          //   List<FlightInformationObject>>(
                          //     flyLinebloc.flightsMetaItems(
                          //       currency, sortValues, isRoundTrip),
                          //     flyLinebloc.flightsExclusiveItems(
                          //       currency, sortValues, isRoundTrip),
                          //     flyLinebloc.flightsFareItems(
                          //       currency, sortValues, isRoundTrip),
                          //     (a, b, c) => a + b + c,
                          //   ).asBroadcastStream(),
                          );
                      },
                    ));
                    context.read<SearchProvider>().setFlightsStream(Rx.combineLatest3<
                            List<FlightInformationObject>,
                            List<FlightInformationObject>,
                            List<FlightInformationObject>,
                            List<FlightInformationObject>>(
                              flyLinebloc.flightsMetaItems(
                                currency, sortValues, isRoundTrip),
                              flyLinebloc.flightsExclusiveItems(
                                currency, sortValues, isRoundTrip),
                              flyLinebloc.flightsFareItems(
                                currency, sortValues, isRoundTrip),
                              (a, b, c) => a + b + c,
                            ).asBroadcastStream());
                  },
          ),
        ],
      ),
    );
  }

  TextEditingController tcontroller = TextEditingController();
  TextEditingController tcontroller2 = TextEditingController();

  Widget buildSelectDepartureField({bool isWeb = false}) {
    return Focus(
                            child: LocationSearchUI(
                              controller: tcontroller,
                              hintText: "Select Departure City or Airport",
                              isWeb: isWeb,
                              style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontFamily: 'Gilroy',
                                color: Color(0xFF333333),
                                fontSize: isWeb ? 10 : 16,
                                fontWeight: FontWeight.w500,
                              ),
                              onClear: (controller) {
                                setState(() {
//                                  controller.text = "";
                                });
                              },
                              onChange: (value) {
                                setState(() {
                                  selectedDeparture = value;
                                  Provider.of<DataHelper>(context)
                                      .selectDepartureLocation(value);
                                  if (selectedDeparture != null &&
                                      selectedArrival != null) {
                                    _isBothSelected = true;
                                  }
                                });
                              },
                            ),
                            onFocusChange: (isFocus) {
                              _slideSearchTransitionController.reverse();
                              if (isIntroModeOn && isFocus) {
                                changeIntroMode(false);
                              }
                            },
                          );
  }

  Widget buildSelectArrivalField({bool isWeb = false}) {
    return Focus(
                        focusNode: navi,
                        child: LocationSearchUI(
                          controller: tcontroller2,
                          onClear: (controller) {
                            setState(() {
//                                  tcontroller2.text = "";
                            });
                          },
                          isWeb: isWeb,
                          style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontFamily: 'Gilroy',
                                color: Color(0xFF333333),
                                fontSize: isWeb ? 10 : 16,
                                fontWeight: FontWeight.w500,
                              ),
                          hintText: "Select Arrival City or Airport",
                          onChange: (value) => setState(() {
                            selectedArrival = value;

                            Provider.of<DataHelper>(context)
                                .selectArrivalLocation(value);
                            if (selectedDeparture != null &&
                                selectedArrival != null) {
                              setState(() {
                                _isBothSelected = true;
                              });
                            }
                          }),
                        ),
                        onFocusChange: (isFocus) {
                          _slideSearchTransitionController.reverse();
                          if (isIntroModeOn && isFocus) {
                            changeIntroMode(false);
                          }
                        },
                      );
  }

  Widget selectJourney() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
      ),
      padding: EdgeInsets.only(left: 8, right: 8, top: 15, bottom: 12),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Stack(
                        children: <Widget>[
                          buildSelectDepartureField(),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 20,
                      ),
                      child: buildSelectArrivalField(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 8)),
          ExpandedSection(
            expand: !isIntroModeOn,
            child: tabsHeader(),
            duration: Duration(milliseconds: 600),
          ),
        ],
      ),
    );
  }


  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          left: 8,
          right: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Spacer(),
            Flexible(
              flex: 2,
              child: Container(
                color: Colors.white,
                height: AppBar().preferredSize.height + 10,
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/images/logotype.svg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                height: AppBar().preferredSize.height + 10,
                child: Material(
                  color: Colors.transparent,
                  child: isIntroModeOn
                      ? SizedBox.shrink()
                      : InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                          onTap: () => changeIntroMode(true),
                          child: Container(
                            height: 40,
                            width: 40,
                            child: Center(
                              child: SvgPicture.asset(
                                "assets/svg/home/cancel_grey.svg",
                                width: isIntroModeOn ? 20 : 15,
                                height: isIntroModeOn ? 20 : 15,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  FirebaseMessaging _messaging = FirebaseMessaging();

  generateFCMToken() {
    _messaging.getToken().then((token) async {
      print('printing FM token');
      print(token);
      fcmToken = token;

      if(fcmToken != null) {
        await flyLinebloc.tryFcmToken(token).then((value) {
          print("Api call success $value");
        });
      }

    });
  }

  //Push Notification
  void fireBaseCloudMessagingListeners() {
    if (Platform.isIOS) iOS_Permission();
    _messaging.getToken().then((token){
      print(token);
    });
    _messaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iOS_Permission() {

    _messaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true)
    );

    _messaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings)
    {
      print("Settings registered: $settings");
    });
  }


  @override
  void dispose() {
    // flyLinebloc.loadingOverlay.hide();
    _transitionController.dispose();
    super.dispose();
  }

  /// [showIntro] true will show intro mode and hide flight detail
  /// false will reverve the process
  void changeIntroMode(bool showIntro) {
    if (isIntroModeOn == showIntro) return;

    // hiding any open keyboard
    FocusScope.of(context).requestFocus(FocusNode());
    showIntro
        ? _transitionController.reverse()
        : _transitionController.forward();
    setState(() {
      isIntroModeOn = showIntro;
    });
  }
}

enum ButtonMarker { user, back }
