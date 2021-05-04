import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:motel/screens/sign_up/sign_up.dart';
import 'package:motel/screens/trips/completed_trips.dart';
import 'package:motel/screens/wallet/create_account.dart';
import 'package:motel/theme/appTheme.dart';
import 'package:motel/models/traveler_info.dart';
import 'package:motel/widgets/animatd_flat_btn_for_network_requests.dart';
import 'package:motel/screens/wallet/local_widgets/personal_information_label.dart';
import 'package:motel/blocs/bloc.dart';
import 'package:motel/widgets/list_loading.dart';
import 'package:motel/widgets/location_search_ui.dart';
import 'package:motel/widgets/no_data_page.dart';
import '../../models/locations.dart';
import '../../blocs/bloc.dart';
import '../../utils/date_utils.dart';

class PersonalInformation extends StatefulWidget {
  @override
  _PersonalInformationState createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  Future<TravelerInfo> _travelerInfo;
  bool _contentHasChanged = false;

  final _airportFieldKey = GlobalKey();

  final _firstNameController = TextEditingController();

  final _lastNameController = TextEditingController();

  final _birthController = TextEditingController();

  final _genderController = TextEditingController();

  final _airportController = TextEditingController();

  final _emailController = TextEditingController();

  final _phoneNumberController = TextEditingController();

  final _passportNumberController = TextEditingController();

  final _passportExpController = TextEditingController();

  final _globalEntryNumberController = TextEditingController();

  final _tsaPrecheckNumberController = TextEditingController();

