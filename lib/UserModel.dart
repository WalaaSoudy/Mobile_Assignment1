class UserModel {
  final String name;
  final String? gender;
  final String email;
  final String studentID;
  final int? level;
  final String password;
  final String? imagePath; // Add this field for storing the image path

  UserModel({
    required this.name,
    this.gender,
    required this.email,
    required this.studentID,
    this.level,
    required this.password,
    this.imagePath, // Update the constructor to include this field
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'gender': gender,
      'email': email,
      'student_id': studentID,
      'level': level,
      'password': password,
      'image_path': imagePath, // Add the image path to the map
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'],
      gender: map['gender'],
      email: map['email'],
      studentID: map['student_id'],
      level: map['level'],
      password: map['password'],
      imagePath: map['image_path'], // Initialize the imagePath field
    );
  }
}
