import 'package:docveda_app/common/widgets/app_text/app_text.dart';
import 'package:docveda_app/common/widgets/appbar/appbar.dart';
import 'package:docveda_app/common/widgets/card/patient_card.dart';
import 'package:docveda_app/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:docveda_app/common/widgets/date_switcher_bar/date_switcher_bar.dart';
import 'package:docveda_app/common/widgets/toggle/toggle.dart';
import 'package:docveda_app/features/authentication/screens/login/login.dart';
import 'package:docveda_app/common/widgets/primary_button/primary_button.dart';
import 'package:docveda_app/utils/constants/colors.dart';
import 'package:docveda_app/utils/constants/sizes.dart';
import 'package:docveda_app/utils/constants/text_strings.dart';
import 'package:docveda_app/utils/helpers/date_formater.dart';
import 'package:docveda_app/utils/theme/custom_themes/text_style_font.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:docveda_app/features/authentication/screens/login/service/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Dischargescreen extends StatefulWidget {
  final String dashboard_mst_cd;
  Dischargescreen(this.dashboard_mst_cd, {super.key});

  @override
  _DischargescreenState createState() => _DischargescreenState();
}

class _DischargescreenState extends State<Dischargescreen> {
  int selectedPatientIndex = 0;
  final ApiService apiService = ApiService();
  late Future<List<Map<String, dynamic>>> patientData;

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
        final response = await apiService.dischargeData(accessToken);

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
                      text: DocvedaTexts.discharge,
                      style: TextStyleFont.subheading.copyWith(
                        color: DocvedaColors.white,
                      ),
                    ),
                  ),
                  showBackArrow: true,
                ),
                // Center the remaining widgets
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DocvedaToggle(
                            isMonthly: isMonthly, onToggle: _handleToggle),
                        // const SizedBox(height: 10),
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
                    child: DocvedaText(text: DocvedaTexts.noDischargePatientFound),
                  );
                }

                final patients = snapshot.data!;

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DocvedaText(
                            text: "${patients.length} ${DocvedaTexts.patientFound}",
                            style: TextStyleFont.subheading.copyWith(
                              fontSize: screenWidth < 360 ? DocvedaSizes.fontSize : DocvedaSizes.fontSizeSm,
                            ),
                          ),
                          const SizedBox(height: DocvedaSizes.spaceBtwItemsSsm),
                          DocvedaText(
                            text:
                                DocvedaTexts.depositePatientDesc,
                            style: TextStyleFont.body.copyWith(
                              fontSize: screenWidth < 360 ? DocvedaSizes.fontSizeXsm : DocvedaSizes.fontSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: DocvedaSizes.spaceBtwItemsS), // changed 14 to 10
                        child: ListView.builder(
                          itemCount: patients.length,
                          itemBuilder: (context, index) {
                            final patient = patients[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: DocvedaSizes.spaceBtwItemsS),
                              child: PatientCard(
                                patient: {
                                  "name":
                                      "${patient["f_DV_First_Name"] ?? ''} ${patient["f_DV_Last_Name"] ?? ''}",
                                  "age": patient["Ageyear"] ?? "N/A",
                                  "gender": patient["VisitType"] ?? "N/A",
                                  "admission": DateFormatter.formatDate(
                                        patient["f_HIS_IPD_Reg_Date"],
                                      ) ??
                                      "N/A",
                                  "discharge": DateFormatter.formatDate(
                                        patient["f_HIS_IPD_Reg_Date"],
                                      ) ??
                                      "N/A",
                                  "billAmount": patient["BillAmt"],
                                },
                                index: index,
                                selectedPatientIndex: selectedPatientIndex,
                                onPatientSelected: handlePatientSelection,
                              ),
                            );
                          },
                        ),
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
                            final selectedPatient =
                                patients[selectedPatientIndex];
                            // Add report logic/navigation here
                            print(
                                "${DocvedaTexts.viewReportFor} ${selectedPatient["f_DV_First_Name"]}");
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
