import 'package:docveda_app/common/widgets/card/bed_transfer_card.dart';
import 'package:docveda_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BedTransferScreen extends StatefulWidget {
  const BedTransferScreen({super.key});

  @override
  State<BedTransferScreen> createState() => _BedTransferScreenState();
}

class _BedTransferScreenState extends State<BedTransferScreen> {
  int selectedPatientIndex = -1;

  final List<Map<String, dynamic>> patientList = [
    {
      "name": "Amit Sharma",
      "age": "45Y",
      "gender": "Male",
      "fromBed": "101A",
      "toBed": "203B",
      "dateTime": "2025-04-28T16:45:00"
    },
    {
      "name": "Neha Verma",
      "age": "30Y",
      "gender": "Female",
      "fromBed": "102C",
      "toBed": "301A",
      "dateTime": "2025-04-29T09:15:00"
    },
    {
      "name": "Ravi Kumar",
      "age": "60Y",
      "gender": "Male",
      "fromBed": "150B",
      "toBed": "101A",
      "dateTime": "2025-05-01T14:00:00"
    },
    {
      "name": "Priya Joshi",
      "age": "40Y",
      "gender": "Female",
      "fromBed": "202D",
      "toBed": "303C",
      "dateTime": "2025-05-02T10:30:00"
    },
    {
      "name": "Kiran Yadav",
      "age": "25Y",
      "gender": "Female",
      "fromBed": "120B",
      "toBed": "305D",
      "dateTime": "2025-06-10T18:30:00"
    },
    {
      "name": "Manoj Singh",
      "age": "50Y",
      "gender": "Male",
      "fromBed": "110A",
      "toBed": "209C",
      "dateTime": "2025-06-10T18:30:00"
    }
  ];

  void onPatientSelected(int index) {
    setState(() {
      selectedPatientIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    // Set status bar color
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: DocvedaColors.primaryColor,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// --- Standard AppBar like ForgotPassword ---
      appBar: AppBar(
        title: const Text(
          "Bed Transfer",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: DocvedaColors.primaryColor,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SafeArea(
        child: ListView.builder(
          itemCount: patientList.length,
          padding: const EdgeInsets.only(top: 8, bottom: 32),
          itemBuilder: (context, index) {
            return BedTransferCard(
              patient: patientList[index],
              index: index,
              selectedPatientIndex: selectedPatientIndex,
              onPatientSelected: onPatientSelected,
            );
          },
        ),
      ),
    );
  }
}
