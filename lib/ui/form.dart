import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/user.dart';

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  String birth = "Date of Birth";
  final _formKey = GlobalKey<FormState>();
  final String _selectedLevel = "2";
  final String _selectedDepartment = "None";
  List<String> departments = ['SE', 'CS', 'IT', 'IS', 'None'];
  List<String> levels = ['1', '2', '3', '4'];
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController levelController = TextEditingController();
  bool edit = true;

  double screenWidth=0;

  double screenHeight=0;
  @override
  void initState() {
    edit = AppUser.canEdit;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     screenHeight = MediaQuery.of(context).size.height;
     screenWidth = MediaQuery.of(context).size.width;

    return edit
        ? Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                textFieldWidget("First Name", firstNameController),
                textFieldWidget("Last Name", lastNameController),
                textFieldWidget("Address", addressController),
                dropdownWidget("Department", departments, _selectedDepartment),
                dropdownWidget("Level", levels, _selectedLevel),
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(8),
                  height: screenHeight / 14,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(2),
                      ),
                      border: Border.all(color: Colors.black54)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(birth),
                      ElevatedButton(
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2025),
                          ).then((pickedDate) {
                            if (pickedDate != null) {
                              setState(() {
                                birth =
                                    DateFormat("MM/dd/yyyy").format(pickedDate);
                              });
                            }
                          });
                        },
                        child: const Text('Select Date'),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: screenWidth / 20),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        saveData();
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          )
        : Container(

      margin: EdgeInsets.all(screenHeight/50),
          decoration: const BoxDecoration(
             // borderRadius: BorderRadius.all(Radius.circular(10),),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(2, 2),
                    blurRadius: 10)
              ]),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            field("First Name", AppUser.firstName),
              field("Last Name", AppUser.lastName),
              field("Address",AppUser.address),
              field("Department",AppUser.department),
              field("Level", AppUser.level),
              field("Birth Date", AppUser.birthDate)

            ],),
        );
  }

  Future<void> saveData() async {
    await FirebaseFirestore.instance
        .collection("students")
        .doc(AppUser.id)
        .update({
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'birthDate': birth,
      'address': addressController.text,
      "department": _selectedDepartment,
      "level": _selectedLevel,
      'canEdit': false,
    }).then((value) {
      setState(() {
        AppUser.canEdit = false;
        AppUser.firstName = firstNameController.text;
        AppUser.lastName = lastNameController.text;
        AppUser.address = addressController.text;
        AppUser.department = _selectedDepartment;
        AppUser.level = _selectedLevel;
        AppUser.birthDate = birth;
      });
    });
  }

  Widget textFieldWidget(String label, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        cursorColor: Colors.black54,
        maxLines: 1,
        decoration: InputDecoration(
          labelText: label,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black54,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black54,
            ),
          ),
        ),
      ),
    );
  }

  Widget dropdownWidget(String label, List<String> items, String selected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black54,
              ),
            ),
            labelText: label),
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        validator: (value) {
          if (value == null) {
            return 'Please select a $label';
          }
          return null;
        },
        onChanged: (String? value) {
          selected = value!;
        },
      ),
    );
  }
  Widget field(String label,String text) {
    return Container(
      height: screenHeight/12,
      // margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only()
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label
              ,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 22,
                fontWeight: FontWeight.bold

              ),
            ),
          ),
          SizedBox(
            height: screenHeight/17,
            width: screenWidth/100,
            child: Container(color: Colors.indigo,),),
          Expanded(
            flex: 1,
            child: Text(
              text
              ,
              textAlign: TextAlign.center,

              style: const TextStyle(
                color: Colors.red,
                fontSize: 22,
fontWeight: FontWeight.bold
              ),
            ),
          ),
        ],
      ),
    );
  }

}
