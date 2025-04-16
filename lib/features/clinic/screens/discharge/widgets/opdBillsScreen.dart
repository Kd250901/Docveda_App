import 'package:docveda_app/common/widgets/appbar/appbar.dart';
import 'package:docveda_app/common/widgets/card/patient_card.dart';
import 'package:docveda_app/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:docveda_app/common/widgets/date_switcher_bar/date_switcher_bar.dart';
import 'package:docveda_app/common/widgets/toggle/toggle.dart';
import 'package:docveda_app/common/widgets/primary_button/primary_button.dart';
import 'package:docveda_app/features/clinic/screens/discharge/viewReportScreen.dart';
import 'package:docveda_app/utils/constants/colors.dart';
import 'package:docveda_app/utils/constants/sizes.dart';
import 'package:docveda_app/utils/constants/text_strings.dart';
import 'package:docveda_app/utils/theme/custom_themes/text_style_font.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class Opdbillsscreen extends StatefulWidget {
  const Opdbillsscreen({super.key});

  @override
  _OpdbillsscreenState createState() => _OpdbillsscreenState();
}

class _OpdbillsscreenState extends State<Opdbillsscreen> {
  int selectedPatientIndex = 0;
  //  final ApiService apiService = ApiService();
  // late Future<List<Map<String, dynamic>>> opdbillsData;

  // @override
  // void initState() {
  //   super.initState();
  //  opdbillsData = fetchDashboardData();
  // }

  void handlePatientSelection(int index) {
    setState(() {
      selectedPatientIndex = index;
    });
  }

  // Future<List<Map<String, dynamic>>> fetchDashboardData() async {
  //   final storage = FlutterSecureStorage();
  //   String? accessToken = await storage.read(key: 'accessToken');

  //   if (accessToken != null) {
  //     try {
  //       final response = await apiService.dischargeData(accessToken);

  //       if (response != null && response['statusCode'] == 401) {
  //         WidgetsBinding.instance.addPostFrameCallback((_) {
  //           Get.offAll(() => const LoginScreen());
  //         });
  //         return [];
  //       }

  //       if (response != null && response['data'] != null) {
  //         return List<Map<String, dynamic>>.from(response['data']);
  //       } else {
  //         return [];
  //       }
  //     } catch (e) {
  //       print('Error fetching dashboard data: $e');
  //       return [];
  //     }
  //   } else {
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       Get.offAll(() => const LoginScreen());
  //     });
  //     return [];
  //   }
  // }

  DateTime selectedDate = DateTime.now();
  bool isMonthly = false;

  void _goToPrevious() {
    setState(() {
      selectedDate = isMonthly
          ? DateTime(
              selectedDate.year,
              selectedDate.month - 1,
              selectedDate.day,
            )
          : selectedDate.subtract(const Duration(days: 1));
    });
  }

  void _goToNext() {
    setState(() {
      selectedDate = isMonthly
          ? DateTime(
              selectedDate.year,
              selectedDate.month + 1,
              selectedDate.day,
            )
          : selectedDate.add(const Duration(days: 1));
    });
  }

  void _handleToggle(bool value) {
    setState(() {
      isMonthly = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          /// **Header Section**
          DocvedaPrimaryHeaderContainer(
            child: Column(
              children: [
                DocvedaAppBar(
                  title: Center(
                    child: Text(
                      DocvedaTexts.opdBills,
                      style: TextStyleFont.subheading.copyWith(
                        color: DocvedaColors.white,
                      ),
                    ),
                  ),
                  showBackArrow: true,
                ),
                DocvedaToggle(isMonthly: isMonthly, onToggle: _handleToggle),
                DateSwitcherBar(
                  selectedDate: selectedDate,
                  onPrevious: _goToPrevious,
                  onNext: _goToNext,
                  isMonthly: isMonthly,
                  textColor: DocvedaColors.white,
                  fontSize: DocvedaSizes.fontSizeSm,
                ),
              ],
            ),
          ),

          /// **Patient List and "View Report" Button**
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "6 ${DocvedaTexts.patientFound}",
                    style: TextStyleFont.subheading,
                  ),
                  Text(
                    DocvedaTexts.depositePatientDesc,
                    style: TextStyleFont.body,
                  ),
                  const SizedBox(height: DocvedaSizes.spaceBtwItemsSsm),
                  Expanded(
                    child: ListView.builder(
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
                  ),
                ],
              ),
            ),
          ),

          /// **"View Report" Button at Bottom**
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: DocvedaColors.white,
              boxShadow: [
                BoxShadow(
                  color: DocvedaColors.black.withOpacity(0.1),
                  blurRadius: DocvedaSizes.borderRadiusMd,
                  spreadRadius: DocvedaSizes.spreadRadius,
                ),
              ],
            ),
            child: PrimaryButton(
              text: DocvedaTexts.viewReport,
              backgroundColor: DocvedaColors.primaryColor,
              onPressed: () {
                final selectedPatient = patients[selectedPatientIndex];
                Get.to(
                  () => ViewReportScreen(
                    patientName: selectedPatient["name"],
                    age: selectedPatient["age"],
                    gender: selectedPatient["gender"],
                    admissionDate: selectedPatient["admission"],
                    dischargeDate: selectedPatient["discharge"],
                    finalSettlement: selectedPatient["finalSettlement"],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// **Sample Patient Data**
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
  {
    "name": "Mark Johnson",
    "age": 38,
    "gender": "Male",
    "admission": "2025-03-10",
    "discharge": "2025-03-20",
    "finalSettlement": "Completed",
  },
  {
    "name": "Emily Davis",
    "age": 29,
    "gender": "Female",
    "admission": "2025-04-01",
    "discharge": "2025-04-08",
    "finalSettlement": "Pending",
  },
  {
    "name": "George Miller",
    "age": 60,
    "gender": "Male",
    "admission": "2025-04-12",
    "discharge": "2025-04-22",
    "finalSettlement": "Completed",
  },
  {
    "name": "Rachel Green",
    "age": 33,
    "gender": "Female",
    "admission": "2025-05-01",
    "discharge": "2025-05-09",
    "finalSettlement": "Pending",
  },
];
