import 'dart:convert';

class BoardingPassAirlineUrl {

  static String urlDataBaseInStringFormat = """
{
"F9":"https://www.flyfrontier.com/travel/my-trips/manage-trip/?mobile=true",
"AA":"https://www.aa.com/homePage.do",
"DL":"https://www.delta.com/mytrips/",
"AS":"https://www.alaskaair.com/booking/reservation-lookup",
"NK":"https://www.spirit.com/"
}



""";

  var airlineJsonData = jsonDecode(urlDataBaseInStringFormat);
}