  final TextStyle _inputTextStyle = const TextStyle(
    fontFamily: 'Gilroy',
    color: Color(0xff333333),
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  LocationObject _locationObject;

//  final FlyLineBloc flyLinebloc1 = FlyLineBloc();

  @override
  void initState() {
    super.initState();
    _travelerInfo = flyLinebloc.travelerInfo();
  }

  showSaveButton() {
    _contentHasChanged = true;
  }

  @override
  Widget build(BuildContext context) {
    void _checkIfContentHasChanged(TravelerInfo data) {
      if (_firstNameController.text != data.firstName ||
          _lastNameController.text != data.lastName ||
          _birthController.text != TravelerInfo.getDobString(data.dob) ||
          _genderController.text != TravelerInfo.getGenderString(data.gender) ||
          _emailController.text != data.email ||
          _passportNumberController.text != data.passportNumber ||
          _phoneNumberController.text != data.phoneNumber ||
          _passportNumberController.text != data.passportNumber ||
          _passportExpController.text != data.passportExpiration ||
          _globalEntryNumberController.text != data.globalEntryNumber ||
          _tsaPrecheckNumberController.text != data.tsaPrecheckNumber) {
        if (_contentHasChanged != true) {
          setState(() {
            _contentHasChanged = true;
          });
        }
      } else {
        print("_contentHasChanged");
        print(_contentHasChanged);
        setState(() {
          _contentHasChanged = false;
        });
      }
    }

    return isGustLogin == true  ? NoDataCreateAccountPage(
      title: "Simplify your booking",
      description: "Create your free FlyLine account to save your travel preferences and traveler details.",
        imageShow: "assets/images/on_boarding_mocs/guest_missing_traveler_details.png",
    ) : FutureBuilder<TravelerInfo>(
      future: _travelerInfo,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final data = snapshot.data;

          if (data != null) {
            if (!_contentHasChanged) {
              _firstNameController.text = data.firstName ?? '';
              _lastNameController.text = data.lastName ?? '';
              _birthController.text = TravelerInfo.getDobString(data.dob) ?? '';
              _genderController.text =
                  TravelerInfo.getGenderString(data.gender) ?? '';
              _airportController.text =
                  data.market != null ? data.market.name : "";
              _emailController.text = data.email ?? '';
              _phoneNumberController.text = data.phoneNumber ?? '';
              _passportNumberController.text = data.passportNumber ?? '';
              _passportExpController.text = data.passportExpiration ?? '';
              _globalEntryNumberController.text = data.globalEntryNumber ?? '';
              _tsaPrecheckNumberController.text = data.tsaPrecheckNumber ?? '';
            }
          }

          return Container(
            color: Color(0xFFF7F9FC),
            child: data == null
                ? ListLoading()
                : Stack(
                    children: <Widget>[
                      ListView(
                        padding: EdgeInsets.only(bottom: 100),
                        children: <Widget>[
                          PersonalInformationLabel(
                              label: 'Personal Information'),
                          Container(
                            padding: const EdgeInsets.only(
                                bottom: 12.0, left: 18, right: 18),
                            child: TextFormField(
                              maxLines: 1,
                              controller: _firstNameController,
                              onChanged: (val) =>
                                  _checkIfContentHasChanged(data),
                              keyboardType: TextInputType.text,
                              cursorColor: AppTheme.getTheme().primaryColor,
                              decoration: InputDecoration(
                                  hintText: "First Name",
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 20),
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Gilroy",
                                      color: Color(0xFFBBC4DC))),
                              style: _inputTextStyle,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                bottom: 12.0, left: 18, right: 18),
                            child: TextFormField(
                              maxLines: 1,
                              controller: _lastNameController,
                              onChanged: (val) =>
                                  _checkIfContentHasChanged(data),
                              keyboardType: TextInputType.text,
                              cursorColor: AppTheme.getTheme().primaryColor,
                              decoration: InputDecoration(
                                  hintText: "Last Name",
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 20),
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Gilroy",
                                      color: Color(0xFFBBC4DC))),
                              style: _inputTextStyle,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                bottom: 12.0, left: 18, right: 18),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () => showModalBottomSheet(
                                      context: context,
                                      builder: (context) => Container(
                                        height: 200,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 30, horizontal: 20),
                                        child: CupertinoDatePicker(
                                          onDateTimeChanged: (date) {
                                            _birthController.text =
                                                DateFormat('MM/dd/yyyy')
                                                    .format(date);
                                            _checkIfContentHasChanged(data);
                                          },
                                          initialDateTime: _birthController
                                                          .text ==
                                                      '' ||
                                                  _birthController.text == null
                                              ? DateTime.now()
                                              : DateTime.parse(
                                                  '${_birthController.text.split('/')[2]}-${_birthController.text.split('/')[0]}-${_birthController.text.split('/')[1]}'),
                                          mode: CupertinoDatePickerMode.date,
                                        ),
                                      ),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(0),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      child: IgnorePointer(
                                        child: TextFormField(
                                          maxLines: 1,
                                          controller: _birthController,
                                          keyboardType: TextInputType.text,
                                          cursorColor:
                                              AppTheme.getTheme().primaryColor,
                                          decoration: InputDecoration(
                                              hintText: "Date of Birth",
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 20,
                                                      horizontal: 20),
                                              hintStyle: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "Gilroy",
                                                  color: Color(0xFFBBC4DC))),
                                          style: _inputTextStyle,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: GenderPicker(
                                    genderTxtEditingController:
                                        _genderController,
                                    textStyle: _inputTextStyle,
                                    data: data,
                                    helperFunction: _checkIfContentHasChanged,
                                    showSaveButton: showSaveButton,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 18),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Focus(
                              onFocusChange: (value) =>
                                  Scrollable.ensureVisible(
                                      _airportFieldKey.currentContext),
                              child: LocationSearchUI(
                                fillColor: Colors.white,
                                key: _airportFieldKey,
                                controller: _airportController,
                                hintText: 'Home Airport',
                                style: _inputTextStyle,
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Gilroy",
                                    color: Color(0xFFBBC4DC)),
                                backgroundColor: Colors.white,
                                onChange: (location) {
                                  print("object");
                                  _locationObject = location;
                                  setState(() {
                                    _contentHasChanged = true;
                                  });
                                },
                              ),
                            ),
                          ),
                          PersonalInformationLabel(
                              label: 'Contact Information'),
                          Container(
                            padding: const EdgeInsets.only(
                                bottom: 12.0, left: 18, right: 18),
                            child: TextFormField(
                              maxLines: 1,
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (val) =>
                                  _checkIfContentHasChanged(data),
                              cursorColor: AppTheme.getTheme().primaryColor,
                              decoration: InputDecoration(
                                  hintText: 'Email Address',
                                  contentPadding: EdgeInsets.all(20),
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Gilroy",
                                      color: Color(0xFFBBC4DC))),
                              style: _inputTextStyle,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                bottom: 12.0, left: 18, right: 18),
                            child: TextFormField(
                              maxLines: 1,
                              controller: _phoneNumberController,
                              keyboardType: TextInputType.text,
                              onChanged: (val) =>
                                  _checkIfContentHasChanged(data),
                              cursorColor: AppTheme.getTheme().primaryColor,
                              decoration: InputDecoration(
                                  hintText: "Phone Number",
                                  contentPadding: EdgeInsets.all(20),
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Gilroy",
                                      color: Color(0xFFBBC4DC))),
                              style: _inputTextStyle,
                            ),
                          ),
                          PersonalInformationLabel(
                              label: 'Day of Travel Information'),
                          Container(
                            padding: const EdgeInsets.only(
                                bottom: 12.0, left: 18, right: 18),
                            child: TextFormField(
                              maxLines: 1,
                              controller: _passportNumberController,
                              keyboardType: TextInputType.text,
                              onChanged: (val) =>
                                  _checkIfContentHasChanged(data),
                              cursorColor: AppTheme.getTheme().primaryColor,
                              decoration: InputDecoration(
                                  hintText: "Passport ID",
                                  contentPadding: EdgeInsets.all(20),
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Gilroy",
                                      color: Color(0xFFBBC4DC))),
                              style: _inputTextStyle,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                bottom: 12.0, left: 18, right: 18),
                            child: TextFormField(
                              maxLines: 1,
                              controller: _passportExpController,
                              keyboardType: TextInputType.text,
                              onChanged: (val) =>
                                  _checkIfContentHasChanged(data),
                              cursorColor: AppTheme.getTheme().primaryColor,
                              decoration: InputDecoration(
                                  hintText: "Passport Exp",
                                  contentPadding: EdgeInsets.all(20),
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Gilroy",
                                      color: Color(0xFFBBC4DC))),
                              style: _inputTextStyle,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                bottom: 12.0, left: 18, right: 18),
                            child: TextFormField(
                              maxLines: 1,
                              controller: _globalEntryNumberController,
                              keyboardType: TextInputType.text,
                              onChanged: (val) =>
                                  _checkIfContentHasChanged(data),
                              cursorColor: AppTheme.getTheme().primaryColor,
                              decoration: InputDecoration(
                                  hintText: "Global Entry Number",
                                  contentPadding: EdgeInsets.all(20),
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Gilroy",
                                      color: Color(0xFFBBC4DC))),
                              style: _inputTextStyle,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                bottom: 12.0, left: 18, right: 18),
                            margin: const EdgeInsets.only(bottom: 50),
                            child: TextFormField(
                              maxLines: 1,
                              controller: _tsaPrecheckNumberController,
                              keyboardType: TextInputType.text,
                              onChanged: (val) =>
                                  _checkIfContentHasChanged(data),
                              cursorColor: AppTheme.getTheme().primaryColor,
                              decoration: InputDecoration(
                                  hintText: "TSA Pre-Check Number",
                                  contentPadding: EdgeInsets.all(20),
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Gilroy",
                                      color: Color(0xFFBBC4DC))),
                              style: _inputTextStyle,
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: -5,
                        left: 0,
                        right: 0,
                        height: 100,
                        child: AnimatedOpacity(
                          opacity: _contentHasChanged ? 1.0 : 0.0,
//                    onEnd:,
                          duration: Duration(milliseconds: 300),
                          child: Material(
                            color: Colors.white,
                            elevation: 10,
                            child: Center(
                              child: AnimatedFlatButtonForNetworkRequest(
                                btnTxt: 'Save Information',
                                networkRequest: _updateAccountInfo,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        }
        return ListLoading();
      },
    );
  }

  Future<bool> _updateAccountInfo() async {
    if (_contentHasChanged) {
      await flyLinebloc.updateAccountInfo(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          dob: _birthController.text.isEmpty
              ? ""
              : DateUtils.formatDate(_birthController.text),
          gender: _genderController.text,
          email: _emailController.text,
          locationObject:
              _locationObject != null ? _locationObject.toJson() : "",
          globalEntryNumber: _globalEntryNumberController.text,
          passport: _passportNumberController.text,
          passportExpiry: _passportExpController.text,
          phone: _phoneNumberController.text,
          preCheckNumber: _tsaPrecheckNumberController.text);
      return false;
    }
    return true;
  }
}

