import 'package:docveda_app/common/widgets/app_text/app_text.dart';
import 'package:docveda_app/common/widgets/appbar/appbar.dart';
import 'package:docveda_app/common/widgets/card/patient_card.dart';
import 'package:docveda_app/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:docveda_app/common/widgets/date_switcher_bar/date_switcher_bar.dart';
import 'package:docveda_app/common/widgets/toggle/toggle.dart';
import 'package:docveda_app/common/widgets/primary_button/primary_button.dart';
import 'package:docveda_app/common/widgets/toggle/toggleController.dart';
import 'package:docveda_app/features/clinic/screens/viewReportScreen/viewReportScreen.dart';
import 'package:docveda_app/utils/constants/colors.dart';
import 'package:docveda_app/utils/constants/sizes.dart';
import 'package:docveda_app/utils/constants/text_strings.dart';
import 'package:docveda_app/utils/helpers/date_formater.dart';
import 'package:docveda_app/utils/helpers/format_amount.dart';
import 'package:docveda_app/utils/helpers/format_name.dart';
import 'package:docveda_app/utils/theme/custom_themes/text_style_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
//import 'package:get/route_manager.dart';
import 'package:docveda_app/features/authentication/screens/login/service/api_service.dart';
import 'package:intl/intl.dart';

class IPDSettlementScreen extends StatefulWidget {
  final bool isSelectedMonthly;
  final DateTime prevSelectedDate;

  const IPDSettlementScreen(
      {super.key,
      required this.isSelectedMonthly,
      required this.prevSelectedDate});

  @override
  State<IPDSettlementScreen> createState() => _IPDSettlementScreenState();
}

class _IPDSettlementScreenState extends State<IPDSettlementScreen> {
  final ApiService apiService = ApiService();
  int selectedPatientIndex = 0;
  late Future<List<Map<String, dynamic>>> patientData;

