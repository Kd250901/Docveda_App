import 'package:docveda_app/common/widgets/app_text/app_text.dart';
import 'package:docveda_app/features/authentication/screens/login/login.dart';
import 'package:docveda_app/features/authentication/screens/login/service/api_service.dart';
import 'package:docveda_app/utils/constants/colors.dart';
import 'package:docveda_app/utils/constants/image_strings.dart';
import 'package:docveda_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService apiService = ApiService();

  Map<String, dynamic>? profileData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    // print("Fetching profile data...");
    final data = await fetchProfileData();
    // print("Profile data fetched: $data");
    if (mounted) {
      setState(() {
        profileData = data;
        isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>?> fetchProfileData() async {
    // print("In fetchProfileData method");

    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'accessToken');
    final username = await storage.read(key: 'username');

    final mobileNo = username;

    // print("Access Token: $accessToken");
    // print("Mobile Number: $mobileNo");

    if (accessToken != null && mobileNo != null) {
      try {
        final response = await apiService.getProfileData(
          accessToken,
          context,
          mobile_no: mobileNo,
        );

        // print("API Response: $response");

        if (response != null && response['statusCode'] == 401) {
          print("Unauthorized. Redirecting to login.");
          _redirectToLogin();
          return null;
        }

        if (response != null && response['data'] != null) {
          final data = response['data'];

          // Check if it's a list
          final rawData = data is List && data.isNotEmpty ? data.first : data;

          return {
            'name': rawData['f_DV_Display_Name'] ?? 'N/A',
            'mobile_no': rawData['DOC_Mobile'] ?? 'N/A',
            'email': rawData['DOC_Email'] ?? 'N/A',
            'address': rawData['f_DV_Address_Line1'] ?? 'N/A',
            'area': rawData['f_DV_Locality'] ?? 'N/A',
            'city': rawData['f_DV_City_Name'] ?? 'N/A',
            'pincode': rawData['f_DV_Pincode'] ?? 'N/A',
            'logopath': rawData['Logo_Path'] ?? 'N/A',
            'base64': rawData['Base64_Logo_Path'] ?? 'N/A',
            'clinic_name': rawData['f_DV_Clinic_Name'] ?? 'N/A',
          };
        }

        return null;
      } catch (e) {
        print('Error fetching profile data: $e');
        return null;
      }
    } else {
      print("AccessToken or mobileNo is null. Redirecting to login.");
      _redirectToLogin();
      return null;
    }
  }

  void _redirectToLogin() {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAll(() => const LoginScreen());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: AppBar(
        title: const DocvedaText(
          text: "Profile",
          style: TextStyle(color: DocvedaColors.white),
        ),
        backgroundColor: DocvedaColors.primaryColor,
        foregroundColor: DocvedaColors.white,
        iconTheme: const IconThemeData(color: DocvedaColors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : profileData == null
              ? const Center(child: Text("Failed to load profile"))
              : SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: keyboardSpace + DocvedaSizes.md,
                  ),
                  child: Column(
                    children: [
                      /// Header Section

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        decoration: BoxDecoration(
                          color: DocvedaColors.primaryColor,
                          image: profileData?['base64'] != null
                              ? DecorationImage(
                                  image: MemoryImage(
                                    base64Decode(
                                        profileData!['base64'].split(',').last),
                                  ),
                                  colorFilter: ColorFilter.mode(
                                    DocvedaColors.primaryColor
                                        .withOpacity(0.85),
                                    BlendMode.darken,
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : DecorationImage(
                                  image: AssetImage(DocvedaImages.clinicLogo),
                                  colorFilter: ColorFilter.mode(
                                    DocvedaColors.primaryColor
                                        .withOpacity(0.85),
                                    BlendMode.darken,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        child: Column(
                          children: [
                            profileData?['base64'] != null
                                ? CircleAvatar(
                                    radius: DocvedaSizes.profileAvatarRadius,
                                    backgroundImage: MemoryImage(
                                      base64Decode(profileData!['base64']
                                          .split(',')
                                          .last),
                                    ),
                                    backgroundColor: DocvedaColors.white,
                                  )
                                : const CircleAvatar(
                                    radius: DocvedaSizes.profileAvatarRadius,
                                    backgroundImage:
                                        AssetImage(DocvedaImages.clinicLogo),
                                    backgroundColor: DocvedaColors.white,
                                  ),
                            const SizedBox(height: DocvedaSizes.spaceBtwItemsS),
                            DocvedaText(
                              text: profileData?['clinic_name'] ?? 'N/A',
                              style: const TextStyle(
                                color: DocvedaColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: DocvedaSizes.fontSizeLg,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// Info Tiles
                      _buildInfoTile(
                          "Doctor Name", profileData?['name'] ?? 'N/A'),
                      _buildInfoTile(
                          "Mobile Number", profileData?['mobile_no'] ?? 'N/A'),
                      _buildInfoTile(
                          "Email ID", profileData?['email'] ?? 'N/A'),
                      _buildInfoTile(
                          "Address", profileData?['address'] ?? 'N/A'),
                      _buildInfoTile("Area", profileData?['area'] ?? 'N/A'),
                      _buildInfoTile("City", profileData?['city'] ?? 'N/A'),
                      _buildInfoTile(
                          "Pincode", profileData?['pincode'] ?? 'N/A'),
                    ],
                  ),
                ),
    );
  }

  /// Reusable Info Tile
  Widget _buildInfoTile(String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: DocvedaColors.white,
        borderRadius: BorderRadius.circular(DocvedaSizes.borderaRadiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DocvedaText(
            text: title,
            style: TextStyle(
              fontSize: DocvedaSizes.fontSizeSm,
              color: DocvedaColors.textTitle,
            ),
          ),
          const SizedBox(height: DocvedaSizes.spaceBtwItemsSsm),
          DocvedaText(
            text: value,
            style: const TextStyle(
              fontSize: DocvedaSizes.fontSizeMd,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
