class PaymentInformation{
  String nameOfCard;
  String creditCart;
  String expDate;
  String cvv;

  PaymentInformation({this.nameOfCard, this.creditCart, this.expDate, this.cvv});

  PaymentInformation.fromJson(Map<String, dynamic> json) {
    nameOfCard = json['nameOfCard'];
    creditCart = json['creditCart'];
    expDate = json['expDate'];
    cvv = json['cvv'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nameOfCard'] = this.nameOfCard;
    data['creditCart'] = this.creditCart;
    data['expDate'] = this.expDate;
    data['cvv'] = this.cvv;
    return data;
  }
}