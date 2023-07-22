class DateModel {
  late String title;
  late String image;
  late String booking;

  DateModel(this.title, this.image, this.booking);
  DateModel.fromjson(Map<String, dynamic> map) {
    this.title = map['title'];
    this.image = map['image'];
    this.booking = map['booking'];
  }
}
