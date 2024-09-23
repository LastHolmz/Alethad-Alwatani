// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'user.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
// @JsonSerializable()
@JsonSerializable(explicitToJson: true)
class User {
  final String id;
  final String fullName;
  final String password;
  final UserRole role;
  final UserStatus status;
  final Gender gender;
  final String companyTitle;
  final String? location;
  final int mobile;
  final int componeyMobile;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? token;

  User({
    required this.id,
    required this.fullName,
    required this.password,
    this.role = UserRole.guest,
    this.status = UserStatus.pending,
    this.gender = Gender.man,
    this.token,
    required this.companyTitle,
    this.location,
    required this.mobile,
    required this.componeyMobile,
    required this.createdAt,
    required this.updatedAt,
  });

  static Gender getGenderFromString(String gender) {
    switch (gender.toLowerCase()) {
      case "man":
        return Gender.man;
      case "woman":
        return Gender.woman;
      default:
        return Gender.man;
    }
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

// Enums representing the possible values for each field
enum UserRole { admin, user, guest }

enum UserStatus { pending, active, inactive }

enum Gender {
  man,
  woman,
}
