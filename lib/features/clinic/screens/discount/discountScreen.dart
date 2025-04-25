import 'package:docveda_app/common/widgets/app_text/app_text.dart';
import 'package:docveda_app/common/widgets/appbar/appbar.dart';
import 'package:docveda_app/common/widgets/card/patient_card.dart';
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
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';

class DiscountsScreen extends StatefulWidget {
  const DiscountsScreen({super.key});

  @override
  State<DiscountsScreen> createState() => _DiscountsScreenState();
}

class _DiscountsScreenState extends State<DiscountsScreen> {
  final ApiService apiService = ApiService();
  int selectedPatientIndex = 0;
  late Future<List<Map<String, dynamic>>> patientData;

  DateTime selectedDate = DateTime.now();
  bool isMonthly = false;

  @override
  void initState() {
    super.initState();
    loadDiscountData();
  }

  void loadDiscountData() {
    setState(() {
      patientData = fetchDiscountData(
        isMonthly: isMonthly,
        pDate: DateFormat('yyyy-MM-dd').format(selectedDate),
        pType: isMonthly ? 'Monthly' : 'Daily',
      );
    });
  }

  Future<List<Map<String, dynamic>>> fetchDiscountData({
    required bool isMonthly,
    required String pType,
    required String pDate,
  }) async {
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'accessToken');

    if (accessToken != null) {
      try {
        print('pDate: $pDate');
        print('pType: $pType');
        final response = await apiService.getDiscountData(
          accessToken,
          context,
          isMonthly: isMonthly,
          pDate: pDate,
          pType: pType[0].toUpperCase() + pType.substring(1).toLowerCase(),
        );
        print(
            'Sending pType: ${pType[0].toUpperCase() + pType.substring(1).toLowerCase()}');

        if (response != null && response['data'] != null) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          print('Invalid data format or missing "data" field.');
          return [];
        }
      } catch (e) {
        print('Error fetching discount data: $e');
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
    loadDiscountData(); // 🔁 Re-fetch when date changes
  }

  void _goToNext() {
    setState(() {
      selectedDate = isMonthly
          ? DateTime(
              selectedDate.year, selectedDate.month + 1, selectedDate.day)
          : selectedDate.add(const Duration(days: 1));
    });
    loadDiscountData(); // 🔁 Re-fetch when date changes
  }

  void _handleToggle(bool value) {
    setState(() {
      isMonthly = value;
    });
    loadDiscountData(); // 🔁 Re-fetch on toggle change
  }

  void handlePatientSelection(int index) {
    setState(() {
      selectedPatientIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          DocvedaPrimaryHeaderContainer(
            child: Column(
              children: [
                DocvedaAppBar(
                  title: Center(
                    child: Text(
                      "Discounts",
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
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No discount data available.'));
                }

                final patients = snapshot.data!;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${patients.length} patients found with discounts",
                          style: TextStyleFont.subheading),
                      const SizedBox(height: DocvedaSizes.spaceBtwItemsSsm),
                      Expanded(
                        child: ListView.builder(
                          itemCount: patients.length,
                          itemBuilder: (context, index) {
                            final patient = patients[index];
                            return PatientCard(
                              index: index,
                              selectedPatientIndex: selectedPatientIndex,
                              onPatientSelected: handlePatientSelection,

                              /// 👤 Top Row: Name, Age, Gender
                              topRow: Row(
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
                                    style: TextStyleFont.caption
                                        .copyWith(color: Colors.grey),
                                  ),
                                ],
                              ),

                              /// 📅 Middle Row: Admission Date & Registration No
                              middleRow: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        text: "REG. NO",
                                        style: TextStyleFont.caption
                                            .copyWith(color: Colors.grey),
                                      ),
                                      const SizedBox(height: 4),
                                      DocvedaText(
                                        text:
                                            patient["Registration_No"] ?? "N/A",
                                        style: TextStyleFont.caption,
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              /// 💰 Bottom Row: Discount Given
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
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        DocvedaText(
                                          text: "DISCOUNT GIVEN",
                                          style: TextStyleFont.caption
                                              .copyWith(color: Colors.grey),
                                        ),
                                        const SizedBox(height: 4),
                                        DocvedaText(
                                          text:
                                              "₹${patient["Discount Amount"]?.toString() ?? "0"}",
                                          style: TextStyleFont.body.copyWith(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
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
                            horizontal: screenWidth * 0.05, vertical: 10),
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
                            final selectedPatient =
                                patients[selectedPatientIndex];
                            Get.to(
                              () => ViewReportScreen(
                                patientName: selectedPatient["name"],
                                age: selectedPatient["age"],
                                gender: selectedPatient["gender"],
                                admissionDate: selectedPatient["admission"],
                                dischargeDate:
                                    selectedPatient["discharge"] ?? "N/A",
                                finalSettlement:
                                    selectedPatient["discountGiven"],
                                screenName: "Discounts",
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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
