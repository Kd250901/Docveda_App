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

class Ipdsettlementsscreen extends StatefulWidget {
  const Ipdsettlementsscreen({super.key});

  @override
  _IpdsettlementsscreenState createState() => _IpdsettlementsscreenState();
}

class _IpdsettlementsscreenState extends State<Ipdsettlementsscreen> {
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
              selectedDate.year, selectedDate.month - 1, selectedDate.day)
          : selectedDate.subtract(const Duration(days: 1));
    });
  }

  void _goToNext() {
    setState(() {
      selectedDate = isMonthly
          ? DateTime(
              selectedDate.year, selectedDate.month + 1, selectedDate.day)
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
                      DocvedaTexts.ipdSettlement,
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
            child: Column(
              children: [
                /// **Patient List Section**
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: DocvedaSizes.spaceBtwItems),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${patients.length} ${DocvedaTexts.patientFound}",
                          style: TextStyleFont.subheading,
                        ),
                        Text(
                          DocvedaTexts.depositePatientDesc,
                          style: TextStyleFont.body,
                        ),
                        const SizedBox(height: DocvedaSizes.spaceBtwItemsSsm),

                        /// **Scrollable List of Patient Cards**
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
                SafeArea(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: DocvedaSizes.cardRadiusSm,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: DocvedaColors.black.withOpacity(0.1),
                          blurRadius: DocvedaSizes.borderRadiusMd,
                          spreadRadius: DocvedaSizes.spreadRadius,
                        ),
                      ],
                    ),
                    child: PrimaryButton(
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
                      text: DocvedaTexts.viewReport,
                      backgroundColor: DocvedaColors.primaryColor,
                    ),
                  ),
                ),
              ],
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
    "name": "Michael Johnson",
    "age": 60,
    "gender": "Male",
    "admission": "2025-03-01",
    "discharge": "2025-03-15",
    "finalSettlement": "Completed",
  },
  {
    "name": "Emily Davis",
    "age": 38,
    "gender": "Female",
    "admission": "2025-04-01",
    "discharge": "2025-04-10",
    "finalSettlement": "Pending",
  },
  {
    "name": "Robert Brown",
    "age": 70,
    "gender": "Male",
    "admission": "2025-04-05",
    "discharge": "2025-04-20",
    "finalSettlement": "Completed",
  },
  {
    "name": "Laura Wilson",
    "age": 29,
    "gender": "Female",
    "admission": "2025-04-08",
    "discharge": "2025-04-18",
    "finalSettlement": "Pending",
  },
];
