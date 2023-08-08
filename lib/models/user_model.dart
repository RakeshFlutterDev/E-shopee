class UserModel {
  final String? fName;
  final String? lName;
  final String? phone;
  final String? email;

  UserModel({
    this.fName,
    this.lName,
    this.phone,
    this.email
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fName: json['fName'],
      lName: json['lName'],
      phone: json['phone'],
      email: json['email'],
    );
  }
}
