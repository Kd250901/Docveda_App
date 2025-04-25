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

class RefundsScreen extends StatefulWidget {
  const RefundsScreen({super.key});

  @override
  State<RefundsScreen> createState() => _RefundsScreenState();
}

class _RefundsScreenState extends State<RefundsScreen> {
  final ApiService apiService = ApiService();
  int selectedPatientIndex = 0;
  late Future<List<Map<String, dynamic>>> patientData;

  DateTime selectedDate = DateTime.now();
  bool isMonthly = false;

  @override
  void initState() {
    super.initState();
    loadRefundData();
  }

  void loadRefundData() {
    setState(() {
      patientData = fetchRefundData(
        isMonthly: isMonthly,
        pDate: DateFormat('yyyy-MM-dd').format(selectedDate),
        pType: isMonthly ? 'Monthly' : 'Daily',
      );
    });
  }

  Future<List<Map<String, dynamic>>> fetchRefundData({
    required bool isMonthly,
    required String pType,
    required String pDate,
  }) async {
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'accessToken');

    if (accessToken != null) {
      try {
        final response = await apiService.getRefundData(
          accessToken,
          context,
          isMonthly: isMonthly,
          pDate: pDate,
          pType: pType[0].toUpperCase() + pType.substring(1).toLowerCase(),
        );

        if (response != null && response['data'] != null) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          return [];
        }
      } catch (e) {
        print('Error fetching refund data: $e');
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
    loadRefundData();
  }

  void _goToNext() {
    setState(() {
      selectedDate = isMonthly
          ? DateTime(
              selectedDate.year, selectedDate.month + 1, selectedDate.day)
          : selectedDate.add(const Duration(days: 1));
    });
    loadRefundData();
  }

  void _handleToggle(bool value) {
    setState(() {
      isMonthly = value;
    });
    loadRefundData();
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
                      "Refunds",
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
                  return const Center(child: Text('No refund data available.'));
                }

                final patients = snapshot.data!;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${patients.length} patients found with refunds",
                          style: TextStyleFont.subheading),
                      const SizedBox(height: DocvedaSizes.spaceBtwItemsSsm),
                      Expanded(
                        child: ListView.builder(
                          itemCount: patients.length,
                          itemBuilder: (context, index) {
                            final patient = patients[index];
                            return PatientCard(
                              patient: {
                                "name":
                                    "${patient["Patient_Name"] ?? ""}".trim(),
                                "age": patient["Age"]?.toString() ?? "N/A",
                                "gender": patient["Gender"] ?? "N/A",
                                "admission": DateFormatter.formatDate(
                                        patient["Admission Date"]) ??
                                    "N/A",
                                "registrationNumber":
                                    patient["Registration_No"] ?? "N/A",
                                "discountGiven":
                                    patient["RefundAmount"]?.toString() ?? "0",
                              },
                              index: index,
                              selectedPatientIndex: selectedPatientIndex,
                              onPatientSelected: handlePatientSelection,
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
                            Get.to(() => ViewReportScreen(
                                  patientName: selectedPatient["name"],
                                  age: selectedPatient["age"],
                                  gender: selectedPatient["gender"],
                                  admissionDate: selectedPatient["admission"],
                                  dischargeDate:
                                      selectedPatient["discharge"] ?? "N/A",
                                  finalSettlement:
                                      selectedPatient["discountGiven"],
                                  screenName: "Refunds",
                                ));
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
