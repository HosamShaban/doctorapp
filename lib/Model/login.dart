class Login {
  late int id;
  late String email;
  late String password;

  Login(this.id, this.email, this.password);

  Login.fromjson(Map<String, dynamic> map) {
    this.id = map['id'];
    this.email = map['email'];
    this.password = map['password'];
  }
}
