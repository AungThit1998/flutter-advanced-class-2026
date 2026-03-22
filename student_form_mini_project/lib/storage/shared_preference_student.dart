import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceStudent {
  //key
  final String _name = 'name';
  final String _phone = 'phone';
  final String _password = 'password';
  final String _address = 'address';
  final String _stateRegion = 'stateRegion';
  final String _hobbies = 'hobbies';
  final String _gender = 'gender';
  final String _openForJob = 'openForJob';


  void saveStudent({
    required String name,
    required String phone,
    required String password,
    required String address,
    required String stateRegion,
    required List<String> hobbies,
    required String gender,
    required bool openForJo,
  }) async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    sharedPreference.setString(_name, name);
    sharedPreference.setString(_phone, phone);
    sharedPreference.setString(_password, password);
    sharedPreference.setString(_address, address);
    sharedPreference.setString(_stateRegion, stateRegion);
    sharedPreference.setStringList(_hobbies, hobbies);
    sharedPreference.setString(_gender, gender);
    sharedPreference.setBool(_openForJob, openForJo);
  }
}
