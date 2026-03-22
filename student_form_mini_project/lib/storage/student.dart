class Student {
  final String name;
  final String phone;
  final String password;
  final String address;
  final String stateRegion;
  final List<String> hobbies;
  final String gender;
  final bool openForJob;

  @override
  String toString() {
    return 'Student{name: $name, phone: $phone, password: $password, address: $address, stateRegion: $stateRegion, hobbies: $hobbies, gender: $gender, openForJo: $openForJob}';
  }

  Student({
    required this.name,
    required this.phone,
    required this.password,
    required this.address,
    required this.stateRegion,
    required this.hobbies,
    required this.gender,
    required this.openForJob,
  });
}
