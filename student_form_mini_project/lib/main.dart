import 'package:flutter/material.dart';
import 'package:student_form_mini_project/storage/shared_preference_student.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.green),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.indigo),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.brown),
          ),
          errorStyle: TextStyle(color: Colors.brown),
        ),
      ),
      home: Home(),
    ),
  );
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? _name, _phone, _password, _address;
  final List<String> _hobbies = [];
  bool _reading = false;
  bool _football = false;
  String _groupValue = '';
  final String _rdoMale = "Male";
  final String _rdoFemale = "Female";
  bool _openForJob = false;
  String? _stateRegion;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final SharedPreferenceStudent _student = SharedPreferenceStudent();

  String _info = '';
  final List<String> _stateRegions = const [
    'Ayeyarwady',
    'Bago',
    'Chin',
    'Kachin',
    'Kayah',
    'Kayin',
    'Magway',
    'Mandalay',
    'Mon',
    'Rakhine',
    'Sagaing',
    'Shan',
    'Tanintharyi',
    'Yangon',
  ];
  @override
  void initState() {
    super.initState();
  }

  //positioned
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stack Lesson')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    validator: (str) {
                      if (str == null || str.trim().isEmpty) {
                        return 'Please Enter Your Name';
                      }
                    },
                    onSaved: (str) {
                      _name = str;
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      labelText: 'Enter your name',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    validator: (str) {
                      if (str == null || str.trim().length < 5) {
                        return 'Please Enter at least 5 number ';
                      }
                    },
                    onSaved: (str) {
                      _phone = str;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Enter you phone number',
                      prefixIcon: Icon(Icons.phone),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    validator: (str) {
                      if (str == null || str.trim().length < 8) {
                        return 'Please Enter at least 8 password';
                      }
                    },
                    onSaved: (str) {
                      _password = str;
                    },
                    obscureText: true,
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.visibility),
                      prefixIcon: Icon(Icons.lock),
                      labelText: 'Enter your password',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    validator: (str) {
                      if (str == null || str.trim().isEmpty) {
                        return 'Please Enter address';
                      }
                    },
                    onSaved: (str) {
                      _address = str;
                    },
                    textAlign: TextAlign.center,
                    maxLines: 6,
                    minLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Enter your address',
                      prefixIcon: Icon(Icons.map_outlined),
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _stateRegion,
                    decoration: const InputDecoration(
                      labelText: 'Select your state/region',
                      prefixIcon: Icon(Icons.location_city),
                    ),
                    items: _stateRegions
                        .map(
                          (state) => DropdownMenuItem(
                        value: state,
                        child: Text(state),
                      ),
                    )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _stateRegion = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please select a state/region';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _stateRegion = value;
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Reading'),
                    value: _reading,
                    onChanged: (bool? isCheck) {
                      setState(() {
                        if (isCheck != null) {
                          _reading = isCheck;
                        }
                      });
                    },
                  ),
                  CheckboxListTile(
                    checkColor: Colors.red,
                    controlAffinity: ListTileControlAffinity.platform,
                    activeColor: Colors.indigo,
                    title: const Text('Football'),
                    value: _football,
                    onChanged: (bool? isCheck) {
                      if (isCheck != null) {
                        setState(() {
                          _football = isCheck;
                        });
                      }
                    },
                  ),
                  RadioGroup<String>(
                    groupValue: _groupValue,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _groupValue = value;
                        });
                      }
                    },
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Male'),
                            Radio(
                              activeColor: Colors.indigo,
                              value: _rdoMale,
                              fillColor: WidgetStateProperty.resolveWith((
                                  states,
                                  ) {
                                if (states.contains(MaterialState.selected)) {
                                  return Colors.indigo;
                                }
                                return Colors.yellow;
                              }),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Female'),
                            Radio(
                              value: _rdoFemale,
                              fillColor: WidgetStateProperty.resolveWith((
                                  states,
                                  ) {
                                if (states.contains(MaterialState.selected)) {
                                  return Colors.indigo;
                                }
                                return Colors.yellow;
                              }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SwitchListTile.adaptive(
                    activeThumbColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                    inactiveTrackColor: Colors.brown,
                    activeThumbImage: AssetImage('images/clock.png'),
                    title: Text('Open for Job'),
                    value: _openForJob,
                    onChanged: (isOpen) {
                      setState(() {
                        _openForJob = isOpen;
                      });
                    },
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _info,
                      style: const TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      if (_formKey.currentState != null) {
                        _formKey.currentState?.save();
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _info =
                            "Name is $_name \n Phone is $_phone\n"
                                "Password is $_password\n"
                                "Address is $_address\n"
                                "State/Region is $_stateRegion\n"
                                "${hobbies()}\n"
                                "Gender is $_groupValue\n"
                                "${_openForJob ? "Open for Job" : ""}";
                          });
                          _student.saveStudent(
                            name: _name ?? '',
                            phone: _phone ?? '',
                            password: _password ?? '',
                            address: _address ?? '',
                            stateRegion: _stateRegion ?? '',
                            hobbies: hobbies().split(","),
                            gender: _groupValue,
                            openForJo: _openForJob,
                          );

                        }
                      }
                    },
                    child: const Text('Generate Profile'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String hobbies() {
    String h = "Hobbies are ";
    if (_reading) {
      h = "$h Reading,";
    }
    if (_football) {
      h = "$h Football";
    }
    return h;
  }
}