  DateTime selectedDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  bool isMonthly = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.prevSelectedDate;
    isMonthly = widget.isSelectedMonthly;
    loadIPDSettlementData();
  }

  void handlePatientSelection(int index) {
    setState(() {
      selectedPatientIndex = index;
    });
  }

  void loadIPDSettlementData() {
    final toggleController = Get.find<ToggleController>();
    setState(() {
      final isMonthlyToggle = toggleController.isMonthly.value;
      patientData = fetchDashboardData(
        isMonthly: isMonthlyToggle,
        pDate: DateFormat('yyyy-MM-dd').format(_selectedDate),
        pType: isMonthlyToggle
            ? 'Monthly'
            : 'Daily', // ✅ now both use the correct source
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
        final response = await apiService.getIpdSettlementData(
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
        print('Error fetching IPD settlement data: $e');
        return [];
      }
    } else {
      print('Access token is null. Please login.');
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
    loadIPDSettlementData();
  }

  void _goToNext() {
    final toggleController = Get.find<ToggleController>();
    setState(() {
      selectedDate = toggleController.isMonthly.value
          ? DateTime(
              selectedDate.year, selectedDate.month + 1, selectedDate.day)
          : selectedDate.add(const Duration(days: 1));
    });
    loadIPDSettlementData();
  }

  // void _handleToggle(bool value) {
  //   final toggleController = Get.find<ToggleController>();
  //   toggleController.isMonthly.value = value;
  //   setState(() {
  //     loadIPDSettlementData();
  //   });
  // }

  void _updateDate(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
    });
    // You can navigate or pass the new date to another screen here
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final toggleController = Get.find<ToggleController>();
    return Scaffold(
      body: Column(
        children: [
          DocvedaPrimaryHeaderContainer(
            child: Column(
              children: [
                DocvedaAppBar(
                  title: Center(
                    child: DocvedaText(
                      text: "IPD Settlement",
                      style: TextStyleFont.subheading
                          .copyWith(color: DocvedaColors.white),
                    ),
                  ),
                  showBackArrow: true,
                ),
                DocvedaToggle(
                  onToggle: (value) {
                    toggleController.isMonthly.value = value;
                    loadIPDSettlementData(); // or any other action you need
                  },
                ),
                DateSwitcherBar(
                  selectedDate: _selectedDate,
                  onPrevious: _goToPrevious,
                  onNext: _goToNext,
                  onDateChanged: _updateDate,
                  isMonthly:
                      toggleController.isMonthly.value, // Use global state
                  textColor: DocvedaColors.white,
                  fontSize: DocvedaSizes.fontSizeSm,
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
                      child: DocvedaText(text: "No settlement data found."));
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
                                text: "${patients.length} settlements found",
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
                                  text:
                                      "Patients whose IPD bills are fully settled.",
                                  style: TextStyleFont.body,
                                ),
                              )),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: DocvedaSizes.spaceBtwItems),
                        itemCount: patients.length,
                        itemBuilder: (context, index) {
                          return PatientCard(
                            index: index,
                            selectedPatientIndex: selectedPatientIndex,
                            onPatientSelected: handlePatientSelection,

                            /// 👤 Top Row: Name, Age, Gender
                            topRow: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
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
                                        text: formatPatientName(
                                            "${patients[index]["Patient Name"] ?? ""}"
                                                .trim()),
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
                                        "${patients[index]["Age"]?.toString() ?? "--"}  • ${patients[index]["Gender"] ?? "--"}",
                                    style: TextStyleFont.caption.copyWith(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// 🗓️ Middle Row: Admission and Discharge Dates
                            middleRow: Padding(
                              padding: const EdgeInsets.only(
                                  left: 32.0, right: 8.0, top: 8, bottom: 8),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          DocvedaText(
                                            text: "Admission Date",
                                            style: TextStyleFont.caption
                                                .copyWith(color: Colors.grey),
                                          ),
                                          const SizedBox(height: 4),
                                          DocvedaText(
                                            text: DateFormatter.formatDate(
                                                patients[index]
                                                    ["Admission Date"]),
                                            style: TextStyleFont.caption,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          DocvedaText(
                                            text: "Discharge Date",
                                            style: TextStyleFont.caption
                                                .copyWith(color: Colors.grey),
                                          ),
                                          const SizedBox(height: 4),
                                          DocvedaText(
                                            text: DateFormatter.formatDate(
                                                patients[index]
                                                    ["Discharge Date"]),
                                            style: TextStyleFont.caption,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    height: 24,
                                    color: Colors.grey.shade300,
                                    thickness: 1,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      DocvedaText(
                                        text: "Total Bill",
                                        style: TextStyleFont.caption
                                            .copyWith(color: Colors.grey),
                                      ),
                                      DocvedaText(
                                        text:
                                            "₹${patients[index]["Total IPD Bill"] ?? "0"}",
                                        style: TextStyleFont.body.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: DocvedaColors.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      DocvedaText(
                                        text: "Final Settlement",
                                        style: TextStyleFont.caption
                                            .copyWith(color: Colors.grey),
                                      ),
                                      DocvedaText(
                                        text:
                                            "₹${patients[index]["Final Settlement"] ?? "0"}",
                                        style: TextStyleFont.body.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: DocvedaColors.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            /// Optional bottomRow if needed
                            bottomRow: const SizedBox.shrink(),
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

                            // Strip the "Y" from the Age string and convert it to an integer
                            String ageString = selected["Age"] ?? "0";
                            int age = 0;

                            if (ageString.contains('Y')) {
                              ageString = ageString.replaceAll('Y', '').trim();
                            }

                            age = int.tryParse(ageString) ?? 0;

                            print('Age: $age'); // Debugging line

                            Get.to(
                              () => ViewReportScreen(
                                patientName: selected["Patient Name"] ?? "N/A",
                                age: age,
                                gender: selected["Gender"] ?? "N/A",
                                uhidno: selected["UHID No"] ?? "N/A",
                                admissionDate: DateFormatter.formatDate(
                                    selected["Admission Date"]),
                                totalIpdBill: FormatAmount.formatAmount(
                                    selected["Total IPD Bill"] ?? "0"),
                                finalSettlement: FormatAmount.formatAmount(
                                    selected["Final Settlement"] ?? "0"),
                                deposit: FormatAmount.formatAmount(
                                    selected["Deposit"] ?? "0"),
                                discountAmount: FormatAmount.formatAmount(
                                    selected["Discount Amount"] ?? "0"),
                                refundAmount: FormatAmount.formatAmount(
                                    selected["Refund Amount"] ?? "0"),
                                doctorInCharge:
                                    selected["Doctor Name"] ?? "N/A",
                                dischargeDate: DateFormatter.formatDate(
                                    selected["Discharge Date"]),
                                screenName: "IPD Settlement",
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
