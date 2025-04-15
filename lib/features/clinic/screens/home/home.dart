import 'package:docveda_app/common/widgets/appbar/appbar.dart';
import 'package:docveda_app/common/widgets/card/card.dart';
import 'package:docveda_app/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:docveda_app/common/widgets/date_switcher_bar/date_switcher_bar.dart';
import 'package:docveda_app/common/widgets/layouts/grid_layout.dart';
import 'package:docveda_app/common/widgets/section_heading/section_heading.dart';
import 'package:docveda_app/common/widgets/toggle/toggle.dart';
import 'package:docveda_app/features/authentication/screens/login/login.dart';
import 'package:docveda_app/features/authentication/screens/login/service/api_service.dart';
import 'package:docveda_app/features/clinic/screens/discharge/admissionScreen.dart';
import 'package:docveda_app/features/clinic/screens/discharge/dischargeScreen.dart';
import 'package:docveda_app/features/clinic/screens/discharge/opdPaymentScreen.dart';
import 'package:docveda_app/features/clinic/screens/discharge/settingScreen.dart';
import 'package:docveda_app/features/clinic/screens/discharge/widgets/depositsScreen.dart';
import 'package:docveda_app/features/clinic/screens/discharge/widgets/ipdSettlementsScreen.dart';
import 'package:docveda_app/features/clinic/screens/discharge/widgets/opdBillsScreen.dart';
import 'package:docveda_app/utils/constants/colors.dart';
import 'package:docveda_app/utils/constants/image_strings.dart';
import 'package:docveda_app/utils/constants/sizes.dart';
import 'package:docveda_app/utils/constants/text_strings.dart';
import 'package:docveda_app/utils/helpers/storage_helper.dart';
import 'package:docveda_app/utils/theme/custom_themes/text_style_font.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

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
// bool isLoading = true;

// @override
// void initState() {
//   super.initState();
//   loadDashboardData();
// }

// void loadDashboardData() async {
//   final data = await fetchDashboardData();
//   setState(() {
//     dashboardData = data;
//     isLoading = false;
//   });
// }

// String Dashboard_Mst_Cd = '';

// final List<Widget> pages = [
//   AdmissionScreen(Dashboard_Mst_Cd),
//   Dischargescreen(Dashboard_Mst_Cd),
// ];

// final List<Map<String, dynamic>> pages = [
//   {'screen': AdmissionScreen, 'data': PageArgs(Dashboard_Mst_Cd: '')},
//   {'screen': Dischargescreen, 'data': PageArgs(Dashboard_Mst_Cd: '')},
// ];

class _HomeScreenState extends State<HomeScreen> {
  // NotificationServices notificationServices = NotificationServices();
  final ApiService apiService = ApiService();

  //  Declare the variable to store API response
  // List<Map<String, dynamic>> dashboardData = [];
  // late Future<List<Map<String, dynamic>>> dashboardData;
  late Future<List<Map<String, dynamic>>> dashboardDataFuture;

  //  Optional: A loading flag to show a loader while fetching data
  //bool isLoading = true;

  @override
  void initState() {
    super.initState();
    //dashboardData = fetchDashboardData();
    // loadDashboardData(); // Call API when screen initializes
    dashboardDataFuture = fetchDashboardData();
    // notificationServices.requestNotificationPermission();
    // notificationServices.firebaseInit(context);
    // notificationServices.setupInteractMessage(context);
    // // notificationServices.isTokenRefresh();
    // notificationServices.getDeviceToken().then((value) {
    //   print("Device Token: ");
    //   print(value);
    // });
  }

  //get item => null;

