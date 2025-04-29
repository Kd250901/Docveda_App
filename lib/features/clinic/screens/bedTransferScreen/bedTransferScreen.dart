import 'package:docveda_app/common/widgets/app_text/app_text.dart';
import 'package:docveda_app/common/widgets/appbar/appbar.dart';
import 'package:docveda_app/common/widgets/card/bed_transfer_card.dart';
import 'package:docveda_app/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:docveda_app/common/widgets/date_switcher_bar/date_switcher_bar.dart';
import 'package:docveda_app/common/widgets/toggle/toggle.dart';
import 'package:docveda_app/common/widgets/primary_button/primary_button.dart';
import 'package:docveda_app/features/authentication/screens/login/service/api_service.dart';
import 'package:docveda_app/features/clinic/screens/viewReportScreen/viewReportScreen.dart';
import 'package:docveda_app/utils/constants/colors.dart';
import 'package:docveda_app/utils/constants/sizes.dart';
import 'package:docveda_app/utils/constants/text_strings.dart';
import 'package:docveda_app/utils/helpers/date_formater.dart';
import 'package:docveda_app/utils/theme/custom_themes/text_style_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BedTransferScreen extends StatefulWidget {
  const BedTransferScreen({super.key});

  @override
  State<BedTransferScreen> createState() => _BedTransferScreenState();
}

class _BedTransferScreenState extends State<BedTransferScreen> {
  final ApiService apiService = ApiService();
  int selectedPatientIndex = 0;
  late Future<List<Map<String, dynamic>>> bedTransferData;

  DateTime selectedDate = DateTime.now();
  bool isMonthly = false;

  @override
  void initState() {
    super.initState();
    loadBedTransferData();
  }

  void handlePatientSelection(int index) {
    setState(() {
      selectedPatientIndex = index;
    });
  }

  void loadBedTransferData() {
    setState(() {
      bedTransferData = fetchBedTransferData(
        isMonthly: isMonthly,
        pDate: DateFormat('yyyy-MM-dd').format(selectedDate),
        pType: isMonthly ? 'Monthly' : 'Daily',
      );
    });
  }

  Future<List<Map<String, dynamic>>> fetchBedTransferData({
    required bool isMonthly,
    required String pType,
    required String pDate,
  }) async {
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'accessToken');

    if (accessToken != null) {
      try {
        final response = await apiService.getBedTransfer(
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
        print('Error fetching bed transfer data: $e');
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
    loadBedTransferData();
  }

  void _goToNext() {
    setState(() {
      selectedDate = isMonthly
          ? DateTime(
              selectedDate.year, selectedDate.month + 1, selectedDate.day)
          : selectedDate.add(const Duration(days: 1));
    });
    loadBedTransferData();
  }

  void _handleToggle(bool value) {
    setState(() {
      isMonthly = value;
    });
    loadBedTransferData();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          /// Header
          DocvedaPrimaryHeaderContainer(
            child: Column(
              children: [
                DocvedaAppBar(
                  title: Center(
                    child: DocvedaText(
                      text: DocvedaTexts.bedTransfer,
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

          /// Dynamic Content
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: bedTransferData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: DocvedaText(text: 'Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: DocvedaText(text: DocvedaTexts.noPatientFound),
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
                                text: "${patients.length} deposits found",
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
                                  text: "Patients with advance deposits made.",
                                  style: TextStyleFont.body,
                                ),
                              )),
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
                          return BedTransferCard(
                            index: index,
                            selectedPatientIndex: selectedPatientIndex,
                            onPatientSelected: handlePatientSelection,
                            patient:
                                patient, // Pass the entire patient map here
                          );
                        },
                      ),
                    ),

                    /// View Report Button (Sticky to bottom)
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

                          // Parse age from "29Y"
                          String ageString = selected["Age"] ?? "0";
                          int age = 0;
                          if (ageString.contains('Y')) {
                            ageString = ageString.replaceAll('Y', '').trim();
                          }
                          age = int.tryParse(ageString) ?? 0;

                          Get.to(
                            () => ViewReportScreen(
                              patientName: selected["Patient Name"] ?? "N/A",
                              age: age,
                              gender: selected["Gender"] ?? "N/A",
                              admissionDate: DateFormatter.formatDate(
                                  selected["Admission Date"]),
                              dischargeDate: DateFormatter.formatDate(
                                  selected["Bed_End_Date"]), // <-- FIXED
                              finalSettlement:
                                  (selected["Total IPD Bill"] != null)
                                      ? selected["Total IPD Bill"].toString()
                                      : "N/A",
                              screenName: "Admission",
                            ),
                          );
                        },
                        text: DocvedaTexts.viewReport,
                        backgroundColor: DocvedaColors.primaryColor,
                      ),
                    )
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
