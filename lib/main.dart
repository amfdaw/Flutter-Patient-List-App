import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Patient {
  String name;
  DateTime dateOfBirth;
  Gender gender;

  Patient({required this.name, required this.dateOfBirth, required this.gender});
}

enum Gender { male, female }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => StartPage(),
        '/main': (context) => MainPage(),
      },
    );
  }
}

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://www.mouser.mx/blog/Portals/11/Analog_Exoskeletons%20Mobility%20Solutions%20Theme%20Image.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/main');
                },
                child: Text(
                  'Start',
                  style: TextStyle(fontSize: 18, color: Colors.blue),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Patient> patientList = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  Gender? selectedGender;
  int selectedPatientIndex = -1; // To track the selected patient for editing

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hi, Welcome!',
          style: TextStyle(
            color: Colors.blueGrey,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 20), // Adjust the height for desired separation
          Text(
            'Patient List',
            style: TextStyle(
              fontSize: 35,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 20), // Vertical separation from the "Patient List" text
          Center(
            child: Padding( // Add left margin separation
              padding: EdgeInsets.symmetric(horizontal: 25.0), // Adjust the margin as needed
              child: Text(
                'Below, you can find the complete list of all registered patients. Select one to view more details or perform specific actions.',
                style: TextStyle(
                  fontSize: 12, // 1/3 of the font size of "Patient List"
                  color: Colors.grey[400], // Light grey color
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), // Adjust the border radius as needed
                    border: Border.all(color: Colors.blueGrey, width: 1.6), // Border styling
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Search Patients',
                      contentPadding: EdgeInsets.symmetric(horizontal: 20), // Adjust the padding as needed
                      border: InputBorder.none, // Remove the default border

                    ),
                    onChanged: (query) {
                      // Implement your search functionality here
                      // You can filter the patientList based on the search query
                      // and update the displayed list accordingly
                    },
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueGrey,
                ),
                child: IconButton(
                  icon: Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    // Clear the search query
                    // You can update the displayed list accordingly
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: patientList.length,
              itemBuilder: (context, index) {
                final patient = patientList[index];
                return ListTile(
                  title: Text(patient.name),
                  subtitle: Text('${patient.dateOfBirth.toString().split(' ')[0]}, ${patient.gender == Gender.male ? 'Male' : 'Female'}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _showEditPatientDialog(context, index);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deletePatient(index);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddPatientDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddPatientDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add a new patient'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: dateController,
                decoration: InputDecoration(labelText: 'Date of Birth'),
                readOnly: true,
                onTap: () {
                  _selectDate(context);
                },
              ),
              Text('Gender'),
              Row(
                children: [
                  Radio<Gender>(
                    value: Gender.male,
                    groupValue: selectedGender,
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value;
                      });
                    },
                  ),
                  Text('Male'),
                  Radio<Gender>(
                    value: Gender.female,
                    groupValue: selectedGender,
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value;
                      });
                    },
                  ),
                  Text('Female'),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && dateController.text.isNotEmpty && selectedGender != null) {
                  final newPatient = Patient(
                    name: nameController.text,
                    dateOfBirth: DateTime.parse(dateController.text),
                    gender: selectedGender!,
                  );
                  setState(() {
                    patientList.add(newPatient);
                  });
                  nameController.clear();
                  dateController.clear();
                  selectedGender = null;
                  Navigator.of(context).pop();
                  _showConfirmationDialog(context, 'Patient added');
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditPatientDialog(BuildContext context, int index) {
    selectedPatientIndex = index;
    final patient = patientList[index];
    nameController.text = patient.name;
    dateController.text = patient.dateOfBirth.toIso8601String();
    selectedGender = patient.gender;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit patient'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: dateController,
                decoration: InputDecoration(labelText: 'Date of Birth'),
                readOnly: true,
                onTap: () {
                  _selectDate(context);
                },
              ),
              Text('Gender'),
              Row(
                children: [
                  Radio<Gender>(
                    value: Gender.male,
                    groupValue: selectedGender,
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value;
                      });
                    },
                  ),
                  Text('Male'),
                  Radio<Gender>(
                    value: Gender.female,
                    groupValue: selectedGender,
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value;
                      });
                    },
                  ),
                  Text('Female'),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (selectedPatientIndex != -1) {
                  if (nameController.text.isNotEmpty && dateController.text.isNotEmpty && selectedGender != null) {
                    final updatedPatient = Patient(
                      name: nameController.text,
                      dateOfBirth: DateTime.parse(dateController.text),
                      gender: selectedGender!,
                    );
                    setState(() {
                      patientList[selectedPatientIndex] = updatedPatient;
                    });
                    nameController.clear();
                    dateController.clear();
                    selectedGender = null;
                    selectedPatientIndex = -1;
                    Navigator.of(context).pop();
                    _showConfirmationDialog(context, 'Patient edited');
                  }
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        dateController.text = picked.toIso8601String();
      });
    }
  }

  void _deletePatient(int index) {
    setState(() {
      patientList.removeAt(index);
    });
    _showConfirmationDialog(context, 'Patient deleted');
  }

  void _showConfirmationDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Accept'),
            ),
          ],
        );
      },
    );
  }
}
