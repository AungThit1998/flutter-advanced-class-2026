import 'package:shared_preferences/shared_preferences.dart';
import 'student.dart';

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

  final SharedPreferences sharedPreferences;

  SharedPreferenceStudent({required this.sharedPreferences});

  void saveStudent({required Student student})  {
    sharedPreferences.setString(_name, student.name);
    sharedPreferences.setString(_phone, student.phone);
    sharedPreferences.setString(_password, student.password);
    sharedPreferences.setString(_address, student.address);
    sharedPreferences.setString(_stateRegion, student.stateRegion);
    sharedPreferences.setStringList(_hobbies, student.hobbies);
    sharedPreferences.setString(_gender, student.gender);
    sharedPreferences.setBool(_openForJob, student.openForJob);
  }

  Student getStudent()  {
    return Student(
      name: sharedPreferences.getString(_name) ?? '',
      phone: sharedPreferences.getString(_phone) ?? '',
      password: sharedPreferences.getString(_password) ?? '',
      address: sharedPreferences.getString(_address) ?? '',
      stateRegion: sharedPreferences.getString(_stateRegion) ?? '',
      hobbies: sharedPreferences.getStringList(_hobbies) ?? [],
      gender: sharedPreferences.getString(_gender) ?? '',
      openForJob: sharedPreferences.getBool(_openForJob) ?? false,
    );
  }
  void clear(){
    sharedPreferences.clear();
  }

}
