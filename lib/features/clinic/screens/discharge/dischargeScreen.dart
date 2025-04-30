import 'package:docveda_app/common/widgets/app_text/app_text.dart';
import 'package:docveda_app/common/widgets/appbar/appbar.dart';
import 'package:docveda_app/common/widgets/card/patient_card.dart';
import 'package:docveda_app/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:docveda_app/common/widgets/date_switcher_bar/date_switcher_bar.dart';
import 'package:docveda_app/common/widgets/toggle/toggle.dart';
import 'package:docveda_app/common/widgets/toggle/toggleController.dart';
import 'package:docveda_app/features/authentication/screens/login/login.dart';
import 'package:docveda_app/common/widgets/primary_button/primary_button.dart';
import 'package:docveda_app/features/clinic/screens/viewReportScreen/viewReportScreen.dart';
import 'package:docveda_app/utils/constants/colors.dart';
import 'package:docveda_app/utils/constants/sizes.dart';
import 'package:docveda_app/utils/constants/text_strings.dart';
import 'package:docveda_app/utils/helpers/date_formater.dart';
import 'package:docveda_app/utils/helpers/format_name.dart';
import 'package:docveda_app/utils/theme/custom_themes/text_style_font.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:get/route_manager.dart';
import 'package:docveda_app/features/authentication/screens/login/service/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class Dischargescreen extends StatefulWidget {
  const Dischargescreen({super.key});

  @override
  _DischargescreenState createState() => _DischargescreenState();
}

class _DischargescreenState extends State<Dischargescreen> {
  int selectedPatientIndex = 0;
  final ApiService apiService = ApiService();
  late Future<List<Map<String, dynamic>>> patientData;

  DateTime selectedDate = DateTime.now();
  // bool isMonthly = false;

  @override
  void initState() {
    super.initState();
    loadAdmissionData();
  }

  void handlePatientSelection(int index) {
    setState(() {
      selectedPatientIndex = index;
    });
  }

  void loadAdmissionData() {
    final toggleController =
        Get.find<ToggleController>(); // Access the global toggle state

    setState(() {
      patientData = fetchDashboardData(
        isMonthly: toggleController.isMonthly.value, // Use global toggle state
        pDate: DateFormat('yyyy-MM-dd').format(selectedDate),
        pType: toggleController.isMonthly.value ? 'Monthly' : 'Daily',
      );
    });
  }

  Future<List<Map<String, dynamic>>> fetchDashboardData({
    required bool isMonthly,
    required String pType,
    required String pDate,
  }) async {
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'accessToken');

