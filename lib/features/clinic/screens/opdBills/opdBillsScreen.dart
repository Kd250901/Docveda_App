// import 'package:docveda_app/common/widgets/app_text/app_text.dart';
// import 'package:docveda_app/common/widgets/appbar/appbar.dart';
// import 'package:docveda_app/common/widgets/card/patient_card.dart';
// import 'package:docveda_app/common/widgets/custom_shapes/containers/primary_header_container.dart';
// import 'package:docveda_app/common/widgets/date_switcher_bar/date_switcher_bar.dart';
// import 'package:docveda_app/common/widgets/toggle/toggle.dart';
// import 'package:docveda_app/common/widgets/primary_button/primary_button.dart';
// import 'package:docveda_app/common/widgets/toggle/toggleController.dart';
// import 'package:docveda_app/features/authentication/screens/login/service/api_service.dart';
// import 'package:docveda_app/features/clinic/screens/viewReportScreen/viewReportScreen.dart';
// import 'package:docveda_app/utils/constants/colors.dart';
// import 'package:docveda_app/utils/constants/sizes.dart';
// import 'package:docveda_app/utils/constants/text_strings.dart';
// import 'package:docveda_app/utils/helpers/date_formater.dart';
// import 'package:docveda_app/utils/helpers/format_name.dart';
// import 'package:docveda_app/utils/theme/custom_themes/text_style_font.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:get/get.dart';
// //import 'package:get/route_manager.dart';
// import 'package:intl/intl.dart';

// class Opdbillsscreen extends StatefulWidget {
//   final bool isSelectedMonthly;
//   final DateTime prevSelectedDate;

//   const Opdbillsscreen({
//     super.key,
//     required this.isSelectedMonthly,
//     required this.prevSelectedDate
//     });

//   @override
//   _OpdbillsscreenState createState() => _OpdbillsscreenState();
// }

// class _OpdbillsscreenState extends State<Opdbillsscreen> {
//   final ApiService apiService = ApiService();
//   int selectedPatientIndex = 0;
//   late Future<List<Map<String, dynamic>>> patientData;

//   DateTime selectedDate = DateTime.now();
//   DateTime _selectedDate = DateTime.now();
//   bool isMonthly = false;

//   @override
//   void initState() {
//     super.initState();
//     _selectedDate = widget.prevSelectedDate;
//     isMonthly = widget.isSelectedMonthly;
//     loadOpdBillsData();
//   }

//   void handlePatientSelection(int index) {
//     setState(() {
//       selectedPatientIndex = index;
//     });
//   }

//   void loadOpdBillsData() {
//     final toggleController = Get.find<ToggleController>();

//     setState(() {
//       patientData = fetchDashboardData(
//         isMonthly: toggleController.isMonthly.value, // Use global toggle state
//         pDate: DateFormat('yyyy-MM-dd').format(selectedDate),
//         pType: toggleController.isMonthly.value ? 'Monthly' : 'Daily',
//       );
//     });
//   }

//   Future<List<Map<String, dynamic>>> fetchDashboardData({
//     required bool isMonthly,
//     required String pType,
//     required String pDate,
//   }) async {
//     final storage = FlutterSecureStorage();
//     String? accessToken = await storage.read(key: 'accessToken');

//     if (accessToken != null) {
//       try {
//         final response = await apiService.getOpdBillsData(
//           accessToken,
//           context,
//           isMonthly: isMonthly,
//           pDate: pDate,
//           pType: pType[0].toUpperCase() + pType.substring(1).toLowerCase(),
//         );

//         if (response != null && response['data'] != null) {
//           return List<Map<String, dynamic>>.from(response['data']);
//         } else {
//           print('Invalid data format or missing "data" field.');
//           return [];
//         }
//       } catch (e) {
//         print('Error fetching dashboard data: $e');
//         return [];
//       }
//     } else {
//       print('Access token is null. Please login.');
//       return [];
//     }
//   }

//   // DateTime selectedDate = DateTime.now();
//   // bool isMonthly = false;

//   void _goToPrevious() {
//     final toggleController = Get.find<ToggleController>();
//     setState(() {
//       selectedDate = toggleController.isMonthly.value
//           ? DateTime(
//               selectedDate.year, selectedDate.month - 1, selectedDate.day)
//           : selectedDate.subtract(const Duration(days: 1));
//     });
//     loadOpdBillsData();
//   }

