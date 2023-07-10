class AppointmentsModel {
  int? id;
  int? patientId;
  int? doctorId;
  String? bookingDay;
  String? bookingDate;
  String? bookingTime;
  String? status;
  String? createdAt;
  String? updatedAt;

  AppointmentsModel(
      {this.id,
      this.patientId,
      this.doctorId,
      this.bookingDay,
      this.bookingDate,
      this.bookingTime,
      this.status,
      this.createdAt,
      this.updatedAt});

  AppointmentsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientId = json['patient_id'];
    doctorId = json['doctor_id'];
    bookingDay = json['booking_day'];
    bookingDate = json['booking_date'];
    bookingTime = json['booking_time'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['patient_id'] = this.patientId;
    data['doctor_id'] = this.doctorId;
    data['booking_day'] = this.bookingDay;
    data['booking_date'] = this.bookingDate;
    data['booking_time'] = this.bookingTime;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
