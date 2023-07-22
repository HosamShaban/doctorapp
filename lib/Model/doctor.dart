class DoctorModel {
  int? id;
  String? name;
  String? email;
  String? password;
  String? phoneNo;
  String? qualifications;
  String? address;
  String? image;
  String? rateing;
  String? DateTime;

  DoctorModel(
      {this.id,
      this.name,
      this.email,
      this.password,
      this.phoneNo,
      this.qualifications,
      this.address,
      this.image,
      this.rateing,
      this.DateTime});

  DoctorModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    phoneNo = json['phone_No'];
    qualifications = json['qualifications'];
    address = json['address'];
    image = json['image'];
    rateing = json['rateing'];
    DateTime = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['phone_No'] = this.phoneNo;
    data['qualifications'] = this.qualifications;
    data['address'] = this.address;
    data['image'] = this.image;
    data['rateing'] = this.rateing;

    return data;
  }
}
