class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String mobile;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.mobile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        fullName: json['fullName'] as String,
        email: json['email'] as String,
        mobile: json['mobile'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'email': email,
        'mobile': mobile,
      };
}
