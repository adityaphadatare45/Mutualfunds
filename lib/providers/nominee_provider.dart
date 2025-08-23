import 'package:flutter/material.dart';

class Nominee {
  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final allocationController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final pincodeController = TextEditingController();

  String? identityType;
  String? relation;
  String? countryCode;
  String? state;
  String? city;
  DateTime? dob;
}
