class User {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? timeZone;

  User({this.firstName, this.lastName, this.email, this.timeZone});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        firstName: json['first_name'],
        lastName: json['last_name'],
        email: json['email'],
        timeZone: json['time_zone']);
  }
}
