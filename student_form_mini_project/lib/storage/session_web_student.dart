import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'student.dart';
import 'package:web/web.dart';

class SharedPreferenceStudent {
  final SharedPreferences sharedPreferences;

  SharedPreferenceStudent({required this.sharedPreferences});
  //key
  final String _name = 'name';
  final String _phone = 'phone';
  final String _password = 'password';
  final String _address = 'address';
  final String _stateRegion = 'stateRegion';
  final String _hobbies = 'hobbies';
  final String _gender = 'gender';
  final String _openForJob = 'openForJob';
  final session = window.sessionStorage;
  void saveStudent({required Student student}) {
    session.setItem(_name, student.name);
    session.setItem(_phone, student.phone);
    session.setItem(_password, student.password);
    session.setItem(_address, student.address);
    session.setItem(_stateRegion, student.stateRegion);
    session.setItem(_hobbies, jsonEncode(student.hobbies));
    session.setItem(_gender, student.gender);
    session.setItem(_openForJob, student.openForJob.toString());
  }

  Student getStudent() {
    return Student(
      name: session.getItem(_name) ?? '',
      phone: session.getItem(_phone) ?? '',
      password: session.getItem(_password) ?? '',
      address: session.getItem(_address) ?? '',
      stateRegion: session.getItem(_stateRegion) ?? '',
      hobbies: List.from(jsonDecode(session.getItem(_hobbies) ?? '[]')),
      gender: session.getItem(_gender) ?? '',
      openForJob: session.getItem(_openForJob) == 'true',
    );
  }
  void clear(){
    session.clear();
  }
}
