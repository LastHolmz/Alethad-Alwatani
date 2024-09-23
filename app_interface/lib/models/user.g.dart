// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      password: json['password'] as String,
      role: $enumDecodeNullable(_$UserRoleEnumMap, json['role']) ??
          UserRole.guest,
      status: $enumDecodeNullable(_$UserStatusEnumMap, json['status']) ??
          UserStatus.pending,
      gender:
          $enumDecodeNullable(_$GenderEnumMap, json['gender']) ?? Gender.man,
      token: json['token'] as String?,
      companyTitle: json['companyTitle'] as String,
      location: json['location'] as String?,
      mobile: (json['mobile'] as num).toInt(),
      componeyMobile: (json['componeyMobile'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'password': instance.password,
      'role': _$UserRoleEnumMap[instance.role]!,
      'status': _$UserStatusEnumMap[instance.status]!,
      'gender': _$GenderEnumMap[instance.gender]!,
      'companyTitle': instance.companyTitle,
      'location': instance.location,
      'mobile': instance.mobile,
      'componeyMobile': instance.componeyMobile,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'token': instance.token,
    };

const _$UserRoleEnumMap = {
  UserRole.admin: 'admin',
  UserRole.user: 'user',
  UserRole.guest: 'guest',
};

const _$UserStatusEnumMap = {
  UserStatus.pending: 'pending',
  UserStatus.active: 'active',
  UserStatus.inactive: 'inactive',
};

const _$GenderEnumMap = {
  Gender.man: 'man',
  Gender.woman: 'woman',
};
