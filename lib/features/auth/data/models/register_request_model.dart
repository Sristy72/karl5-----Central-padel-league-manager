class RegisterRequestModel {
  final String name;
  final String email;
  final String password;
  final String phoneNumber;
  final String role;

  RegisterRequestModel({
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
    this.role = 'manager', // Default role is manager
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'role': role,
    };
  }
}
