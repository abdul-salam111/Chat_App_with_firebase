class RegistrationModal {
  String? id;
  String? displayName;
  String? lastName;
  String? email;
  String? password;
  String? confirmPassword;
  RegistrationModal(
      {this.id,
      this.displayName,
      this.lastName,
      this.email,
      this.password,
      this.confirmPassword});
  factory RegistrationModal.fromMap(Map<String, dynamic> json) {
    return RegistrationModal(
      id: json['id'],
      displayName: json['displayName'],
      lastName: json['lastName'],
      email: json['email'],
      password: json['password'],
      confirmPassword: json['confirmPassword'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'displayName': displayName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      "status": "online"
    };
  }
}
