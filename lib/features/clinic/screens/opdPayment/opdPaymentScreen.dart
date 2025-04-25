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

class Opdpaymentscreen extends StatefulWidget {
  const Opdpaymentscreen({super.key});

  @override
  _OpdpaymentscreenState createState() => _OpdpaymentscreenState();
}

class _OpdpaymentscreenState extends State<Opdpaymentscreen> {
  // int selectedPatientIndex = 0;
  final ApiService apiService = ApiService();
  int selectedPatientIndex = 0;
  late Future<List<Map<String, dynamic>>> patientData;

  DateTime selectedDate = DateTime.now();
  bool isMonthly = false;

  @override
  void initState() {
    super.initState();
    loadOpdPaymentData();
  }

  void handlePatientSelection(int index) {
    setState(() {
      selectedPatientIndex = index;
    });
  }

  void loadOpdPaymentData() {
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
        final response = await apiService.getOpdPaymnetData(
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
        print('Error fetching dashboard data: $e');
        return [];
      }
    } else {
      print('Access token is null. Please login.');
      return [];
    }
  }

  // DateTime selectedDate = DateTime.now();
  // bool isMonthly = false;

  void _goToPrevious() {
    setState(() {
      selectedDate = isMonthly
          ? DateTime(
              selectedDate.year, selectedDate.month - 1, selectedDate.day)
          : selectedDate.subtract(const Duration(days: 1));
    });
    loadOpdPaymentData();
  }

  void _goToNext() {
    setState(() {
      selectedDate = isMonthly
          ? DateTime(
              selectedDate.year, selectedDate.month + 1, selectedDate.day)
          : selectedDate.add(const Duration(days: 1));
    });
    loadOpdPaymentData();
  }

  void _handleToggle(bool value) {
    setState(() {
      isMonthly = value;
    });
    loadOpdPaymentData();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          /// Header Section
          DocvedaPrimaryHeaderContainer(
            child: Column(
              children: [
                DocvedaAppBar(
                  title: Center(
                    child: DocvedaText(
                      text: DocvedaTexts.opdPayments,
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

          /// FutureBuilder for API data
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: patientData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text("No patient data available."));
                }

                final patients = snapshot.data!;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: DocvedaSizes.spaceBtwItemsSsm),
                      DocvedaText(
                        text: "${patients.length} ${DocvedaTexts.patientFound}",
                        style: TextStyleFont.subheading,
                      ),
                      DocvedaText(
                        text: DocvedaTexts.depositePatientDesc,
                        style: TextStyleFont.body,
                      ),

                      /// Patient Cards
                      Expanded(
                        child: ListView.builder(
                          itemCount: patients.length,
                          itemBuilder: (context, index) {
                            final patient = patients[index];
                            return PatientCard(
                              index: index,
                              selectedPatientIndex: selectedPatientIndex,
                              onPatientSelected: handlePatientSelection,

                              // Custom topRow
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
                                      SizedBox(width: 8),
                                      Text("${patient["Patient Name"] ?? ""}"
                                          .trim()),
                                    ],
                                  ),
                                  Text(
                                    "${patient["Age"] ?? "N/A"} Yrs • ${patient["Gender"] ?? "N/A"}",
                                  ),
                                ],
                              ),

                              // Custom middleRow
                              middleRow: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Admission"),
                                      Text(DateFormatter.formatDate(
                                              patient["Admission Date"]) ??
                                          "N/A"),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text("Discharge"),
                                      Text(DateFormatter.formatDate(
                                              patient["Discharge Date"]) ??
                                          "N/A"),
                                    ],
                                  ),
                                ],
                              ),

                              // Custom bottomRow
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
                                    Text("Final Settlement"),
                                    Text("₹${patient["Bill Amount"] ?? "0"}"),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      /// View Report Button
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
                              blurRadius: DocvedaSizes.borderRadiusMd,
                              spreadRadius: DocvedaSizes.spreadRadius,
                            ),
                          ],
                        ),
                        child: SizedBox(
                          height: DocvedaSizes.cardHeight,
                          width: double.infinity,
                          child: PrimaryButton(
                            onPressed: () {
                              final selectedPatient =
                                  patients[selectedPatientIndex];
                              Get.to(
                                () => ViewReportScreen(
                                  patientName: selectedPatient["name"],
                                  age: selectedPatient["age"],
                                  gender: selectedPatient["gender"],
                                  admissionDate: selectedPatient["admission"],
                                  dischargeDate: selectedPatient["discharge"],
                                  finalSettlement:
                                      selectedPatient["finalSettlement"],
                                  screenName: "OPD Payments",
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // /// Dummy patient list
  // List<Map<String, dynamic>> patients = [
  //   {
  //     "name": "John Doe",
  //     "age": 45,
  //     "gender": "Male",
  //     "admission": "2025-01-01",
  //     "discharge": "2025-01-10",
  //     "finalSettlement": "Pending",
  //   },
  //   {
  //     "name": "Jane Smith",
  //     "age": 50,
  //     "gender": "Female",
  //     "admission": "2025-02-01",
  //     "discharge": "2025-02-12",
  //     "finalSettlement": "Completed",
  //   },
  // ];
}
