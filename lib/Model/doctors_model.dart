class DoctorsModel {
  late String title;
  late String image;

  DoctorsModel(this.title, this.image);
  DoctorsModel.fromjson(Map<String, dynamic> map) {
    this.title = map['title'];
    this.image = map['image'];
  }
}