  Future<List<Map<String, dynamic>>> fetchDashboardData() async {
    String? accessToken =
        await StorageHelper.getAccessToken(); // Read the access token

    // Check if accessToken is valid
    if (accessToken != null) {
      try {
        // print("Triggering getCards with accessToken: $accessToken");

        final response = await apiService.getCards(accessToken, context);
        // final response = await apiService.getCards("", context);
        // print("Full API response: $response");

        print("response of get cards ${response}");
        if (response != null && response['statusCode'] == 401) {
          StorageHelper.clearTokens();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.offAll(() => const LoginScreen());
          });
          return [];
        }

        // Check if the response is valid and contains 'results'
        if (response != null && response['results'] != null) {
          List<Map<String, dynamic>> allResults =
              List<Map<String, dynamic>>.from(response['results']);

          // Filter only the desired titles
          List<Map<String, dynamic>> filteredResults = allResults.where((item) {
            final title = item['Dashboard_Title']?.toString() ?? '';
            return title == "Todays Registration" ||
                title == "Todays Collection";
          }).toList();
          //  print(
          //      "Filtered Dashboard Items: $filteredResults"); // 👈 See what passed

          return filteredResults;
        } else {
          print('Invalid data format or missing "results" field.');
          return [];
        }
      } catch (e) {
        // Catch and print any errors during the API request
        print('Error fetching dashboard data: $e');
        return [];
      }
    } else {
      // 🔐 If accessToken is missing, go to LoginScreen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAll(() => const LoginScreen());
      });
      return [];
    }
  }

  //  Function to fetch data and store it in `dashboardData`
  void loadDashboardData() async {
    // print('load dashboard data triggered: $loadDashboardData');
    // final data = await fetchDashboardData();
    // print(
    //   "API Response of d data: $data",
    // ); // 👈 this will print the full response in console

    // setState(() {
    //   dashboardData = data;
    //   // isLoading = false;
    // });
  }

  String getDashboardValue(List<Map<String, dynamic>> data, String title) {
    final item = data.firstWhere(
      (item) => item['Dashboard_Title'] == title,
      orElse: () => {},
    );
    return item['Records']?.toString() ?? '0';
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
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dashboardDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final dashboardData = snapshot.data!;
          print("dashboardData ${dashboardData}");
          List<Map<String, dynamic>> filteredData = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                                          width:
                                              20, // Set the width as per your requirement
                                          height:
                                              20, // Set the height as per your requirement
                                          fit: BoxFit
                                              .contain, // Ensures the image fits well
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ), // Adds spacing between image and text
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
                                right: 8.0,
                              ), // Adjust as needed
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
                        height: 10,
                      ), // Increased spacing before toggle
                      // Increased spacing
                      // Align(
                      //   alignment: Alignment.center,
                      //   child: DocvedaToggle(),
                      // ),
                      const SizedBox(height: 10), // New spacing below toggle
                      // const SizedBox(height: DocvedaSizes.spaceBtwItems,),
                      DocvedaToggle(
                        isMonthly: isMonthly,
                        onToggle: _handleToggle,
                      ),
                      DateSwitcherBar(
                        selectedDate: selectedDate,
                        onPrevious: _goToPrevious,
                        onNext: _goToNext,
                        isMonthly: isMonthly,
                        textColor: Colors.white,
                        fontSize: 14,
                      ),

                      const SizedBox(height: 10),
                    ],
                  ),
                ),

                //  Text('Data length: ${dashboardData.length}'),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DocvedaSizes.defaultSpace,
                  ),
                  child: Column(
                    children: [
                      // PATIENT INFORMATION
                      DocvedaSectionHeading(
                        title: 'PATIENT INFORMATION',
                        showActionButton: false,
                        textStyle: TextStyle(
                          fontFamily: "Manrope",
                          fontSize: 16, // Adjust as needed
                          fontWeight:
                              FontWeight.bold, // Optional: Adjust weight
                          color: Colors.black, // Optional: Change color
                        ),
                      ),

                      const SizedBox(height: 20),
                      DocvedaGridLayout(
                        itemCount: dashboardData.length,
                        itemBuilder: (_, index) => Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              if (index < dashboardData.length) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return index == 0
                                          ? AdmissionScreen(filteredData[index]
                                              ['Dashboard_Mst_Cd'])
                                          : Dischargescreen(filteredData[index]
                                              ['Dashboard_Mst_Cd']);
                                    },
                                  ),
                                );
                              } else {
                                print(
                                  "Index $index is out of bounds for dashboardData length ${dashboardData.length}",
                                );
                              }
                            },
                            borderRadius: BorderRadius.circular(12),
                            splashColor: Colors.blue.withOpacity(0.2),
                            child: SizedBox(
                              height: 200,
                              child: DocvedaCard(
                                child: Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(Iconsax.activity),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              filteredData[index]
                                                      ['Dashboard_Title'] ??
                                                  "N/A",
                                              style: TextStyleFont.dashboardcard
                                                  .copyWith(fontSize: 12),
                                              softWrap: true,
                                              maxLines: 2,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              filteredData[index]['Records']
                                                      ?.toString() ??
                                                  '0',
                                              style: TextStyleFont.subheading
                                                  .copyWith(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
                      DocvedaCard(
                        width: double.infinity,
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Iconsax.arrange_circle_2),
                                const SizedBox(width: 10),
                                Text(
                                  "123",
                                  style: TextStyle(
                                    fontSize: DocvedaSizes
                                        .cardNumberSize, // Increase font size
                                    fontWeight:
                                        FontWeight.bold, // Make text bold
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(DocvedaTexts.dashboardItems3),
                              ],
                            ),
                            Icon(Iconsax.arrow_right_3),
                          ],
                        ),
                      ),
                      const SizedBox(height: DocvedaSizes.spaceBtwItems),
                      DocvedaSectionHeading(
                        title: 'PATIENT INFORMATION',
                        showActionButton: false,
                        textStyle: TextStyle(
                          fontFamily: "Manrope",
                          fontSize: 16, // Adjust as needed
                          fontWeight:
                              FontWeight.bold, // Optional: Adjust weight
                          color: Colors.black, // Optional: Change color
                        ),
                      ),

                      const SizedBox(height: DocvedaSizes.spaceBtwItems),
                      DocvedaGridLayout(
                        itemCount: 4,
                        itemBuilder: (_, index) => InkWell(
                          onTap: () {
                            if (dashboardItems[index + 3] ==
                                DocvedaTexts.dashboardItems5) {
                              // Navigate to the OPD Payments Screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Opdpaymentscreen(), // Your target screen
                                ),
                              );
                            } else if (dashboardItems[index + 3] ==
                                DocvedaTexts.dashboardItems4) {
                              // Navigate to OPD Bills
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Opdbillsscreen(),
                                ),
                              );
                            } else if (index + 3 == 6) {
                              // IPD Settlements
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Ipdsettlementsscreen(),
                                ),
                              );
                            } else if (dashboardItems[index + 3] ==
                                DocvedaTexts.dashboardItems6) {
                              // Navigate to Deposits Screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Depositsscreen(),
                                ),
                              );
                            }
                          },
                          child: DocvedaCard(
                            child: Container(
                              height: double.infinity,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Iconsax.activity),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          dashboardItems[index + 3],
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyleFont.dashboardcard,
                                        ),
                                        Text(
                                          "\u{20B9}12,000",
                                          style: TextStyleFont.subheading,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: DocvedaSizes.spaceBtwItems),

                      // EXPENSES
                      DocvedaSectionHeading(
                        title: 'PATIENT INFORMATION',
                        showActionButton: false,
                        textStyle: TextStyle(
                          fontFamily: "Manrope",
                          fontSize: 16, // Adjust as needed
                          fontWeight:
                              FontWeight.bold, // Optional: Adjust weight
                          color: Colors.black, // Optional: Change color
                        ),
                      ),

                      const SizedBox(height: DocvedaSizes.spaceBtwItems),
                      DocvedaGridLayout(
                        itemCount: 2,
                        itemBuilder: (_, index) => DocvedaCard(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: SizedBox(
                              height: double.infinity,
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dashboardItems[index + 5],
                                    style: TextStyleFont.dashboardcard,
                                  ), // Using dynamic list
                                  Text(
                                    "\u{20B9}4,700",
                                    style: TextStyleFont.subheading,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 30,
        ), // Adjust padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        content: SizedBox(
          width: 75, // Set a smaller width
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Log Out Form?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Divider(),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "All Devices",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              Divider(),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Current Device",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              Divider(),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
            ],
          ),
        ),
      );
    },
  );
}
