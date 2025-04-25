import 'package:docveda_app/common/widgets/app_text/app_text.dart';
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
import 'package:docveda_app/utils/helpers/date_formater.dart';
import 'package:docveda_app/utils/theme/custom_themes/text_style_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/route_manager.dart';
import 'package:docveda_app/features/authentication/screens/login/service/api_service.dart';
import 'package:intl/intl.dart';

class DepositScreen extends StatefulWidget {
  const DepositScreen({super.key});

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final ApiService apiService = ApiService();
  int selectedPatientIndex = 0;
  late Future<List<Map<String, dynamic>>> patientData;

  DateTime selectedDate = DateTime.now();
  bool isMonthly = false;

  @override
  void initState() {
    super.initState();
    loadDepositData();
  }

  void handlePatientSelection(int index) {
    setState(() {
      selectedPatientIndex = index;
    });
  }

  void loadDepositData() {
    setState(() {
      patientData = fetchDashboardData(
        isMonthly: isMonthly,
        pDate: DateFormat('yyyy-MM-dd').format(selectedDate),
        pType: isMonthly ? 'Monthly' : 'Daily',
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
        final response = await apiService.getDepositData(
          accessToken,
          context,
          isMonthly: isMonthly,
          pDate: pDate,
          pType: pType[0].toUpperCase() + pType.substring(1).toLowerCase(),
        );

        if (response != null && response['data'] != null) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          print('Invalid data format or missing "data" field.');
          return [];
        }
      } catch (e) {
        print('Error fetching deposit data: $e');
        return [];
      }
    } else {
      print('Access token is null. Please login.');
      return [];
    }
  }

  void _goToPrevious() {
    setState(() {
      selectedDate = isMonthly
          ? DateTime(
              selectedDate.year, selectedDate.month - 1, selectedDate.day)
          : selectedDate.subtract(const Duration(days: 1));
    });
    loadDepositData();
  }

  void _goToNext() {
    setState(() {
      selectedDate = isMonthly
          ? DateTime(
              selectedDate.year, selectedDate.month + 1, selectedDate.day)
          : selectedDate.add(const Duration(days: 1));
    });
    loadDepositData();
  }

  void _handleToggle(bool value) {
    setState(() {
      isMonthly = value;
    });
    loadDepositData();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          DocvedaPrimaryHeaderContainer(
            child: Column(
              children: [
                DocvedaAppBar(
                  title: Center(
                    child: DocvedaText(
                      text: "Deposits",
                      style: TextStyleFont.subheading
                          .copyWith(color: DocvedaColors.white),
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
                  fontSize: 14,
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
                      child: DocvedaText(text: "No deposit data found."));
                }

                final patients = snapshot.data!;

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: DocvedaSizes.spaceBtwItems),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DocvedaText(
                            text: "${patients.length} deposits found",
                            style: TextStyleFont.subheading,
                          ),
                          DocvedaText(
                            text: "Patients with advance deposits made.",
                            style: TextStyleFont.body,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: DocvedaSizes.spaceBtwItemsSsm),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: DocvedaSizes.spaceBtwItems),
                        itemCount: patients.length,
                        itemBuilder: (context, index) {
                          final patient = patients[index];
                          return PatientCard(
                            index: index,
                            selectedPatientIndex: selectedPatientIndex,
                            onPatientSelected: handlePatientSelection,

                            /// 👤 Top Row: Name, Age, Gender
                            topRow: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      index == selectedPatientIndex
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_unchecked,
                                      size: 16,
                                      color: index == selectedPatientIndex
                                          ? DocvedaColors.primaryColor
                                          : Colors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    DocvedaText(
                                      text: "${patient["Patient Name"] ?? ""}"
                                          .trim(),
                                      style: TextStyleFont.body.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                DocvedaText(
                                  text:
                                      "${patient["Age"]?.toString() ?? "--"} Yrs • ${patient["Gender"] ?? "--"}",
                                  style: TextStyleFont.caption.copyWith(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ],
                            ),

                            /// 📅 Middle Row: Admission & Discharge
                            middleRow: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DocvedaText(
                                      text: "ADMISSION",
                                      style: TextStyleFont.caption
                                          .copyWith(color: Colors.grey),
                                    ),
                                    const SizedBox(height: 4),
                                    DocvedaText(
                                      text: DateFormatter.formatDate(
                                              patient["Admission Date"]) ??
                                          "N/A",
                                      style: TextStyleFont.caption,
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    DocvedaText(
                                      text: "UHID No",
                                      style: TextStyleFont.caption
                                          .copyWith(color: Colors.grey),
                                    ),
                                    const SizedBox(height: 4),
                                    DocvedaText(
                                      text:
                                          "₹${patient["UHID No"]?.toString() ?? "0"}",
                                      style: TextStyleFont.caption,
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            /// 💵 Bottom Row: Final Settlement
                            bottomRow: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  DocvedaText(
                                    text: "Deposite",
                                    style: TextStyleFont.caption
                                        .copyWith(color: Colors.grey),
                                  ),
                                  DocvedaText(
                                    text:
                                        "₹${patient["Deposite"]?.toString() ?? "0"}",
                                    style: TextStyleFont.body.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
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
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: PrimaryButton(
                        onPressed: () {
                          if (patients.isEmpty ||
                              selectedPatientIndex >= patients.length) return;

                          final selected = patients[selectedPatientIndex];
                          Get.to(
                            () => ViewReportScreen(
                              patientName: "${selected["Patient_Name"] ?? ''}",
                              age:
                                  int.tryParse(selected["Age"].toString()) ?? 0,
                              gender: selected["Gender"] ?? "N/A",
                              admissionDate: DateFormatter.formatDate(
                                      selected["Admission Date"]) ??
                                  "N/A",
                              dischargeDate: DateFormatter.formatDate(
                                      selected["Discharge Date"]) ??
                                  "N/A",
                              finalSettlement:
                                  selected["Deposit"]?.toString() ?? "N/A",
                              screenName: "Deposit",
                            ),
                          );
                        },
                        text: DocvedaTexts.viewReport,
                        backgroundColor: DocvedaColors.primaryColor,
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
