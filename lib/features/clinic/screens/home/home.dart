import 'package:docveda_app/common/widgets/appbar/appbar.dart';
import 'package:docveda_app/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:docveda_app/common/widgets/date_switcher_bar/date_switcher_bar.dart';
import 'package:docveda_app/common/widgets/section_heading/section_heading.dart';
import 'package:docveda_app/common/widgets/toggle/toggle.dart';
import 'package:docveda_app/features/authentication/screens/login/login.dart';
import 'package:docveda_app/features/authentication/screens/login/service/api_service.dart';
import 'package:docveda_app/features/clinic/screens/home/widgets/bedTransferCard.dart';
import 'package:docveda_app/features/clinic/screens/home/widgets/expensesSection.dart';
import 'package:docveda_app/features/clinic/screens/home/widgets/patientInformationSection.dart';
import 'package:docveda_app/features/clinic/screens/home/widgets/revenueSection.dart';
import 'package:docveda_app/features/clinic/screens/settings/settingScreen.dart';
import 'package:docveda_app/utils/constants/colors.dart';
import 'package:docveda_app/utils/constants/image_strings.dart';
import 'package:docveda_app/utils/constants/sizes.dart';
import 'package:docveda_app/utils/constants/text_strings.dart';
import 'package:docveda_app/utils/helpers/storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

final List<String> dashboardItems = [
  DocvedaTexts.dashboardItems1, // "Bed Transfers"
  DocvedaTexts.dashboardItems2, // "Bed Transfers"
  DocvedaTexts.dashboardItems3, // "Bed Transfers"
  DocvedaTexts.dashboardItems4, // "OPD Bills"
  DocvedaTexts.dashboardItems5, // "OPD Payments"z
  DocvedaTexts.dashboardItems6, // "Deposits"
  DocvedaTexts.dashboardItems7, // "IPD Settlements"
  DocvedaTexts.dashboardItems8, // "Discounts"
  DocvedaTexts.dashboardItems9, // "Refunds"
];

class _HomeScreenState extends State<HomeScreen> {
  // NotificationServices notificationServices = NotificationServices();
  final ApiService apiService = ApiService();

  //  Declare the variable to store API response

  late Future<List<Map<String, dynamic>>> dashboardDataFuture;
  bool isMonthly = false; // default to daily

  @override
  void initState() {
    super.initState();
    //dashboardData = fetchDashboardData();
    // loadDashboardData(); // Call API when screen initializes
    dashboardDataFuture = fetchDashboardData(
      isMonthly: isMonthly,
      pDate: DateFormat('yyyy-MM-dd').format(selectedDate),
      pType: isMonthly ? 'MONTHLY' : 'DAILY',
    );
    print("dashboardDataFuture: $dashboardDataFuture");

    // notificationServices.requestNotificationPermission();
    // notificationServices.firebaseInit(context);
    // notificationServices.setupInteractMessage(context);
    // notificationServices.isTokenRefresh();
    // notificationServices.getDeviceToken().then((value) {
    //   print("Device Token: ");
    //   print(value);
    // });
  }

  //get item => null;