//   void _goToNext() {
//     final toggleController = Get.find<ToggleController>();
//     setState(() {
//       selectedDate = toggleController.isMonthly.value
//           ? DateTime(
//               selectedDate.year, selectedDate.month + 1, selectedDate.day)
//           : selectedDate.add(const Duration(days: 1));
//     });
//     loadOpdBillsData();
//   }

//   // void _handleToggle(bool value) {
//   //   setState(() {
//   //     isMonthly = value;
//   //   });
//   //   loadOpdBillsData();
//   // }

//   void _updateDate(DateTime newDate) {
//     setState(() {
//       _selectedDate = newDate;
//     });
//     // You can navigate or pass the new date to another screen here
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     final toggleController = Get.find<ToggleController>();

//     return Scaffold(
//       body: Column(
//         children: [
//           /// **Header Section**
//           DocvedaPrimaryHeaderContainer(
//             child: Column(
//               children: [
//                 DocvedaAppBar(
//                   title: Center(
//                     child: Text(
//                       DocvedaTexts.opdBills,
//                       style: TextStyleFont.subheading.copyWith(
//                         color: DocvedaColors.white,
//                       ),
//                     ),
//                   ),
//                   showBackArrow: true,
//                 ),
//                 DocvedaToggle(
//                   onToggle: (value) {
//                     toggleController.isMonthly.value = value;
//                     loadOpdBillsData(); // or any other action you need
//                   },
//                 ),
//                 DateSwitcherBar(
//                   selectedDate: _selectedDate,
//                   onPrevious: _goToPrevious,
//                   onNext: _goToNext,
//                   onDateChanged: _updateDate,
//                   isMonthly:
//                       toggleController.isMonthly.value, // Use global state
//                   textColor: DocvedaColors.white,
//                   fontSize: DocvedaSizes.fontSizeSm,
//                 ),
//               ],
//             ),
//           ),

//           /// **FutureBuilder Section**
//           Expanded(
//             child: FutureBuilder<List<Map<String, dynamic>>>(
//               future: patientData,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(
//                       child: Text('No patient data available.'));
//                 }

//                 final patients = snapshot.data!;

//                 return Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: DocvedaSizes.spaceBtwItems),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Align(
//                             alignment: Alignment.centerLeft,
//                             child: Padding(
//                               padding: const EdgeInsets.only(
//                                   left: DocvedaSizes
//                                       .spaceBtwItems), // Add left padding here
//                               child: DocvedaText(
//                                 text:
//                                     "${patients.length} ${DocvedaTexts.patientFound}",
//                                 style: TextStyleFont.subheading,
//                               ),
//                             ),
//                           ),

//                           const SizedBox(
//                               height: DocvedaSizes
//                                   .xs), // Optional space between texts
//                           Align(
//                               alignment: Alignment
//                                   .centerLeft, // Ensures alignment of subtext on the left
//                               child: Padding(
//                                 padding: const EdgeInsets.only(
//                                     left: DocvedaSizes
//                                         .spaceBtwItems), // Add left padding here
//                                 child: DocvedaText(
//                                   text: DocvedaTexts.depositePatientDesc,
//                                   style: TextStyleFont.body,
//                                 ),
//                               )),
//                         ],
//                       ),
//                     ),

//                     /// **Patient List**
//                     Expanded(
//                       child: ListView.builder(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: DocvedaSizes.spaceBtwItems),
//                         itemCount: patients.length,
//                         itemBuilder: (context, index) {
//                           final patient = patients[index];

//                           return PatientCard(
//                             index: index,
//                             selectedPatientIndex: selectedPatientIndex,
//                             onPatientSelected: handlePatientSelection,

//                             /// 👤 Top Row: Name, Age, Gender
//                             topRow: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 8.0, vertical: 8),
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: [
//                                       Icon(
//                                         index == selectedPatientIndex
//                                             ? Icons.radio_button_checked
//                                             : Icons.radio_button_unchecked,
//                                         size: 16,
//                                         color: index == selectedPatientIndex
//                                             ? DocvedaColors.primaryColor
//                                             : Colors.grey,
//                                       ),
//                                       const SizedBox(width: 8),
//                                       DocvedaText(
//                                         text: formatPatientName(
//                                             "${patients[index]["Patient Name"] ?? ""}"
//                                                 .trim()),
//                                         style: TextStyleFont.body.copyWith(
//                                           fontWeight: FontWeight.w600,
//                                           fontSize: 14,
//                                         ),
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                     ],
//                                   ),
//                                   DocvedaText(
//                                     text:
//                                         "${patient["Age"]?.toString() ?? "--"} • ${patient["Gender"] ?? "--"}",
//                                     style: TextStyleFont.caption.copyWith(
//                                       color: Colors.grey,
//                                       fontSize: 12,
//                                     ),
//                                     textAlign: TextAlign.right,
//                                   ),
//                                 ],
//                               ),
//                             ),

