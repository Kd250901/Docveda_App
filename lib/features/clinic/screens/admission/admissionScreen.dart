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

class AdmissionScreen extends StatefulWidget {
  final String dashboard_mst_cd;

  const AdmissionScreen(this.dashboard_mst_cd, {super.key});

  @override
  State<AdmissionScreen> createState() => _AdmissionScreenState();
}

class _AdmissionScreenState extends State<AdmissionScreen> {
  final ApiService apiService = ApiService();
  int selectedPatientIndex = 0;
  late Future<List<Map<String, dynamic>>> patientData;

  DateTime selectedDate = DateTime.now();
  bool isMonthly = false;

  @override
  void initState() {
    super.initState();
    patientData = fetchDashboardData();
  }

  void handlePatientSelection(int index) {
    setState(() {
      selectedPatientIndex = index;
    });
  }

  Future<List<Map<String, dynamic>>> fetchDashboardData() async {
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'accessToken');

    if (accessToken != null) {
      try {
        final response = await apiService.getAdmissionData(
          accessToken,
          widget.dashboard_mst_cd,
        );

        if (response != null && response['data'] != null) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          print('Invalid data format or missing "results.data" field.');
          return [];
        }
      } catch (e) {
        print('Error fetching dashboard data: $e');
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
                      text: DocvedaTexts.admission,
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

          /// Dynamic Content
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: patientData,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DocvedaText(
                            text:
                                "${patients.length} ${DocvedaTexts.patientFound}",
                            style: TextStyleFont.subheading,
                          ),
                          DocvedaText(
                            text: DocvedaTexts.depositePatientDesc,
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
                            patient: {
                              "name": "${patient["Patient_Name"] ?? ""}".trim(),
                              "age": patient["Age"]?.toString() ?? "N/A",
                              "gender": patient["Gender"] ?? "N/A",
                              "admission": DateFormatter.formatDate(
                                      patient["Registration_Date"]) ??
                                  "N/A",
                              "registrationNumber":
                                  patient["Registration_No"] ?? "N/A",
                              "finalSettlement": "",
                            },
                            index: index,
                            selectedPatientIndex: selectedPatientIndex,
                            onPatientSelected: handlePatientSelection,
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

                            final selected = patients[
                                selectedPatientIndex]; // Corrected this line
                            Get.to(
                              () => ViewReportScreen(
                                patientName:
                                    "${selected["Patient_Name"] ?? ''}",
                                age: selected["Age"] != null
                                    ? int.tryParse(
                                            selected["Age"].toString()) ??
                                        0
                                    : 0,
                                gender: selected["Gender"] ?? "N/A",
                                admissionDate: DateFormatter.formatDate(
                                        selected["Registration_Date"]) ??
                                    "N/A",
                                dischargeDate: DateFormatter.formatDate(
                                        selected["f_HIS_IPD_DischargeDate"]) ??
                                    "N/A",
                                finalSettlement: (selected["BillAmt"] != null)
                                    ? selected["BillAmt"].toString()
                                    : "N/A",
                              ),
                            );
                          },
                          text: DocvedaTexts.viewReport,
                          backgroundColor: DocvedaColors.primaryColor,
                        )),
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
