import 'dart:convert';

class BookedFlight {
  num id;
  String bookingId;
  String email;
  String phone;
  String provider;
  String confirmationNumber;
  BookedFlightData data;
  num user;
  List<Flight> flights;

  BookedFlight({
    this.id,
    this.bookingId,
    this.email,
    this.phone,
    this.provider,
    this.data,
    this.confirmationNumber,
    this.user,
    this.flights,
  });

  factory BookedFlight.fromRawJson(String str) =>
      BookedFlight.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BookedFlight.fromJson(Map<String, dynamic> json) => BookedFlight(
        id: json["id"] == null ? null : json["id"],
        bookingId: json["booking_id"] == null ? null : json["booking_id"],
        email: json["email"] == null ? null : json["email"],
    provider: json["provider"] == null ? null : json["provider"],
    confirmationNumber: json["confirmation_number"] == null ? null : json["confirmation_number"],
        phone: json["phone"] == null ? null : json["phone"],
        data: json["data"] == null
            ? null
            : BookedFlightData.fromJson(json["data"]),
        user: json["user"] == null ? null : json["user"],
        flights: json["flights"] == null
            ? null
            : List<Flight>.from(json["flights"].map((x) => Flight.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "booking_id": bookingId == null ? null : bookingId,
        "confirmation_number": confirmationNumber == null ? null : confirmationNumber,
        "email": email == null ? null : email,
        "phone": phone == null ? null : phone,
        "provider": provider == null ? null : provider,
        "data": data == null ? null : data.toJson(),
        "user": user == null ? null : user,
        "flights": flights == null
            ? null
            : List<dynamic>.from(flights.map((x) => x.toJson())),
      };
}

class BookedFlightData {
  //String id;
  //Fare fare;
  //num pnum;
  String flyTo;
  num price;
  //List<String> route;
  //dynamic state;
  //String flightNo;
  //num total;
  String cityTo;
  //List<List<String>> routes;
  //num spFee;
  //String status;
  //List<Baggage> baggage;
  //dynamic country;
  String flyFrom;
  //num quality;
  //bool sandbox;
  //num srIndex;
  //List<String> airlines;
  //Baglimit baglimit;
//  num bagsFee;
//  num bookFee;
  String cityFrom;
  //num distance;
  FlightDuration duration;
//  Country countryTo;
//  num extraFee;
//  num pnrCount;
//  Promocode promocode;
  bool roundtrip;
//  List<dynamic> transfers;
//  String authToken;
//  Map<String, num> bagsPrice;
//  String cityCodeTo;
//  Conversion conversion;
//  num origPrice;
  List<Passenger> passengers;
//  String payuToken;
//  Country countryFrom;
//  num feeAirline;
//  num serverTime;
//  DateTime utcArrival;
//  num adultsPrice;
//  Availability availability;
//  String cityCodeFrom;
//  num nightsInDest;
//  PaymentInfo paymentInfo;
//  bool priceChange;
//  List<String> typeFlights;
//  String bookingToken;
//  num creditsPrice;
//  dynamic customMarkup;
//  num flightsPrice;
//  num infantsPrice;
  DateTime localArrival;
//  num onePassenger;
//  num ticketsPrice;
//  DateTime utcDeparture;
//  num childrenPrice;
//  InsuranceData insuranceData;
//  num maxPassengers;
//  PriceDropdown priceDropdown;
//  DateTime returnArrival;
//  bool transactionId;
//  bool flightsChecked;
//  bool flightsInvalid;
//  InsurancePrice insurancePrice;
  DateTime localDeparture;
//  String paymentGateway;
//  String payuPublicKey;
//  num technicalStops;
//  DocumentOptions documentOptions;
//  bool flightsToCheck;
//  bool origPriceUsage;
  DateTime returnDeparture;
//  AncillariesOrder ancillariesOrder;
//  num eurPaymentPrice;
//  num flightRealPrice;
//  num localArrivalInt;
//  bool hasAirportChange;
//  InfantsConditions infantsConditions;
//  num returnArrivalInt;
//  num localDepartureInt;
//  bool virtualInterlining;
//  bool flightsRealChecked;
//  num returnDepartureInt;
//  bool visasAgreementRequiered;
//  bool facilitatedBookingAvailable;

  BookedFlightData({
//    this.id,
//    this.fare,
//    this.pnum,
    this.flyTo,
    this.price,
//    this.route,
//    this.state,
//    this.total,
    this.cityTo,
//    this.routes,
//    this.spFee,
//    this.status,
//    this.baggage,
//    this.country,
    this.flyFrom,
//    this.quality,
//    this.sandbox,
//    this.srIndex,
//    this.airlines,
//    this.baglimit,
//    this.bagsFee,
//    this.bookFee,
    this.cityFrom,
//    this.distance,
    this.duration,
//    this.countryTo,
//    this.extraFee,
//    this.pnrCount,
//    this.promocode,
    this.roundtrip,
//    this.transfers,
//    this.authToken,
//    this.bagsPrice,
//    this.cityCodeTo,
//    this.conversion,
//    this.origPrice,
    this.passengers,
//    this.payuToken,
//    this.countryFrom,
//    this.feeAirline,
//    this.serverTime,
//    this.utcArrival,
//    this.adultsPrice,
//    this.availability,
//    this.cityCodeFrom,
//    this.nightsInDest,
//    this.paymentInfo,
//    this.priceChange,
//    this.typeFlights,
//    this.bookingToken,
//    this.creditsPrice,
//    this.customMarkup,
//    this.flightsPrice,
//    this.infantsPrice,
    this.localArrival,
//    this.onePassenger,
//    this.ticketsPrice,
//    this.utcDeparture,
//    this.childrenPrice,
//    this.insuranceData,
//    this.maxPassengers,
//    this.priceDropdown,
//    this.returnArrival,
//    this.transactionId,
//    this.flightsChecked,
//    this.flightsInvalid,
//    this.insurancePrice,
    this.localDeparture,
//    this.paymentGateway,
//    this.payuPublicKey,
//    this.technicalStops,
//    this.documentOptions,
//    this.flightsToCheck,
//    this.origPriceUsage,
    this.returnDeparture,
//    this.ancillariesOrder,
//    this.flightNo,
//    this.eurPaymentPrice,
//    this.flightRealPrice,
//    this.localArrivalInt,
//    this.hasAirportChange,
//    this.infantsConditions,
//    this.returnArrivalInt,
//    this.localDepartureInt,
//    this.virtualInterlining,
//    this.flightsRealChecked,
//    this.returnDepartureInt,
//    this.visasAgreementRequiered,
//    this.facilitatedBookingAvailable,
  });

  factory BookedFlightData.fromRawJson(String str) =>
      BookedFlightData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BookedFlightData.fromJson(Map<String, dynamic> json) =>
      BookedFlightData(
//        id: json["id"] == null ? null : json["id"],
//        fare: json["fare"] == null ? null : Fare.fromJson(json["fare"]),
//        pnum: json["pnum"] == null ? null : json["pnum"],
        flyTo: json["flyTo"] == null ? null : json["flyTo"],
        price: json["price"] == null ? null : json["price"],
//        route: json["route"] == null
//            ? null
//            : List<String>.from(json["route"].map((x) => x)),
//        state: json["state"],
//        flightNo: json["flight_no"] == null ? '' : json["flight_no"],
//        total: json["total"] == null ? null : json["total"].toDouble(),
        cityTo: json["cityTo"] == null ? null : json["cityTo"],
//        routes: json["routes"] == null
//            ? null
//            : List<List<String>>.from(
//                json["routes"].map((x) => List<String>.from(x.map((x) => x)))),
//        spFee: json["sp_fee"] == null ? null : json["sp_fee"].toDouble(),
//        status: json["status"] == null ? null : json["status"],
//        baggage: json["baggage"] == null
//            ? null
//            : List<Baggage>.from(
//                json["baggage"].map((x) => Baggage.fromJson(x))),
//        country: json["country"],
        flyFrom: json["flyFrom"] == null ? null : json["flyFrom"],
//        quality: json["quality"] == null ? null : json["quality"].toDouble(),
//        sandbox: json["sandbox"] == null ? null : json["sandbox"],
//        srIndex: json["srIndex"] == null ? null : json["srIndex"],
//        airlines: json["airlines"] == null
//            ? null
//            : List<String>.from(json["airlines"].map((x) => x)),
//        baglimit: json["baglimit"] == null
//            ? null
//            : Baglimit.fromJson(json["baglimit"]),
//        bagsFee: json["bags_fee"] == null ? null : json["bags_fee"],
//        bookFee: json["book_fee"] == null ? null : json["book_fee"],
        cityFrom: json["cityFrom"] == null ? null : json["cityFrom"],
//        distance: json["distance"] == null ? null : json["distance"].toDouble(),
        duration: json["duration"] == null
            ? null
            : FlightDuration.fromJson(json["duration"]),
//        countryTo: json["countryTo"] == null
//            ? null
//            : Country.fromJson(json["countryTo"]),
//        extraFee: json["extra_fee"] == null ? null : json["extra_fee"],
//        pnrCount: json["pnr_count"] == null ? null : json["pnr_count"],
//        promocode: json["promocode"] == null
//            ? null
//            : Promocode.fromJson(json["promocode"]),
        roundtrip: json["roundtrip"] == null ? null : json["roundtrip"],
//        transfers: json["transfers"] == null
//            ? null
//            : List<dynamic>.from(json["transfers"].map((x) => x)),
//        authToken: json["auth_token"] == null ? null : json["auth_token"],
//        bagsPrice: json["bags_price"] == null
//            ? null
//            : Map.from(json["bags_price"])
//                .map((k, v) => MapEntry<String, num>(k, v.toDouble())),
//        cityCodeTo: json["cityCodeTo"] == null ? null : json["cityCodeTo"],
//        conversion: json["conversion"] == null
//            ? null
//            : Conversion.fromJson(json["conversion"]),
//        origPrice:
//            json["orig_price"] == null ? null : json["orig_price"].toDouble(),
        passengers: json["passengers"] == null
            ? null
            : List<Passenger>.from(
                json["passengers"].map((x) => Passenger.fromJson(x))),
//        payuToken: json["payu_token"] == null ? null : json["payu_token"],
//        countryFrom: json["countryFrom"] == null
//            ? null
//            : Country.fromJson(json["countryFrom"]),
//        feeAirline: json["fee_airline"] == null ? null : json["fee_airline"],
//        serverTime: json["server_time"] == null ? null : json["server_time"],
//        utcArrival: json["utc_arrival"] == null
//            ? null
//            : DateTime.parse(json["utc_arrival"]),
//        adultsPrice: json["adults_price"] == null
//            ? null
//            : json["adults_price"].toDouble(),
//        availability: json["availability"] == null
//            ? null
//            : Availability.fromJson(json["availability"]),
//        cityCodeFrom:
//            json["cityCodeFrom"] == null ? null : json["cityCodeFrom"],
//        nightsInDest:
//            json["nightsInDest"] == null ? null : json["nightsInDest"],
//        paymentInfo: json["payment_info"] == null
//            ? null
//            : PaymentInfo.fromJson(json["payment_info"]),
//        priceChange: json["price_change"] == null ? null : json["price_change"],
//        typeFlights: json["type_flights"] == null
//            ? null
//            : List<String>.from(json["type_flights"].map((x) => x)),
//        bookingToken:
//            json["booking_token"] == null ? null : json["booking_token"],
//        creditsPrice: json["credits_price"] == null
//            ? null
//            : json["credits_price"].toDouble(),
//        customMarkup: json["custom_markup"],
//        flightsPrice: json["flights_price"] == null
//            ? null
//            : json["flights_price"].toDouble(),
//        infantsPrice:
//            json["infants_price"] == null ? null : json["infants_price"],
        localArrival: json["local_arrival"] == null
            ? null
            : DateTime.parse(json["local_arrival"]),
//        onePassenger: json["one_passenger"] == null
//            ? null
//            : json["one_passenger"].toDouble(),
//        ticketsPrice: json["tickets_price"] == null
//            ? null
//            : json["tickets_price"].toDouble(),
//        utcDeparture: json["utc_departure"] == null
//            ? null
//            : DateTime.parse(json["utc_departure"]),
//        childrenPrice:
//            json["children_price"] == null ? null : json["children_price"],
//        insuranceData: json["insurance_data"] == null
//            ? null
//            : InsuranceData.fromJson(json["insurance_data"]),
//        maxPassengers:
//            json["max_passengers"] == null ? null : json["max_passengers"],
//        priceDropdown: json["price_dropdown"] == null
//            ? null
//            : PriceDropdown.fromJson(json["price_dropdown"]),
//        returnArrival: json["return_arrival"] == null
//            ? null
//            : DateTime.parse(json["return_arrival"]),
//        transactionId:
//            json["transaction_id"] == null ? null : json["transaction_id"],
//        flightsChecked:
//            json["flights_checked"] == null ? null : json["flights_checked"],
//        flightsInvalid:
//            json["flights_invalid"] == null ? null : json["flights_invalid"],
//        insurancePrice: json["insurance_price"] == null
//            ? null
//            : InsurancePrice.fromJson(json["insurance_price"]),
        localDeparture: json["local_departure"] == null
            ? null
            : DateTime.parse(json["local_departure"]),
//        paymentGateway:
//            json["payment_gateway"] == null ? null : json["payment_gateway"],
//        payuPublicKey:
//            json["payu_public_key"] == null ? null : json["payu_public_key"],
//        technicalStops:
//            json["technical_stops"] == null ? null : json["technical_stops"],
//        documentOptions: json["document_options"] == null
//            ? null
//            : DocumentOptions.fromJson(json["document_options"]),
//        flightsToCheck:
//            json["flights_to_check"] == null ? null : json["flights_to_check"],
//        origPriceUsage:
//            json["orig_price_usage"] == null ? null : json["orig_price_usage"],
        returnDeparture: json["return_departure"] == null
            ? null
            : DateTime.parse(json["return_departure"]),
//        ancillariesOrder: json["ancillaries_order"] == null
//            ? null
//            : AncillariesOrder.fromJson(json["ancillaries_order"]),
//        eurPaymentPrice: json["eur_payment_price"] == null
//            ? null
//            : json["eur_payment_price"].toDouble(),
//        flightRealPrice: json["flight_real_price"] == null
//            ? null
//            : json["flight_real_price"].toDouble(),
//        localArrivalInt: json["local_arrival_int"] == null
//            ? null
//            : json["local_arrival_int"],
//        hasAirportChange: json["has_airport_change"] == null
//            ? null
//            : json["has_airport_change"],
//        infantsConditions: json["infants_conditions"] == null
//            ? null
//            : InfantsConditions.fromJson(json["infants_conditions"]),
//        returnArrivalInt: json["return_arrival_int"] == null
//            ? null
//            : json["return_arrival_int"],
//        localDepartureInt: json["local_departure_int"] == null
//            ? null
//            : json["local_departure_int"],
//        virtualInterlining: json["virtual_interlining"] == null
//            ? null
//            : json["virtual_interlining"],
//        flightsRealChecked: json["flights_real_checked"] == null
//            ? null
//            : json["flights_real_checked"],
//        returnDepartureInt: json["return_departure_int"] == null
//            ? null
//            : json["return_departure_int"],
//        visasAgreementRequiered: json["visas_agreement_requiered"] == null
//            ? null
//            : json["visas_agreement_requiered"],
//        facilitatedBookingAvailable:
//            json["facilitated_booking_available"] == null
//                ? null
//                : json["facilitated_booking_available"],
      );

  Map<String, dynamic> toJson() => {
//        "id": id == null ? null : id,
//        "fare": fare == null ? null : fare.toJson(),
//        "pnum": pnum == null ? null : pnum,
        "flyTo": flyTo == null ? null : flyTo,
        "price": price == null ? null : price,
//        "route": route == null ? null : List<dynamic>.from(route.map((x) => x)),
//        "state": state,
//        "total": total == null ? null : total,
        "cityTo": cityTo == null ? null : cityTo,
//        "routes": routes == null
//            ? null
//            : List<dynamic>.from(
//                routes.map((x) => List<dynamic>.from(x.map((x) => x)))),
//        "sp_fee": spFee == null ? null : spFee,
//        "status": status == null ? null : status,
//        "baggage": baggage == null
//            ? null
//            : List<dynamic>.from(baggage.map((x) => x.toJson())),
//        "country": country,
        "flyFrom": flyFrom == null ? null : flyFrom,
//        "quality": quality == null ? null : quality,
//        "sandbox": sandbox == null ? null : sandbox,
//        "srIndex": srIndex == null ? null : srIndex,
//        "airlines": airlines == null
//            ? null
//            : List<dynamic>.from(airlines.map((x) => x)),
//        "baglimit": baglimit == null ? null : baglimit.toJson(),
//        "bags_fee": bagsFee == null ? null : bagsFee,
//        "book_fee": bookFee == null ? null : bookFee,
        "cityFrom": cityFrom == null ? null : cityFrom,
//        "distance": distance == null ? null : distance,
        "duration": duration == null ? null : duration.toJson(),
//        "countryTo": countryTo == null ? null : countryTo.toJson(),
//        "extra_fee": extraFee == null ? null : extraFee,
//        "pnr_count": pnrCount == null ? null : pnrCount,
//        "promocode": promocode == null ? null : promocode.toJson(),
        "roundtrip": roundtrip == null ? null : roundtrip,
//        "transfers": transfers == null
//            ? null
//            : List<dynamic>.from(transfers.map((x) => x)),
//        "auth_token": authToken == null ? null : authToken,
//        "bags_price": bagsPrice == null
//            ? null
//            : Map.from(bagsPrice)
//                .map((k, v) => MapEntry<String, dynamic>(k, v)),
//        "cityCodeTo": cityCodeTo == null ? null : cityCodeTo,
//        "conversion": conversion == null ? null : conversion.toJson(),
//        "orig_price": origPrice == null ? null : origPrice,
        "passengers": passengers == null
            ? null
            : List<dynamic>.from(passengers.map((x) => x.toJson())),
//        "payu_token": payuToken == null ? null : payuToken,
//        "countryFrom": countryFrom == null ? null : countryFrom.toJson(),
//        "fee_airline": feeAirline == null ? null : feeAirline,
//        "server_time": serverTime == null ? null : serverTime,
//        "utc_arrival": utcArrival == null ? null : utcArrival.toIso8601String(),
//        "adults_price": adultsPrice == null ? null : adultsPrice,
//        "availability": availability == null ? null : availability.toJson(),
//        "cityCodeFrom": cityCodeFrom == null ? null : cityCodeFrom,
//        "nightsInDest": nightsInDest == null ? null : nightsInDest,
//        "payment_info": paymentInfo == null ? null : paymentInfo.toJson(),
//        "price_change": priceChange == null ? null : priceChange,
//        "type_flights": typeFlights == null
//            ? null
//            : List<dynamic>.from(typeFlights.map((x) => x)),
//        "booking_token": bookingToken == null ? null : bookingToken,
//        "credits_price": creditsPrice == null ? null : creditsPrice,
//        "custom_markup": customMarkup,
//        "flights_price": flightsPrice == null ? null : flightsPrice,
//        "infants_price": infantsPrice == null ? null : infantsPrice,
        "local_arrival":
            localArrival == null ? null : localArrival.toIso8601String(),
//        "one_passenger": onePassenger == null ? null : onePassenger,
//        "tickets_price": ticketsPrice == null ? null : ticketsPrice,
//        "utc_departure":
//            utcDeparture == null ? null : utcDeparture.toIso8601String(),
//        "children_price": childrenPrice == null ? null : childrenPrice,
//        "insurance_data": insuranceData == null ? null : insuranceData.toJson(),
//        "max_passengers": maxPassengers == null ? null : maxPassengers,
//        "price_dropdown": priceDropdown == null ? null : priceDropdown.toJson(),
//        "return_arrival":
//            returnArrival == null ? null : returnArrival.toIso8601String(),
//        "transaction_id": transactionId == null ? null : transactionId,
//        "flights_checked": flightsChecked == null ? null : flightsChecked,
//        "flights_invalid": flightsInvalid == null ? null : flightsInvalid,
//        "insurance_price":
//            insurancePrice == null ? null : insurancePrice.toJson(),
        "local_departure":
            localDeparture == null ? null : localDeparture.toIso8601String(),
//        "payment_gateway": paymentGateway == null ? null : paymentGateway,
//        "payu_public_key": payuPublicKey == null ? null : payuPublicKey,
//        "technical_stops": technicalStops == null ? null : technicalStops,
//        "document_options":
//            documentOptions == null ? null : documentOptions.toJson(),
//        "flights_to_check": flightsToCheck == null ? null : flightsToCheck,
//        "orig_price_usage": origPriceUsage == null ? null : origPriceUsage,
        "return_departure":
            returnDeparture == null ? null : returnDeparture.toIso8601String(),
//        "ancillaries_order":
//            ancillariesOrder == null ? null : ancillariesOrder.toJson(),
//        "eur_payment_price": eurPaymentPrice == null ? null : eurPaymentPrice,
//        "flight_real_price": flightRealPrice == null ? null : flightRealPrice,
//        "local_arrival_int": localArrivalInt == null ? null : localArrivalInt,
//        "has_airport_change":
//            hasAirportChange == null ? null : hasAirportChange,
//        "infants_conditions":
//            infantsConditions == null ? null : infantsConditions.toJson(),
//        "return_arrival_int":
//            returnArrivalInt == null ? null : returnArrivalInt,
//        "local_departure_int":
//            localDepartureInt == null ? null : localDepartureInt,
//        "virtual_interlining":
//            virtualInterlining == null ? null : virtualInterlining,
//        "flights_real_checked":
//            flightsRealChecked == null ? null : flightsRealChecked,
//        "return_departure_int":
//            returnDepartureInt == null ? null : returnDepartureInt,
//        "visas_agreement_requiered":
//            visasAgreementRequiered == null ? null : visasAgreementRequiered,
//        "facilitated_booking_available": facilitatedBookingAvailable == null
//            ? null
//            : facilitatedBookingAvailable,
      };
}

class AncillariesOrder {
  Airhelp airhelp;
  Airhelp seating;
  FareType fareType;
  Airhelp fastTrack;
  Airhelp airhelpPlus;
  Airhelp axaInsurance;
  Airhelp blueribbonBags;
  ServicePackage servicePackage;
  Airhelp mandatorySeating;
  Airhelp priorityBoarding;
  dynamic oldServicePackage;
  Airhelp coverMoreInsurance;

  AncillariesOrder({
    this.airhelp,
    this.seating,
    this.fareType,
    this.fastTrack,
    this.airhelpPlus,
    this.axaInsurance,
    this.blueribbonBags,
    this.servicePackage,
    this.mandatorySeating,
    this.priorityBoarding,
    this.oldServicePackage,
    this.coverMoreInsurance,
  });

  factory AncillariesOrder.fromRawJson(String str) =>
      AncillariesOrder.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AncillariesOrder.fromJson(Map<String, dynamic> json) =>
      AncillariesOrder(
        airhelp:
            json["airhelp"] == null ? null : Airhelp.fromJson(json["airhelp"]),
        seating:
            json["seating"] == null ? null : Airhelp.fromJson(json["seating"]),
        fareType: json["fare_type"] == null
            ? null
            : FareType.fromJson(json["fare_type"]),
        fastTrack: json["fast_track"] == null
            ? null
            : Airhelp.fromJson(json["fast_track"]),
        airhelpPlus: json["airhelp_plus"] == null
            ? null
            : Airhelp.fromJson(json["airhelp_plus"]),
        axaInsurance: json["axa_insurance"] == null
            ? null
            : Airhelp.fromJson(json["axa_insurance"]),
        blueribbonBags: json["blueribbon_bags"] == null
            ? null
            : Airhelp.fromJson(json["blueribbon_bags"]),
        servicePackage: json["service_package"] == null
            ? null
            : ServicePackage.fromJson(json["service_package"]),
        mandatorySeating: json["mandatory_seating"] == null
            ? null
            : Airhelp.fromJson(json["mandatory_seating"]),
        priorityBoarding: json["priority_boarding"] == null
            ? null
            : Airhelp.fromJson(json["priority_boarding"]),
        oldServicePackage: json["old_service_package"],
        coverMoreInsurance: json["cover_more_insurance"] == null
            ? null
            : Airhelp.fromJson(json["cover_more_insurance"]),
      );

  Map<String, dynamic> toJson() => {
        "airhelp": airhelp == null ? null : airhelp.toJson(),
        "seating": seating == null ? null : seating.toJson(),
        "fare_type": fareType == null ? null : fareType.toJson(),
        "fast_track": fastTrack == null ? null : fastTrack.toJson(),
        "airhelp_plus": airhelpPlus == null ? null : airhelpPlus.toJson(),
        "axa_insurance": axaInsurance == null ? null : axaInsurance.toJson(),
        "blueribbon_bags":
            blueribbonBags == null ? null : blueribbonBags.toJson(),
        "service_package":
            servicePackage == null ? null : servicePackage.toJson(),
        "mandatory_seating":
            mandatorySeating == null ? null : mandatorySeating.toJson(),
        "priority_boarding":
            priorityBoarding == null ? null : priorityBoarding.toJson(),
        "old_service_package": oldServicePackage,
        "cover_more_insurance":
            coverMoreInsurance == null ? null : coverMoreInsurance.toJson(),
      };
}

class Airhelp {
  num type;
  List<Price> orders;

  Airhelp({
    this.type,
    this.orders,
  });

  factory Airhelp.fromRawJson(String str) => Airhelp.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Airhelp.fromJson(Map<String, dynamic> json) => Airhelp(
        type: json["type"] == null ? null : json["type"],
        orders: json["orders"] == null
            ? null
            : List<Price>.from(json["orders"].map((x) => Price.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type == null ? null : type,
        "orders": orders == null
            ? null
            : List<dynamic>.from(orders.map((x) => x.toJson())),
      };
}

class Price {
  String base;
  String amount;
  String service;
  String currency;
  String merchant;
  String serviceFlat;

  Price({
    this.base,
    this.amount,
    this.service,
    this.currency,
    this.merchant,
    this.serviceFlat,
  });

  factory Price.fromRawJson(String str) => Price.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Price.fromJson(Map<String, dynamic> json) => Price(
        base: json["base"] == null ? null : json["base"],
        amount: json["amount"] == null ? null : json["amount"],
        service: json["service"] == null ? null : json["service"],
        currency: json["currency"] == null ? null : json["currency"],
        merchant: json["merchant"] == null ? null : json["merchant"],
        serviceFlat: json["service_flat"] == null ? null : json["service_flat"],
      );

  Map<String, dynamic> toJson() => {
        "base": base == null ? null : base,
        "amount": amount == null ? null : amount,
        "service": service == null ? null : service,
        "currency": currency == null ? null : currency,
        "merchant": merchant == null ? null : merchant,
        "service_flat": serviceFlat == null ? null : serviceFlat,
      };
}

class FareType {
  num type;
  List<FareTypeOrder> orders;

  FareType({
    this.type,
    this.orders,
  });

  factory FareType.fromRawJson(String str) =>
      FareType.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FareType.fromJson(Map<String, dynamic> json) => FareType(
        type: json["type"] == null ? null : json["type"],
        orders: json["orders"] == null
            ? null
            : List<FareTypeOrder>.from(
                json["orders"].map((x) => FareTypeOrder.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type == null ? null : type,
        "orders": orders == null
            ? null
            : List<dynamic>.from(orders.map((x) => x.toJson())),
      };
}

class FareTypeOrder {
  Price price;
  String ticket;
  num rulesetId;

  FareTypeOrder({
    this.price,
    this.ticket,
    this.rulesetId,
  });

  factory FareTypeOrder.fromRawJson(String str) =>
      FareTypeOrder.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FareTypeOrder.fromJson(Map<String, dynamic> json) => FareTypeOrder(
        price: json["price"] == null ? null : Price.fromJson(json["price"]),
        ticket: json["ticket"] == null ? null : json["ticket"],
        rulesetId: json["ruleset_id"] == null ? null : json["ruleset_id"],
      );

  Map<String, dynamic> toJson() => {
        "price": price == null ? null : price.toJson(),
        "ticket": ticket == null ? null : ticket,
        "ruleset_id": rulesetId == null ? null : rulesetId,
      };
}

class ServicePackage {
  num type;
  List<ServicePackageOrder> orders;

  ServicePackage({
    this.type,
    this.orders,
  });

  factory ServicePackage.fromRawJson(String str) =>
      ServicePackage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ServicePackage.fromJson(Map<String, dynamic> json) => ServicePackage(
        type: json["type"] == null ? null : json["type"],
        orders: json["orders"] == null
            ? null
            : List<ServicePackageOrder>.from(
                json["orders"].map((x) => ServicePackageOrder.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type == null ? null : type,
        "orders": orders == null
            ? null
            : List<dynamic>.from(orders.map((x) => x.toJson())),
      };
}

class ServicePackageOrder {
  String level;
  Price price;
  num rulesetId;

  ServicePackageOrder({
    this.level,
    this.price,
    this.rulesetId,
  });

  factory ServicePackageOrder.fromRawJson(String str) =>
      ServicePackageOrder.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ServicePackageOrder.fromJson(Map<String, dynamic> json) =>
      ServicePackageOrder(
        level: json["level"] == null ? null : json["level"],
        price: json["price"] == null ? null : Price.fromJson(json["price"]),
        rulesetId: json["ruleset_id"] == null ? null : json["ruleset_id"],
      );

  Map<String, dynamic> toJson() => {
        "level": level == null ? null : level,
        "price": price == null ? null : price.toJson(),
        "ruleset_id": rulesetId == null ? null : rulesetId,
      };
}

class Availability {
  num seats;

  Availability({
    this.seats,
  });

  factory Availability.fromRawJson(String str) =>
      Availability.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Availability.fromJson(Map<String, dynamic> json) => Availability(
        seats: json["seats"] == null ? null : json["seats"],
      );

  Map<String, dynamic> toJson() => {
        "seats": seats == null ? null : seats,
      };
}

class Baggage {
  num id;
  Bag bag;
  num index;
  Price price;
  num flightId;
  num bookingId;
  dynamic deletedAt;
  num passengerId;
  dynamic segmentCode;
  dynamic additionalBookingId;

  Baggage({
    this.id,
    this.bag,
    this.index,
    this.price,
    this.flightId,
    this.bookingId,
    this.deletedAt,
    this.passengerId,
    this.segmentCode,
    this.additionalBookingId,
  });

  factory Baggage.fromRawJson(String str) => Baggage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Baggage.fromJson(Map<String, dynamic> json) => Baggage(
        id: json["id"] == null ? null : json["id"],
        bag: json["bag"] == null ? null : Bag.fromJson(json["bag"]),
        index: json["index"] == null ? null : json["index"],
        price: json["price"] == null ? null : Price.fromJson(json["price"]),
        flightId: json["flight_id"] == null ? null : json["flight_id"],
        bookingId: json["booking_id"] == null ? null : json["booking_id"],
        deletedAt: json["deleted_at"],
        passengerId: json["passenger_id"] == null ? null : json["passenger_id"],
        segmentCode: json["segment_code"],
        additionalBookingId: json["additional_booking_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "bag": bag == null ? null : bag.toJson(),
        "index": index == null ? null : index,
        "price": price == null ? null : price.toJson(),
        "flight_id": flightId == null ? null : flightId,
        "booking_id": bookingId == null ? null : bookingId,
        "deleted_at": deletedAt,
        "passenger_id": passengerId == null ? null : passengerId,
        "segment_code": segmentCode,
        "additional_booking_id": additionalBookingId,
      };
}

class Bag {
  num id;
  num width;
  num height;
  num length;
  num weight;
  String category;
  num dimensionsSum;

  Bag({
    this.id,
    this.width,
    this.height,
    this.length,
    this.weight,
    this.category,
    this.dimensionsSum,
  });

  factory Bag.fromRawJson(String str) => Bag.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Bag.fromJson(Map<String, dynamic> json) => Bag(
        id: json["id"] == null ? null : json["id"],
        width: json["width"] == null ? null : json["width"],
        height: json["height"] == null ? null : json["height"],
        length: json["length"] == null ? null : json["length"],
        weight: json["weight"] == null ? null : json["weight"],
        category: json["category"] == null ? null : json["category"],
        dimensionsSum:
            json["dimensions_sum"] == null ? null : json["dimensions_sum"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "width": width == null ? null : width,
        "height": height == null ? null : height,
        "length": length == null ? null : length,
        "weight": weight == null ? null : weight,
        "category": category == null ? null : category,
        "dimensions_sum": dimensionsSum == null ? null : dimensionsSum,
      };
}

class Baglimit {
  num holdWidth;
  num holdHeight;
  num holdLength;
  num holdWeight;
  num holdDimensionsSum;

  Baglimit({
    this.holdWidth,
    this.holdHeight,
    this.holdLength,
    this.holdWeight,
    this.holdDimensionsSum,
  });

  factory Baglimit.fromRawJson(String str) =>
      Baglimit.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Baglimit.fromJson(Map<String, dynamic> json) => Baglimit(
        holdWidth: json["hold_width"] == null ? null : json["hold_width"],
        holdHeight: json["hold_height"] == null ? null : json["hold_height"],
        holdLength: json["hold_length"] == null ? null : json["hold_length"],
        holdWeight: json["hold_weight"] == null ? null : json["hold_weight"],
        holdDimensionsSum: json["hold_dimensions_sum"] == null
            ? null
            : json["hold_dimensions_sum"],
      );

  Map<String, dynamic> toJson() => {
        "hold_width": holdWidth == null ? null : holdWidth,
        "hold_height": holdHeight == null ? null : holdHeight,
        "hold_length": holdLength == null ? null : holdLength,
        "hold_weight": holdWeight == null ? null : holdWeight,
        "hold_dimensions_sum":
            holdDimensionsSum == null ? null : holdDimensionsSum,
      };
}

class Conversion {
  num eur;
  num usd;

  Conversion({
    this.eur,
    this.usd,
  });

  factory Conversion.fromRawJson(String str) =>
      Conversion.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Conversion.fromJson(Map<String, dynamic> json) => Conversion(
        eur: json["EUR"] == null ? null : json["EUR"],
        usd: json["USD"] == null ? null : json["USD"],
      );

  Map<String, dynamic> toJson() => {
        "EUR": eur == null ? null : eur,
        "USD": usd == null ? null : usd,
      };
}

class Country {
  String code;
  String name;

  Country({
    this.code,
    this.name,
  });

  factory Country.fromRawJson(String str) => Country.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        code: json["code"] == null ? null : json["code"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "name": name == null ? null : name,
      };
}

class DocumentOptions {
  num checkinDate;
  num documentNeed;
  num airportCheckinPrice;

  DocumentOptions({
    this.checkinDate,
    this.documentNeed,
    this.airportCheckinPrice,
  });

  factory DocumentOptions.fromRawJson(String str) =>
      DocumentOptions.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DocumentOptions.fromJson(Map<String, dynamic> json) =>
      DocumentOptions(
        checkinDate: json["checkin_date"] == null ? null : json["checkin_date"],
        documentNeed:
            json["document_need"] == null ? null : json["document_need"],
        airportCheckinPrice: json["airport_checkin_price"] == null
            ? null
            : json["airport_checkin_price"],
      );

  Map<String, dynamic> toJson() => {
        "checkin_date": checkinDate == null ? null : checkinDate,
        "document_need": documentNeed == null ? null : documentNeed,
        "airport_checkin_price":
            airportCheckinPrice == null ? null : airportCheckinPrice,
      };
}

class FlightDuration {
  num total;
  num durationReturn;
  num departure;

  FlightDuration({
    this.total,
    this.durationReturn,
    this.departure,
  });

  factory FlightDuration.fromRawJson(String str) =>
      FlightDuration.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FlightDuration.fromJson(Map<String, dynamic> json) => FlightDuration(
        total: json["total"] == null ? null : json["total"],
        durationReturn: json["return"] == null ? null : json["return"],
        departure: json["departure"] == null ? null : json["departure"],
      );

  Map<String, dynamic> toJson() => {
        "total": total == null ? null : total,
        "return": durationReturn == null ? null : durationReturn,
        "departure": departure == null ? null : departure,
      };
}

class Fare {
  num adults;
  num infants;
  num children;

  Fare({
    this.adults,
    this.infants,
    this.children,
  });

  factory Fare.fromRawJson(String str) => Fare.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Fare.fromJson(Map<String, dynamic> json) => Fare(
        adults: json["adults"] == null ? null : json["adults"],
        infants: json["infants"] == null ? null : json["infants"],
        children: json["children"] == null ? null : json["children"],
      );

  Map<String, dynamic> toJson() => {
        "adults": adults == null ? null : adults,
        "infants": infants == null ? null : infants,
        "children": children == null ? null : children,
      };
}

class InfantsConditions {
  bool trolley;
  num handWeight;

  InfantsConditions({
    this.trolley,
    this.handWeight,
  });

  factory InfantsConditions.fromRawJson(String str) =>
      InfantsConditions.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InfantsConditions.fromJson(Map<String, dynamic> json) =>
      InfantsConditions(
        trolley: json["trolley"] == null ? null : json["trolley"],
        handWeight: json["hand_weight"] == null ? null : json["hand_weight"],
      );

  Map<String, dynamic> toJson() => {
        "trolley": trolley == null ? null : trolley,
        "hand_weight": handWeight == null ? null : handWeight,
      };
}

class InsuranceData {
  String tarif;
  Skygold skygold;
  num validTo;
  Skygold skysilver;
  num validFrom;
  Skygold travelPlus;
  Skygold travelBasic;

  InsuranceData({
    this.tarif,
    this.skygold,
    this.validTo,
    this.skysilver,
    this.validFrom,
    this.travelPlus,
    this.travelBasic,
  });

  factory InsuranceData.fromRawJson(String str) =>
      InsuranceData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InsuranceData.fromJson(Map<String, dynamic> json) => InsuranceData(
        tarif: json["tarif"] == null ? null : json["tarif"],
        skygold:
            json["skygold"] == null ? null : Skygold.fromJson(json["skygold"]),
        validTo: json["valid_to"] == null ? null : json["valid_to"],
        skysilver: json["skysilver"] == null
            ? null
            : Skygold.fromJson(json["skysilver"]),
        validFrom: json["valid_from"] == null ? null : json["valid_from"],
        travelPlus: json["travel_plus"] == null
            ? null
            : Skygold.fromJson(json["travel_plus"]),
        travelBasic: json["travel_basic"] == null
            ? null
            : Skygold.fromJson(json["travel_basic"]),
      );

  Map<String, dynamic> toJson() => {
        "tarif": tarif == null ? null : tarif,
        "skygold": skygold == null ? null : skygold.toJson(),
        "valid_to": validTo == null ? null : validTo,
        "skysilver": skysilver == null ? null : skysilver.toJson(),
        "valid_from": validFrom == null ? null : validFrom,
        "travel_plus": travelPlus == null ? null : travelPlus.toJson(),
        "travel_basic": travelBasic == null ? null : travelBasic.toJson(),
      };
}

class Skygold {
  num price;
  String productNum;

  Skygold({
    this.price,
    this.productNum,
  });

  factory Skygold.fromRawJson(String str) => Skygold.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Skygold.fromJson(Map<String, dynamic> json) => Skygold(
        price: json["price"] == null ? null : json["price"].toDouble(),
        productNum: json["product_num"] == null ? null : json["product_num"],
      );

  Map<String, dynamic> toJson() => {
        "price": price == null ? null : price,
        "product_num": productNum == null ? null : productNum,
      };
}

class InsurancePrice {
  num skygold;
  num skysilver;
  num travelPlus;
  num travelBasic;

  InsurancePrice({
    this.skygold,
    this.skysilver,
    this.travelPlus,
    this.travelBasic,
  });

  factory InsurancePrice.fromRawJson(String str) =>
      InsurancePrice.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InsurancePrice.fromJson(Map<String, dynamic> json) => InsurancePrice(
        skygold: json["skygold"] == null ? null : json["skygold"].toDouble(),
        skysilver:
            json["skysilver"] == null ? null : json["skysilver"].toDouble(),
        travelPlus:
            json["travel_plus"] == null ? null : json["travel_plus"].toDouble(),
        travelBasic: json["travel_basic"] == null
            ? null
            : json["travel_basic"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "skygold": skygold == null ? null : skygold,
        "skysilver": skysilver == null ? null : skysilver,
        "travel_plus": travelPlus == null ? null : travelPlus,
        "travel_basic": travelBasic == null ? null : travelBasic,
      };
}

class Passenger {
  num pk;
  num bid;
  String name;
  dynamic visa;
  String title;
  String cardno;
  String issuer;
  DateTime checkin;
  String surname;
  DateTime birthday;
  String category;
  DateTime createdAt;
  DateTime expiration;
  DateTime updatedAt;
  String nationality;
  dynamic insuranceSent;
  String insuranceType;
  num insurancePrice;

  Passenger({
    this.pk,
    this.bid,
    this.name,
    this.visa,
    this.title,
    this.cardno,
    this.issuer,
    this.checkin,
    this.surname,
    this.birthday,
    this.category,
    this.createdAt,
    this.expiration,
    this.updatedAt,
    this.nationality,
    this.insuranceSent,
    this.insuranceType,
    this.insurancePrice,
  });

  factory Passenger.fromRawJson(String str) =>
      Passenger.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Passenger.fromJson(Map<String, dynamic> json) => Passenger(
        pk: json["pk"] == null ? null : json["pk"],
        bid: json["bid"] == null ? null : json["bid"],
        name: json["name"] == null ? null : json["name"],
        visa: json["visa"],
        title: json["title"] == null ? null : json["title"],
        cardno: json["cardno"] == null ? null : json["cardno"],
        issuer: json["issuer"] == null ? null : json["issuer"],
        checkin:
            json["checkin"] == null ? null : DateTime.parse(json["checkin"]),
        surname: json["surname"] == null ? null : json["surname"],
        birthday:
            json["birthday"] == null ? null : DateTime.parse(json["birthday"]),
        category: json["category"] == null ? null : json["category"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        expiration: json["expiration"] == null
            ? null
            : DateTime.parse(json["expiration"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        nationality: json["nationality"] == null ? null : json["nationality"],
        insuranceSent: json["insurance_sent"],
        insuranceType:
            json["insurance_type"] == null ? null : json["insurance_type"],
        insurancePrice:
            json["insurance_price"] == null ? null : json["insurance_price"],
      );

  Map<String, dynamic> toJson() => {
        "pk": pk == null ? null : pk,
        "bid": bid == null ? null : bid,
        "name": name == null ? null : name,
        "visa": visa,
        "title": title == null ? null : title,
        "cardno": cardno == null ? null : cardno,
        "issuer": issuer == null ? null : issuer,
        "checkin": checkin == null ? null : checkin.toIso8601String(),
        "surname": surname == null ? null : surname,
        "birthday": birthday == null
            ? null
            : "${birthday.year.toString().padLeft(4, '0')}-${birthday.month.toString().padLeft(2, '0')}-${birthday.day.toString().padLeft(2, '0')}",
        "category": category == null ? null : category,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "expiration": expiration == null ? null : expiration.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "nationality": nationality == null ? null : nationality,
        "insurance_sent": insuranceSent,
        "insurance_type": insuranceType == null ? null : insuranceType,
        "insurance_price": insurancePrice == null ? null : insurancePrice,
      };
}

class PaymentInfo {
  Cs cs;
  Cs payu;
  num credits;

  PaymentInfo({
    this.cs,
    this.payu,
    this.credits,
  });

  factory PaymentInfo.fromRawJson(String str) =>
      PaymentInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentInfo.fromJson(Map<String, dynamic> json) => PaymentInfo(
        cs: json["CS"] == null ? null : Cs.fromJson(json["CS"]),
        payu: json["payu"] == null ? null : Cs.fromJson(json["payu"]),
        credits: json["credits"] == null ? null : json["credits"],
      );

  Map<String, dynamic> toJson() => {
        "CS": cs == null ? null : cs.toJson(),
        "payu": payu == null ? null : payu.toJson(),
        "credits": credits == null ? null : credits,
      };
}

class Cs {
  num amount;
  String currency;

  Cs({
    this.amount,
    this.currency,
  });

  factory Cs.fromRawJson(String str) => Cs.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Cs.fromJson(Map<String, dynamic> json) => Cs(
        amount: json["amount"] == null ? null : json["amount"],
        currency: json["currency"] == null ? null : json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount == null ? null : amount,
        "currency": currency == null ? null : currency,
      };
}

class PriceDropdown {
  num fees;
  num baseFare;

  PriceDropdown({
    this.fees,
    this.baseFare,
  });

  factory PriceDropdown.fromRawJson(String str) =>
      PriceDropdown.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PriceDropdown.fromJson(Map<String, dynamic> json) => PriceDropdown(
        fees: json["fees"] == null ? null : json["fees"],
        baseFare: json["base_fare"] == null ? null : json["base_fare"],
      );

  Map<String, dynamic> toJson() => {
        "fees": fees == null ? null : fees,
        "base_fare": baseFare == null ? null : baseFare,
      };
}

class Promocode {
  bool used;
  num discount;

  Promocode({
    this.used,
    this.discount,
  });

  factory Promocode.fromRawJson(String str) =>
      Promocode.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Promocode.fromJson(Map<String, dynamic> json) => Promocode(
        used: json["used"] == null ? null : json["used"],
        discount: json["discount"] == null ? null : json["discount"],
      );

  Map<String, dynamic> toJson() => {
        "used": used == null ? null : used,
        "discount": discount == null ? null : discount,
      };
}

class Flight {
  num id;
  DateTime departureTime;
  DateTime arrivalTime;
  String cityFrom;
  String cityTo;
  String airportFrom;
  String airportTo;
  bool isReturn;
  FlightData data;

  Flight({
    this.id,
    this.departureTime,
    this.arrivalTime,
    this.cityFrom,
    this.cityTo,
    this.airportFrom,
    this.airportTo,
    this.isReturn,
    this.data,
  });

  factory Flight.fromRawJson(String str) => Flight.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Flight.fromJson(Map<String, dynamic> json) => Flight(
        id: json["id"] == null ? null : json["id"],
        departureTime: json["departure_time"] == null
            ? null
            : DateTime.parse(json["departure_time"]),
        arrivalTime: json["arrival_time"] == null
            ? null
            : DateTime.parse(json["arrival_time"]),
        cityFrom: json["city_from"] == null ? null : json["city_from"],
        cityTo: json["city_to"] == null ? null : json["city_to"],
        airportFrom: json["airport_from"] == null ? null : json["airport_from"],
        airportTo: json["airport_to"] == null ? null : json["airport_to"],
        isReturn: json["is_return"] == null ? null : json["is_return"],
        data: json["data"] == null ? null : FlightData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "departure_time":
            departureTime == null ? null : departureTime.toIso8601String(),
        "arrival_time":
            arrivalTime == null ? null : arrivalTime.toIso8601String(),
        "city_from": cityFrom == null ? null : cityFrom,
        "city_to": cityTo == null ? null : cityTo,
        "airport_from": airportFrom == null ? null : airportFrom,
        "airport_to": airportTo == null ? null : airportTo,
        "is_return": isReturn == null ? null : isReturn,
        "data": data == null ? null : data.toJson(),
      };
}

class FlightData {
  String flyTo;
  String cityTo;
  Airline airline;
  String flyFrom;
  String cityFrom;
  String flightNo;
  String cityCodeTo;
  String cityCodeFrom;
  DateTime localArrival;
  DateTime localDeparture;

  FlightData({
    this.flyTo,
    this.cityTo,
    this.airline,
    this.flyFrom,
    this.cityFrom,
    this.flightNo,
    this.cityCodeTo,
    this.cityCodeFrom,
    this.localArrival,
    this.localDeparture,
  });

  factory FlightData.fromRawJson(String str) =>
      FlightData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FlightData.fromJson(Map<String, dynamic> json) => FlightData(
        flyTo: json["flyTo"] == null ? null : json["flyTo"],
        cityTo: json["cityTo"] == null ? null : json["cityTo"],
        airline:
            json["airline"] == null ? null : Airline.fromJson(json["airline"]),
        flyFrom: json["flyFrom"] == null ? null : json["flyFrom"],
        cityFrom: json["cityFrom"] == null ? null : json["cityFrom"],
        flightNo: json["flight_no"] == null ? null : json["flight_no"],
        cityCodeTo: json["cityCodeTo"] == null ? null : json["cityCodeTo"],
        cityCodeFrom:
            json["cityCodeFrom"] == null ? null : json["cityCodeFrom"],
        localArrival: json["local_arrival"] == null
            ? null
            : DateTime.parse(json["local_arrival"]),
        localDeparture: json["local_departure"] == null
            ? null
            : DateTime.parse(json["local_departure"]),
      );

  Map<String, dynamic> toJson() => {
        "flyTo": flyTo == null ? null : flyTo,
        "cityTo": cityTo == null ? null : cityTo,
        "airline": airline == null ? null : airline.toJson(),
        "flyFrom": flyFrom == null ? null : flyFrom,
        "flight_no": flightNo == null ? null : flightNo,
        "cityFrom": cityFrom == null ? null : cityFrom,
        "cityCodeTo": cityCodeTo == null ? null : cityCodeTo,
        "cityCodeFrom": cityCodeFrom == null ? null : cityCodeFrom,
        "local_arrival":
            localArrival == null ? null : localArrival.toIso8601String(),
        "local_departure":
            localDeparture == null ? null : localDeparture.toIso8601String(),
      };
}

class Airline {
  String code;
  String airlineName;

  Airline({
    this.code,
    this.airlineName,
  });

  factory Airline.fromRawJson(String str) => Airline.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Airline.fromJson(Map<String, dynamic> json) => Airline(
        code: json["code"] == null ? null : json["code"],
        airlineName: json["name"] == null ? null : json["name"],
  );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "name": airlineName == null ? null : airlineName,
      };
}

class FeesPerSource {
  FeesPerSource();

  factory FeesPerSource.fromRawJson(String str) =>
      FeesPerSource.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FeesPerSource.fromJson(Map<String, dynamic> json) => FeesPerSource();

  Map<String, dynamic> toJson() => {};
}

class OperatingAirline {
  String iata;
  String name;

  OperatingAirline({
    this.iata,
    this.name,
  });

  factory OperatingAirline.fromRawJson(String str) =>
      OperatingAirline.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OperatingAirline.fromJson(Map<String, dynamic> json) =>
      OperatingAirline(
        iata: json["iata"] == null ? null : json["iata"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "iata": iata == null ? null : iata,
        "name": name == null ? null : name,
      };
}

class PassengersFlightCheck {
  The1 the1;

  PassengersFlightCheck({
    this.the1,
  });

  factory PassengersFlightCheck.fromRawJson(String str) =>
      PassengersFlightCheck.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PassengersFlightCheck.fromJson(Map<String, dynamic> json) =>
      PassengersFlightCheck(
        the1: json["1"] == null ? null : The1.fromJson(json["1"]),
      );

  Map<String, dynamic> toJson() => {
        "1": the1 == null ? null : the1.toJson(),
      };
}

class The1 {
  num eur;
  bool invalid;
  num lastChecked;

  The1({
    this.eur,
    this.invalid,
    this.lastChecked,
  });

  factory The1.fromRawJson(String str) => The1.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory The1.fromJson(Map<String, dynamic> json) => The1(
        eur: json["eur"] == null ? null : json["eur"].toDouble(),
        invalid: json["invalid"] == null ? null : json["invalid"],
        lastChecked: json["last_checked"] == null ? null : json["last_checked"],
      );

  Map<String, dynamic> toJson() => {
        "eur": eur == null ? null : eur,
        "invalid": invalid == null ? null : invalid,
        "last_checked": lastChecked == null ? null : lastChecked,
      };
}

class Vehicle {
  String type;

  Vehicle({
    this.type,
  });

  factory Vehicle.fromRawJson(String str) => Vehicle.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        type: json["type"] == null ? null : json["type"],
      );

  Map<String, dynamic> toJson() => {
        "type": type == null ? null : type,
      };
}