class GenderPicker extends StatefulWidget {
  final TextEditingController genderTxtEditingController;
  final TextStyle textStyle;
  final TravelerInfo data;
  final Function helperFunction;
  final Function showSaveButton;

  GenderPicker(
      {Key key,
      this.genderTxtEditingController,
      this.textStyle,
      this.data,
      this.helperFunction,
      this.showSaveButton})
      : super(key: key);

  @override
  _GenderPickerState createState() => _GenderPickerState();
}

class _GenderPickerState extends State<GenderPicker> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          height: 200,
          child: CupertinoPicker(
            onSelectedItemChanged: (value) {
              widget.genderTxtEditingController.text =
                  TravelerInfo.getGenderString(value);
              widget.helperFunction(widget.data);
              widget.showSaveButton();
              setState(() {});
            },
            children: <Widget>[
              Text('Male'),
              Text(
                'Female',
                style: TextStyle(),
              ),
            ],
            itemExtent: 30,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: IgnorePointer(
          child: TextFormField(
            maxLines: 1,
            controller: widget.genderTxtEditingController,
            keyboardType: TextInputType.text,
            cursorColor: AppTheme.getTheme().primaryColor,
            decoration: InputDecoration(
                hintText: "Gender",
                contentPadding:
                    EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                hintStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: "Gilroy",
                    color: Color(0xFFBBC4DC))),
            style: widget.textStyle,
          ),
        ),
      ),
    );
  }
}
