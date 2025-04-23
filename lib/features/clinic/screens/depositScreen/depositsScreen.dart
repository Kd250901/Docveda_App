import 'package:docveda_app/common/widgets/appbar/appbar.dart';
import 'package:docveda_app/common/widgets/card/patient_card.dart';
import 'package:docveda_app/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:docveda_app/common/widgets/date_switcher_bar/date_switcher_bar.dart';
import 'package:docveda_app/common/widgets/toggle/toggle.dart';
import 'package:docveda_app/common/widgets/primary_button/primary_button.dart';
import 'package:docveda_app/features/clinic/screens/viewReportScreen/viewReportScreen.dart';
import 'package:docveda_app/utils/constants/colors.dart';
import 'package:docveda_app/utils/constants/sizes.dart';
import 'package:docveda_app/utils/constants/text_strings.dart';
import 'package:docveda_app/utils/theme/custom_themes/text_style_font.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class Depositsscreen extends StatefulWidget {
  const Depositsscreen({super.key});

  @override
  _DepositsscreenState createState() => _DepositsscreenState();
}

class _DepositsscreenState extends State<Depositsscreen> {
  int selectedPatientIndex = 0;
  // final ApiService apiService = ApiService();
  // late Future<List<Map<String, dynamic>>> patientData;

  // @override
  // void initState() {
  //   super.initState();
  //   patientData = fetchDashboardData();
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

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            /// **Fixed Header Section**
            DocvedaPrimaryHeaderContainer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DocvedaAppBar(
                    title: Center(
                      child: Text(
                        DocvedaTexts.deposits,
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

            /// **Patient List and View Report Button**
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("6 ${DocvedaTexts.patientFound}",
                        style: TextStyleFont.subheading),
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

            /// **Fixed "View Report" Button at Bottom**
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: DocvedaSizes.cardRadiusSm,
              ),
              decoration: BoxDecoration(
                color: DocvedaColors.white,
                boxShadow: [
                  BoxShadow(
                    color: DocvedaColors.black.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: PrimaryButton(
                text: DocvedaTexts.viewReport,
                backgroundColor: DocvedaColors.primaryColor,
                onPressed: () {
                  Get.to(
                    () => ViewReportScreen(
                      patientName: patients[selectedPatientIndex]["name"],
                      age: patients[selectedPatientIndex]["age"],
                      gender: patients[selectedPatientIndex]["gender"],
                      admissionDate: patients[selectedPatientIndex]
                          ["admission"],
                      dischargeDate: patients[selectedPatientIndex]
                          ["discharge"],
                      finalSettlement: patients[selectedPatientIndex]
                          ["finalSettlement"],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
