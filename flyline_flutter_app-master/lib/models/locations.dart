// A Pojo class for LocationObject
class LocationObject {
  String code;
  String countryCode;
  String type;
  String name;
  String subdivisionName;
  Map raw;

  LocationObject(String code, String countryCode, String type, String name,
      String subdivisionName, Map raw) {
    this.code = code;
    this.type = type;
    this.countryCode = countryCode;
    this.name = name;
    this.subdivisionName = subdivisionName;
    this.raw = raw;
  }

  factory LocationObject.fromJson(Map<String, dynamic> json) {
    var subdivision = "";
    var country = "";
    if (json['type'] == "city" && json['subdivision'] != null) {
      subdivision = json['subdivision']['name'];
    }
    if (json['country'] != null) {
      country = json['country']['code'];
    }else{
      if ( json['city'] != null && json['city']['country'] != null && json['city']['country']['code'] != null ){
        country = json['city']['country']['code'];
      }
    }

    return LocationObject(
        json['code'], country, json['type'], json['name'], subdivision, json);
  }

  Map<String, dynamic> toJson() => {
        "code": code.toUpperCase(),
        "country": {"code": countryCode},
        "type": type,
        "name": name,
        "subdivision": {"name": subdivisionName},
      };
}