  Future<List<Map<String, dynamic>>> fetchDashboardData({
    required bool isMonthly,
    required String pType,
    required String pDate,
  }) async {
    print(
        ' API Called with mode: ${isMonthly ? 'monthly' : 'daily'} on date: $selectedDate');
    String? accessToken = await StorageHelper.getAccessToken();

    if (accessToken != null) {
      try {
        final response = await apiService.getCards(accessToken, context,
            isMonthly: isMonthly, pDate: pDate, pType: pType);
        print("API Response from home: ${response}");
        if (response != null && response['statusCode'] == 401) {
          StorageHelper.clearTokens();
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

  //  Function to fetch data and store it in `dashboardData`
  void loadDashboardData() async {}

  DateTime selectedDate = DateTime.now();
  //bool isMonthly = false;

  void _goToPrevious() {
    setState(() {
      selectedDate = isMonthly
          ? DateTime(
              selectedDate.year, selectedDate.month - 1, selectedDate.day)
          : selectedDate.subtract(const Duration(days: 1));

      dashboardDataFuture = fetchDashboardData(
        isMonthly: isMonthly,
        pDate: DateFormat('yyyy-MM-dd').format(selectedDate),
        pType: isMonthly ? 'MONTHLY' : 'DAILY',
      );
    });
  }

  void _goToNext() {
    setState(() {
      selectedDate = isMonthly
          ? DateTime(
              selectedDate.year, selectedDate.month + 1, selectedDate.day)
          : selectedDate.add(const Duration(days: 1));

      dashboardDataFuture = fetchDashboardData(
        isMonthly: isMonthly,
        pDate: DateFormat('yyyy-MM-dd').format(selectedDate),
        pType: isMonthly ? 'MONTHLY' : 'DAILY',
      );
    });
  }

  void _handleToggle(bool newValue) {
    setState(() {
      isMonthly = newValue;

      final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      final type = isMonthly ? 'MONTHLY' : 'DAILY';

      dashboardDataFuture = fetchDashboardData(
        isMonthly: isMonthly,
        pType: type,
        pDate: formattedDate,
      );
    });
  }

  List<Map<String, dynamic>> extractOptionsFromData({
    required Map<String, dynamic> data,
    required List<String> keys,
  }) {
    List<Map<String, dynamic>> options = [];

    for (String key in keys) {
      if (data.containsKey(key)) {
        options.add({
          'label':
              key.replaceAll('_', ' '), // Optional: make key human-readable
          'value': data[key],
          'key': key,
        });
      }
    }

    return options;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dashboardDataFuture,
        builder: (context, snapshot) {
          bool isLoading = snapshot.connectionState == ConnectionState.waiting;

          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No dashboard data found.'));
          }

          final dashboardData = snapshot.data!;

          List<Map<String, dynamic>> patientDataArray = extractOptionsFromData(
            data: dashboardData[0],
            keys: ["Total_Registrations", "Discharge"],
          );

          List<Map<String, dynamic>> revenueDataArray = extractOptionsFromData(
            data: dashboardData[0],
            keys: ["Deposite", "OPD_Payment", "OPD_Bill", "IPD_Settlement"],
          );

          List<Map<String, dynamic>> expenseDataArray = extractOptionsFromData(
            data: dashboardData[0],
            keys: ["Total_Discount", "Total_Refund"],
          );

          return SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              DocvedaPrimaryHeaderContainer(
                child: Column(
                  children: [
                    DocvedaAppBar(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: DocvedaColors.white,
                                child: Image.asset(DocvedaImages.clinicLogo),
                              ),
                              const SizedBox(
                                width: DocvedaSizes.spaceBtwItems,
                              ),
                              Column(
                                children: [
                                  Text(
                                    DocvedaTexts.clinicNameTitle,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .apply(color: DocvedaColors.white),
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        DocvedaImages.protectLogo,
                                        width: DocvedaSizes.imageWidthS,
                                        height: DocvedaSizes.imageHeightS,
                                        fit: BoxFit.contain,
                                      ),
                                      const SizedBox(
                                        width: DocvedaSizes.spaceBtwItemsSm,
                                      ),
                                      Text(
                                        DocvedaTexts.logo,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelMedium!.apply(
                                              color: DocvedaColors.white,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      actions: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: DocvedaSizes.spaceBtwItemsSm,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Iconsax.setting_25,
                                color: DocvedaColors.white,
                              ),
                              onPressed: () {
                                Get.to(() => const SettingsScreen());
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: DocvedaSizes.spaceBtwItemsS,
                    ),
                    const SizedBox(height: DocvedaSizes.spaceBtwItemsS),
                    DocvedaToggle(
                      isMonthly: isMonthly,
                      onToggle: _handleToggle,
                    ),
                    DateSwitcherBar(
                      selectedDate: selectedDate,
                      onPrevious: _goToPrevious,
                      onNext: _goToNext,
                      isMonthly: isMonthly,
                      textColor: DocvedaColors.white,
                      fontSize: DocvedaSizes.fontSizeSm,
                    ),
                    const SizedBox(height: DocvedaSizes.spaceBtwItemsS),
                  ],
                ),
              ),
              if (isLoading) ...[
                const SizedBox(height: 200),
                const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: DocvedaColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 100),
              ] else if (snapshot.hasData) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: DocvedaSizes.defaultSpace),
                  child: Column(
                    children: [
                      // PATIENT INFORMATION
                      DocvedaSectionHeading(
                        title: 'PATIENT INFORMATION',
                        showActionButton: false,
                        textStyle: TextStyle(
                          fontFamily: "Manrope",
                          fontSize: DocvedaSizes.fontSizeMd,
                          fontWeight: FontWeight.bold,
                          color: DocvedaColors.black,
                        ),
                      ),

                      const SizedBox(height: DocvedaSizes.spaceBtwItemsLg),

                      PatientInformationSection(
                          patientDataArray: patientDataArray),

                      const SizedBox(height: DocvedaSizes.spaceBtwItemsS),

                      BedTransferCard(
                          bedTransferCount:
                              dashboardData[0]['Bed_Transfer'] ?? 0),

                      const SizedBox(height: DocvedaSizes.spaceBtwItems),
                      DocvedaSectionHeading(
                        title: 'REVENUE',
                        showActionButton: false,
                        textStyle: TextStyle(
                          fontFamily: "Manrope",
                          fontSize: DocvedaSizes.fontSizeMd,
                          fontWeight: FontWeight.bold,
                          color: DocvedaColors.black,
                        ),
                      ),

                      const SizedBox(height: DocvedaSizes.spaceBtwItems),

                      RevenueSection(revenueDataArray: revenueDataArray),

                      const SizedBox(height: DocvedaSizes.spaceBtwItems),

                      // EXPENSES
                      DocvedaSectionHeading(
                        title: 'EXPENSES',
                        showActionButton: false,
                        textStyle: TextStyle(
                          fontFamily: "Manrope",
                          fontSize: DocvedaSizes.fontSizeMd,
                          fontWeight: FontWeight.bold,
                          color: DocvedaColors.black,
                        ),
                      ),

                      const SizedBox(height: DocvedaSizes.spaceBtwItems),
                      ExpensesSection(expenseDataArray: expenseDataArray),

                      const SizedBox(height: DocvedaSizes.spaceBtwSections),
                    ],
                  ),
                ),
              ],
            ]),
          );
        },
      ),
    );
  }
}
