class PaitentModel {
  int? id;
  int? userId;
  String? name;
  String? email;
  String? phoneNo;
  int? age;
  String? image;
  String? address;
  String? gender;
  String? diabeticType;
  String? patientStatus;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;
  List<PatientBiography>? patientBiography;
  List<Measurements>? measurements;

  PaitentModel(
      {this.id,
      this.userId,
      this.name,
      this.email,
      this.phoneNo,
      this.age,
      this.image,
      this.address,
      this.gender,
      this.diabeticType,
      this.patientStatus,
      this.deletedAt,
      this.createdAt,
      this.patientBiography,
      this.measurements,
      this.updatedAt,
      this.pivot});

  PaitentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    phoneNo = json['phone_No'];
    age = json['age'];
    image = json['image'];
    address = json['address'];
    gender = json['gender'];
    diabeticType = json['diabetic_type'];
    patientStatus = json['patient_status'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['patient_biography'] != null) {
      patientBiography = <PatientBiography>[];
      json['patient_biography'].forEach((v) {
        patientBiography!.add(PatientBiography.fromJson(v));
      });
    }
    if (json['measurements'] != null) {
      measurements = <Measurements>[];
      json['measurements'].forEach((v) {
        measurements!.add(Measurements.fromJson(v));
      });
    }
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone_No'] = this.phoneNo;
    data['age'] = this.age;
    data['image'] = this.image;
    data['address'] = this.address;
    data['gender'] = this.gender;
    data['diabetic_type'] = this.diabeticType;
    data['patient_status'] = this.patientStatus;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
    return data;
  }
}

class Measurements {
  int? Fasting;
  int? Creator;
  int? Random;
  String? DateTime;

  Measurements(this.Fasting, this.Creator, this.Random, this.DateTime);

  Measurements.fromJson(Map<String, dynamic> json) {
    Fasting = json['Fasting'];
    Creator = json['creator'];
    Random = json['random'];
    DateTime = json['created_at'];
  }
}

class PatientBiography {
  String? Diagnostics;
  String? Medications;

  PatientBiography(this.Diagnostics, this.Medications);

  PatientBiography.fromJson(Map<String, dynamic> json) {
    Diagnostics = json['diagnostics'];
    Medications = json['medications'];
  }
}

class Pivot {
  int? doctorId;
  int? patientId;

  Pivot({this.doctorId, this.patientId});

  Pivot.fromJson(Map<String, dynamic> json) {
    doctorId = json['doctor_id'];
    patientId = json['patient_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doctor_id'] = this.doctorId;
    data['patient_id'] = this.patientId;
    return data;
  }
}