    if (accessToken != null) {
      try {
        final response = await apiService.getDischargaeData(
          accessToken,
          context,
          isMonthly: isMonthly,
          pDate: pDate,
          pType: pType[0].toUpperCase() + pType.substring(1).toLowerCase(),
        );

        if (response != null && response['statusCode'] == 401) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.offAll(() => const LoginScreen());
          });
          return [];
        }

        if (response != null && response['data'] != null) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          return [];
        }
      } catch (e) {
        print('Error fetching dashboard data: $e');
        return [];
      }
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAll(() => const LoginScreen());
      });
      return [];
    }
  }

  void _goToPrevious() {
    final toggleController = Get.find<ToggleController>();
    setState(() {
      selectedDate = toggleController.isMonthly.value
          ? DateTime(
              selectedDate.year, selectedDate.month - 1, selectedDate.day)
          : selectedDate.subtract(const Duration(days: 1));
    });
    loadAdmissionData();
  }

  void _goToNext() {
    final toggleController = Get.find<ToggleController>();
    setState(() {
      selectedDate = toggleController.isMonthly.value
          ? DateTime(
              selectedDate.year, selectedDate.month + 1, selectedDate.day)
          : selectedDate.add(const Duration(days: 1));
    });
    loadAdmissionData();
  }

  // void _handleToggle(bool value) {
  //   setState(() {
  //     isMonthly = value;
  //   });
  //   loadAdmissionData();
  // }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final toggleController =
        Get.find<ToggleController>(); // Access the controller again

    return Scaffold(
      body: Column(
        children: [
          DocvedaPrimaryHeaderContainer(
            child: Column(
              children: [
                DocvedaAppBar(
                  title: Center(
                    child: DocvedaText(
                      text: DocvedaTexts.discharge,
                      style: TextStyleFont.subheading.copyWith(
                        color: DocvedaColors.white,
                      ),
                    ),
                  ),
                  showBackArrow: true,
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DocvedaToggle(
                          onToggle: (value) {
                            toggleController.isMonthly.value = value;
                            loadAdmissionData(); // or any other action you need
                          },
                        ),
                        DateSwitcherBar(
                          selectedDate: selectedDate,
                          onPrevious: _goToPrevious,
                          onNext: _goToNext,
                          isMonthly: toggleController
                              .isMonthly.value, // Use global state
                          textColor: DocvedaColors.white,
                          fontSize: DocvedaSizes.fontSizeSm,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: patientData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: DocvedaText(text: 'Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child:
                        DocvedaText(text: DocvedaTexts.noDischargePatientFound),
                  );
                }

                final patients = snapshot.data!;

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: DocvedaSizes.spaceBtwItems),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Ensures left alignment
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: DocvedaSizes
                                      .spaceBtwItems), // Add left padding here
                              child: DocvedaText(
                                text:
                                    "${patients.length} ${DocvedaTexts.patientFound}",
                                style: TextStyleFont.subheading,
                              ),
                            ),
                          ),

                          const SizedBox(
                              height: DocvedaSizes
                                  .xs), // Optional space between texts
                          Align(
                              alignment: Alignment
                                  .centerLeft, // Ensures alignment of subtext on the left
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: DocvedaSizes
                                        .spaceBtwItems), // Add left padding here
                                child: DocvedaText(
                                  text: DocvedaTexts.depositePatientDesc,
                                  style: TextStyleFont.body,
                                ),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: DocvedaSizes.spaceBtwItems),
                        itemCount: patients.length,
                        itemBuilder: (context, index) {
                          final patient = patients[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: index == selectedPatientIndex
                                    ? DocvedaColors.primaryColor
                                    : Colors.transparent,
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// 👤 Name and Gender Row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          index == selectedPatientIndex
                                              ? Icons.radio_button_checked
                                              : Icons.radio_button_unchecked,
                                          size: 18,
                                          color: index == selectedPatientIndex
                                              ? DocvedaColors.primaryColor
                                              : Colors.grey,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          formatPatientName(
                                              patient["Patient Name"]
                                                      ?.toString()
                                                      .trim() ??
                                                  "--"),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "${patient["Age"] ?? "--"} • ${patient["Gender"] ?? "--"}",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                /// 📅 Admission & Discharge Dates
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Admission Date",
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          DateFormatter.formatDate(
                                              patient["Admission Date"]),
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Discharge Date",
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          DateFormatter.formatDate(
                                              patient["Discharge Date"]),
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),
                                Divider(color: Colors.grey.shade300),

                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Bill Amount",
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade700),
                                    ),
                                    Text(
                                      "₹${patient["Total IPD Bill"] ?? "0"}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: DocvedaColors.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SafeArea(
                      top: false,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                          vertical: DocvedaSizes.spaceBtwItemsS,
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
                          onPressed: () {
                            if (patients.isEmpty ||
                                selectedPatientIndex >= patients.length) return;

                            final selected = patients[selectedPatientIndex];

                            // Strip the "Y" from the Age string and convert it to an integer
                            String ageString = selected["Age"] ?? "0";
                            int age = 0;

                            // Check if the age string contains 'Y' and remove it
                            if (ageString.contains('Y')) {
                              ageString = ageString.replaceAll('Y', '').trim();
                            }

                            // Parse the age as an integer
                            age = int.tryParse(ageString) ?? 0;

                            print('Age: $age'); // Debugging line

                            Get.to(
                              () => ViewReportScreen(
                                patientName: selected["Patient Name"] ?? "N/A",
                                age: age,
                                gender: selected["Gender"] ?? "N/A",
                                admissionDate: DateFormatter.formatDate(
                                    selected["Admission Date"]),
                                dischargeDate: DateFormatter.formatDate(
                                    selected["Discharge Date"]),
                                finalSettlement:
                                    (selected["Total IPD Bill"] != null)
                                        ? selected["Total IPD Bill"].toString()
                                        : "N/A",
                                screenName: "Discharge",
                              ),
                            );
                          },
                          text: DocvedaTexts.viewReport,
                          backgroundColor: DocvedaColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
