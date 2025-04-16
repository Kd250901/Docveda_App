// import 'package:docveda_app/utils/constants/colors.dart';
// import 'package:docveda_app/utils/constants/image_strings.dart';
// import 'package:docveda_app/utils/constants/sizes.dart';
// import 'package:flutter/material.dart';
// import 'package:docveda_app/common/widgets/app_text/app_text.dart';
// import 'package:docveda_app/common/widgets/appbar/appbar.dart';
// import 'package:docveda_app/common/widgets/custom_shapes/containers/primary_header_container.dart';
// import 'package:docveda_app/utils/theme/custom_themes/text_style_font.dart';
// import 'package:flutter/services.dart';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {

//     SystemChrome.setSystemUIOverlayStyle(
//     const SystemUiOverlayStyle(
//       statusBarColor: DocvedaColors.primaryColor,
//       statusBarIconBrightness: Brightness.light,
//       statusBarBrightness: Brightness.dark,
//     ),
//   );
    
//     return Scaffold(
//       backgroundColor: DocvedaColors.lightGrey,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             /// Main Content
//             Padding(
//               padding: const EdgeInsets.only(bottom: DocvedaSizes.padding),
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     /// Purple Header with custom header container
//                     DocvedaPrimaryHeaderContainer(
//                       child: Column(
//                         children: [
//                           DocvedaAppBar(
//                             title: const Center(
//                               child: DocvedaText(
//                                 text: 'Profile',
//                                 style: TextStyle(
//                                   color: DocvedaColors.white,
//                                   fontSize: DocvedaSizes.fontSizeLg,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                             showBackArrow: true,
//                           ),
                          
//                           const SizedBox(height: DocvedaSizes.spaceBtwItemsS),
//                           const CircleAvatar(
//                             radius: DocvedaSizes.profileAvatarRadius,
//                             backgroundImage:
//                                 AssetImage(DocvedaImages.clinicLogo),
//                             backgroundColor: DocvedaColors.white,
//                           ),
//                           const SizedBox(height: DocvedaSizes.spaceBtwItemsS),
//                           const DocvedaText(
//                             text: "Samarth Hospital",
//                             style: TextStyle(
//                               color: DocvedaColors.white,
//                               fontWeight: FontWeight.bold,
//                               fontSize: DocvedaSizes.fontSizeLg,
//                             ),
//                           ),
//                           const SizedBox(height: DocvedaSizes.spaceBtwItems),
//                         ],
//                       ),
//                     ),

//                     /// Info Tiles
//                     const SizedBox(height: DocvedaSizes.spaceBtwItems),
//                     _buildInfoTile("Doctor Name", "Dr. Shailesh Kulkarni"),
//                     _buildInfoTile("Mobile Number", "+91 9876543210"),
//                     _buildInfoTile("Email ID", "shaileshk@gmail.com"),
//                     _buildInfoTile("Area", "Tilak Nagar"),
//                     _buildInfoTile("City", "Mumbai"),
//                     const SizedBox(height: 80),
//                   ],
//                 ),
//               ),
//             ),

//             /// Fixed App Version
//             Positioned(
//               bottom: DocvedaSizes.bottomSize,
//               left: DocvedaSizes.leftSize,
//               right: DocvedaSizes.rightSize,
//               child: Center(
//                 child: DocvedaText(
//                   text: "App Version\nv 1.0.1",
//                   textAlign: TextAlign.center,
//                   style: TextStyleFont.body.copyWith(
//                     color: DocvedaColors.grey,
//                     fontSize: DocvedaSizes.fontSize,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   static Widget _buildInfoTile(String title, String value) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//       decoration: BoxDecoration(
//         color: DocvedaColors.white,
//         borderRadius: BorderRadius.circular(DocvedaSizes.borderaRadiusLg),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           DocvedaText(
//             text: title,
//             style: const TextStyle(
//               fontSize: DocvedaSizes.fontSizeSm,
//               color: DocvedaColors.grey,
//             ),
//           ),
//           const SizedBox(height: DocvedaSizes.spaceBtwItemsSsm),
//           DocvedaText(
//             text: value,
//             style: const TextStyle(
//               fontSize: DocvedaSizes.fontSizeMd,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:docveda_app/common/widgets/app_text/app_text.dart';
import 'package:docveda_app/utils/constants/colors.dart';
import 'package:docveda_app/utils/constants/image_strings.dart';
import 'package:docveda_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: keyboardSpace + DocvedaSizes.md,
        ),
        child: Column(
          children: [
            /// Header Section with Background and Avatar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              decoration: BoxDecoration(
                color: DocvedaColors.primaryColor,
                image: DecorationImage(
                  image: AssetImage(DocvedaImages.clinicLogo), // ➕ Use your image
                  colorFilter: ColorFilter.mode(
                    DocvedaColors.primaryColor.withOpacity(0.85),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Column(
                children: const [
                  CircleAvatar(
                    radius: DocvedaSizes.profileAvatarRadius,
                    backgroundImage: AssetImage(DocvedaImages.clinicLogo),
                    backgroundColor: DocvedaColors.white,
                  ),
                  SizedBox(height: DocvedaSizes.spaceBtwItemsS),
                  DocvedaText(
                    text: "Samarth Hospital",
                    style: TextStyle(
                      color: DocvedaColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: DocvedaSizes.fontSizeLg,
                    ),
                  ),
                ],
              ),
            ),

            // const SizedBox(height: DocvedaSizes.spaceBtwSections),

            /// Info Tiles
            _buildInfoTile("Doctor Name", "Dr. Shailesh Kulkarni"),
            _buildInfoTile("Mobile Number", "+91 9876543210"),
            _buildInfoTile("Email ID", "shaileshk@gmail.com"),
            _buildInfoTile("Area", "Tilak Nagar"),
            _buildInfoTile("City", "Mumbai"),

            
          ],
        ),
      ),
    );
  }

  /// Reusable Info Tile Widget
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
            style: const TextStyle(
              fontSize: DocvedaSizes.fontSizeSm,
              color: DocvedaColors.grey,
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
