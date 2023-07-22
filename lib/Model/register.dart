import 'dart:ffi';

class Resgister {
  late int id;
  late String name;
  late String email;
  late String password;

  Resgister(this.id, this.name, this.email, this.password);

  Resgister.fromjson(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.email = map['email'];
    this.password = map['password'];
  }
}
