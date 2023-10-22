import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';



void main() {
  runApp(MyApp());
}

class Patient {//Clase Paciente con sus atributos
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
//Página de inicio
class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://media.istockphoto.com/id/1352429166/es/vector/los-iconos-de-exoesqueleto-establecen-el-vector-de-contorno-cuerpo-cibern%C3%A9tico-artificial.jpg?s=612x612&w=0&k=20&c=Gup7W5SVm2e8618f2Daxo9-7POK7RjZVCmMEOFb1cSc='),
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
                  fontFamily: 'Nunito',
                  fontSize: 40,
                  color: Colors.lightBlueAccent[100],
                  backgroundColor: Colors.white,
                  fontWeight: FontWeight.bold,

                ),
              ),
              SizedBox(height: 45),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/main');
                },
                child: Text(
                  'Start',
                  style: TextStyle(fontFamily: 'Nunito',fontSize: 25, color: Colors.lightBlue, fontWeight: FontWeight.bold,letterSpacing:6,)
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
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
//Página de inicio
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Patient> patientList = [];
  List<Patient> filteredPatients = []; // Define filteredPatients here
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  Gender? selectedGender;
  int selectedPatientIndex = -1;
  String searchQuery = '';
  Widget emptyListMessage = Text("The patient list is empty");

  @override
  void initState() {
    // Inicializar la lista de pacientes con 3 mocks
    super.initState();
    patientList = [
      Patient(name: 'John Doe', dateOfBirth: DateTime(1980, 5, 15), gender: Gender.male),
      Patient(name: 'Jane Smith', dateOfBirth: DateTime(1992, 8, 23), gender: Gender.female),
      Patient(name: 'Pepe Ramirez', dateOfBirth: DateTime(1986, 3, 11), gender: Gender.male),
    ];
    filteredPatients = patientList;
  }

  void filterPatients() {
    //Método para filtrar la lista de pacientes, pudiendo así realizar búsquedas en ella
    if (searchQuery.isEmpty) {
      filteredPatients = patientList.toList();
    } else {
      setState(() {
        filteredPatients = patientList.where((patient) {
          final name = patient.name.toLowerCase();
          return name.contains(searchQuery.toLowerCase());
        }).toList();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    //Scaffold define el layout de la página principal, es decir, la barra superior y el cuerpo de la página)
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hi, Welcome!',
          style: TextStyle(
            color: Colors.white,fontFamily: 'Nunito',
              letterSpacing: 3.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black38,
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
          SizedBox(height: 30), // Define la separación vertical entre la barra superior y el título
          Text(
            'Patient List',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 35,
              color: Colors.black54,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 15),
          Center(
            child: Padding( // Margen de separación entre el texto explicativo y los bordes de la pantalla
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                'Below, you can find the complete list of all registered patients. Select one to view more details or perform specific actions.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[400],
                  letterSpacing: 2.5,
                ),
              ),
            ),
          ),

          // Barra de búsqueda de pacientes
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.5),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black38, width: 1.6),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Search Patients',
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        border: InputBorder.none,
                      ),
                      onChanged: (query) {
                        setState(() {
                          searchQuery = query;
                          filterPatients();
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 50.0,
                  height: 90.0,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black45,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.search, color: Colors.white),
                      onPressed: () {
                        //
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            //Permite obtener y mostrar la lista filtrada de pacientes
            child: filteredPatients.isEmpty
                ? Center(
              child: searchQuery.isNotEmpty
                  ? Text("There are no patients with that name")
                  : emptyListMessage,
            ): ListView.builder(
              itemCount: filteredPatients.length,
              itemBuilder: (context, index) {
                final patient = filteredPatients[index];
                return ListTile(
                  title: Text(patient.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily:'Nunito',
                      color: Colors.blue[600],
                      letterSpacing: 0.5,
                    ),
                  ),
                  subtitle: Text(
                    '${patient.dateOfBirth.toString().split(' ')[0]}, ${patient.gender == Gender.male ? 'Male' : 'Female'}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily:'Nunito',
                      letterSpacing: 2,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.lightBlueAccent),
                        onPressed: () {
                          _showEditPatientDialog(context, patientList.indexOf(patient));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          _deletePatient(patientList.indexOf(patient));
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
        //Al clickar, permite añadir pacientes
        onPressed: () {
          _showAddPatientDialog(context);
        },
        backgroundColor: Colors.black45,
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddPatientDialog(BuildContext context) {
    //Método que permite al usuario crear nuevos pacientes
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
    //Método que permite ediat los pacientes de la lista
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
    //Permite al usuario seleccionar una fecha
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
    //Método que permite eliminar pacientes de la lista
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