//                             /// 📅 Middle Row: Admission & Discharge Dates
//                             middleRow: Padding(
//                               padding: const EdgeInsets.only(
//                                   left: 32.0, right: 8.0, top: 8, bottom: 8),
//                               child: Column(
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           DocvedaText(
//                                             text: "Visit Date",
//                                             style: TextStyleFont.caption
//                                                 .copyWith(color: Colors.grey),
//                                           ),
//                                           const SizedBox(height: 4),
//                                           DocvedaText(
//                                             text: DateFormatter.formatDate(
//                                                 patient["Admission Date"]),
//                                             style: TextStyleFont.caption,
//                                           ),
//                                         ],
//                                       ),
//                                       Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.end,
//                                         children: [
//                                           DocvedaText(
//                                             text: "Doctor Name",
//                                             style: TextStyleFont.caption
//                                                 .copyWith(color: Colors.grey),
//                                           ),
//                                           const SizedBox(height: 4),
//                                           DocvedaText(
//                                             text: DateFormatter.formatDate(
//                                                 patient["Doctor Name"]),
//                                             style: TextStyleFont.caption,
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                   Divider(
//                                     height: 24,
//                                     color: Colors.grey.shade300,
//                                     thickness: 1,
//                                   ),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       DocvedaText(
//                                         text: "Final Settlement",
//                                         style: TextStyleFont.caption
//                                             .copyWith(color: Colors.grey),
//                                       ),
//                                       DocvedaText(
//                                         text:
//                                             "₹${patient["Bill Amount"] ?? "0"}",
//                                         style: TextStyleFont.body.copyWith(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 16,
//                                           color: DocvedaColors.primaryColor,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),

//                             /// 🧾 Bottom Row: Optional Deposit Section (or SizedBox.shrink if not needed)
//                             bottomRow: const SizedBox.shrink(),
//                           );
//                         },
//                       ),
//                     ),

//                     /// **"View Report" Button**
//                     SafeArea(
//                       top: false,
//                       child: Container(
//                         width: double.infinity,
//                         padding: EdgeInsets.symmetric(
//                           horizontal: screenWidth * 0.05,
//                           vertical: 10,
//                         ),
//                         decoration: BoxDecoration(
//                           color: DocvedaColors.white,
//                           boxShadow: [
//                             BoxShadow(
//                               color: DocvedaColors.black.withOpacity(0.1),
//                               blurRadius: DocvedaSizes.borderRadiusMd,
//                               spreadRadius: DocvedaSizes.spreadRadius,
//                             ),
//                           ],
//                         ),
//                         child: PrimaryButton(
//                           text: DocvedaTexts.viewReport,
//                           backgroundColor: DocvedaColors.primaryColor,
//                           onPressed: () {
//                             if (patients.isEmpty ||
//                                 selectedPatientIndex >= patients.length) return;

//                             final selected = patients[selectedPatientIndex];

//                             // Strip the "Y" from the Age string and convert it to an integer
//                             String ageString = selected["Age"] ?? "0";
//                             int age = 0;

//                             if (ageString.contains('Y')) {
//                               ageString = ageString.replaceAll('Y', '').trim();
//                             }

//                             age = int.tryParse(ageString) ?? 0;

//                             print('Age: $age');

//                             Get.to(
//                               () => ViewReportScreen(
//                                 patientName: selected["Patient Name"] ?? "N/A",
//                              age:   patient['Age'] ?? 'unknown',
//                                 gender: selected["Gender"] ?? "N/A",
//                                 admissionDate: DateFormatter.formatDate(
//                                     selected["Admission Date"]),
//                                 dischargeDate: DateFormatter.formatDate(
//                                     selected["Discharge Date"]),
//                                 finalSettlement:
//                                     selected["Total IPD Bill"]?.toString() ??
//                                         "N/A",
//                                 screenName: "Admission",
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
