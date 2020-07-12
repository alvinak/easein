import 'package:easein/api/graphql_handler.dart';
import 'package:easein/components/error_alerts.dart';
import 'package:easein/home.dart';
import 'package:easein/porgressIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  var data;
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  TextEditingController _text1 = new TextEditingController();
  TextEditingController _text2 = new TextEditingController();
  TextEditingController _text3 = new TextEditingController();
  TextEditingController _text4 = new TextEditingController();

  final ValueChanged _onChanged = (val) => print(val);
  bool loading = false;

  @override
  void initState() {
    super.initState();
    getPhoneNumber();
  }

  getPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _lph = await prefs.getString('phonenumber');
    setState(() {
      _text3.text = _lph;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: new AppBar(
          title: Text("Update Profile"),
        ),
        body: Stack(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                FormBuilder(
                  key: _fbKey,
                  readOnly: false,
                  child: Column(
                    children: <Widget>[
                      FormBuilderTextField(
                        attribute: 'name',
                        controller: _text1,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                        ),
                        onChanged: _onChanged,
                        valueTransformer: (text) {
                          return text == null ? null : num.tryParse(text);
                        },
                        validators: [
                          FormBuilderValidators.required(),
                          FormBuilderValidators.max(70),
                          FormBuilderValidators.minLength(2, allowEmpty: true),
                        ],
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: 15),
                      FormBuilderTextField(
                        attribute: 'address',
                        controller: _text2,
                        decoration: const InputDecoration(
                          labelText: 'Address',
                        ),
                        onChanged: _onChanged,
                        valueTransformer: (text) {
                          return text == null ? null : num.tryParse(text);
                        },
                        validators: [
                          FormBuilderValidators.required(),
                          FormBuilderValidators.max(300),
                          FormBuilderValidators.minLength(2, allowEmpty: true),
                        ],
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: 30),
                      FormBuilderPhoneField(
                        readOnly: true,
                        attribute: 'phone_number1',
                        controller: _text3,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Phone Number',
                        ),
                        defaultSelectedCountryIsoCode: "IN",
                        priorityListByIsoCode: ['IN'],
                      ),
                      SizedBox(height: 15),
                      FormBuilderTextField(
                        attribute: 'email',
                        controller: _text4,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
                        onChanged: _onChanged,
                        valueTransformer: (text) {
                          return text == null ? null : num.tryParse(text);
                        },
                        validators: [
                          FormBuilderValidators.max(70),
                          FormBuilderValidators.email(),
                        ],
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: MaterialButton(
                        color: Theme.of(context).accentColor,
                        child: Text(
                          'Update',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          setState(() {
                            loading = true;
                          });
                          if (_fbKey.currentState.saveAndValidate()) {
                            print("...validatedd.....");
                            updateProfileAction();
                          } else {
                            setState(() {
                              loading = false;
                            });
                            print("...validatedd. lllllllllllllll....");
//                            print(_fbKey.currentState.value['contact_person']
//                                .runtimeType);
//                            print(_fbKey.currentState.value);
//                            print('validation failed');
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          easeinProgressIndicator(context, loading)
        ]));
  }

  updateProfileAction() async {
    try {
      var result = await updateProfile(
          name: _text1.text, address: _text2.text, email1: _text4.text);

      if (result != null && result["status"] == true) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyHomePage()));
      }
    } catch (e) {
      int errorType = 4;
      if (e.toString().indexOf("Failed host lookup") != -1) {
        errorType = 1;
      } else if (e
              .toString()
              .indexOf("Cannot return null for non-nullable field") !=
          -1) {
        errorType = 2;
      }
      errorAlert(context, errorType);
    }

    setState(() {
      loading = false;
    });
  }
}
