import 'package:docveda_app/common/widgets/card/patient_card.dart';
import 'package:docveda_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';

List<Map<String, dynamic>> patients = [
  {
    "name": "John Doe",
    "age": 45,
    "gender": "Male",
    "admission": "2025-01-01",
    "discharge": "2025-01-10",
    "finalSettlement": "Pending",
  },
  {
    "name": "Jane Smith",
    "age": 50,
    "gender": "Female",
    "admission": "2025-02-01",
    "discharge": "2025-02-12",
    "finalSettlement": "Completed",
  },
];

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  _PatientListScreenState createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  int selectedPatientIndex = -1;

  void handlePatientSelection(int index) {
    setState(() {
      selectedPatientIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Patients", style: TextStyle(color: Colors.white)),
        backgroundColor: DocvedaColors.primaryColor,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: patients.length,
        itemBuilder: (context, index) {
          return PatientCard(
            patient: patients[index],
            index: index,
            selectedPatientIndex: selectedPatientIndex,
            onPatientSelected: handlePatientSelection,
          );
        },
      ),
    );
  }
}
