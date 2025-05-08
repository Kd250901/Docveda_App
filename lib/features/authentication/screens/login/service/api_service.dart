import 'dart:convert';
import 'package:docveda_app/utils/encryption/aes_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:docveda_app/utils/helpers/unauthorized_helper.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.10.132:4000/api';
  // static const String baseUrl = 'https://api-uat-dv.docveda.in/api';

  Future<Map<String, dynamic>> issueAuthCode(
    String username,
    String password,
    String code_challenger,
  ) async {
    final Uri apiUrl = Uri.parse(
      '$baseUrl/auth/auth_code?code_challenge=$code_challenger',
    );
    print("apiUrl: $apiUrl");
    print("baseUrl: $baseUrl");

    var encryptedText = AESHelper.encryptText(password);
    print("Username: $username");
    print("Password (Before Encryption): $password");
    print("Password (After Encryption): $encryptedText");

    try {
      final response = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userName': username,
          'password': encryptedText,
          'source': 'App',
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        // Handle unauthorized
        UnauthorizedHelper.handle();
        return Future.error('Unauthorized access');
      } else {
        throw Exception('Failed to authenticate: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error during login: $e');
    }
  }

  Future<Map<String, dynamic>> issueToken(
    String authorizationCode,
    String codeVerifer,
  ) async {
    final Uri apiUrl = Uri.parse('$baseUrl/auth/token');

    try {
      print(
        " Requesting token with Authorization Code: $authorizationCode and Code Verifier: $codeVerifer",
      );

      final response = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'code': authorizationCode,
          'code_verifier': codeVerifer,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        UnauthorizedHelper.handle(); // 👈 Handle session expiry
        return Future.error('Unauthorized access');
      } else {
        throw Exception('Failed to get tokens: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error during token exchange: $e');
    }
  }

  Future<Map<String, dynamic>> getUserAccess(
    String roleId,
    String token,
  ) async {
    final Uri apiUrl = Uri.parse('$baseUrl/auth/get_user_access/$roleId');

    try {
      final response = await http.get(
        apiUrl,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        UnauthorizedHelper.handle(); // 👈 Optional: global redirect or logout
        throw Exception('Unauthorized access');
      } else {
        throw Exception('Failed to fetch user access: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error during user access fetch: $e');
    }
  }

  Future<Map<String, dynamic>?> getCards(
    String accessToken,
    BuildContext context, {
    required bool isMonthly,
    required String pDate,
    required String pType,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/frontdesk/app/getDashboardCount'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'P_Date': pDate,
          'P_Type': pType,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        print("unAuthorized...");
        UnauthorizedHelper.handle();
        return null;
      } else {
        print('Failed to load cards: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching cards: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getBedTransfer(
    String accessToken,
    BuildContext context, {
    required bool isMonthly,
    required String pDate,
    required String pType,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/frontdesk/app/getBedTransfer'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'P_Date': pDate,
          'P_Type': pType,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        print("unAuthorized...");
        UnauthorizedHelper.handle();
        return null;
      } else {
        print('Failed to load cards: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching cards: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getAdmissionData(
    String accessToken,
    BuildContext context, {
    required bool isMonthly,
    required String pDate,
    required String pType,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          '$baseUrl/frontdesk/app/getAdmission',
        ),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json', // Ensure correct headers
        },
        body: jsonEncode({
          'P_Date': pDate,
          'P_Type': pType,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        UnauthorizedHelper.handle();
        return null;
      } else {
        print('Failed to load getAdmissionData: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching getAdmissionData: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getOpdBillsData(
    String accessToken,
    BuildContext context, {
    required bool isMonthly,
    required String pDate,
    required String pType,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          '$baseUrl/frontdesk/app/getOpdBills',
        ),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json', // Ensure correct headers
        },
        body: jsonEncode({
          'P_Date': pDate,
          'P_Type': pType,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        UnauthorizedHelper.handle();
        return null;
      } else {
        print('Failed to load getOpdBillsData: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching getOpdBillsData: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getOpdPaymnetData(
    String accessToken,
    BuildContext context, {
    required bool isMonthly,
    required String pDate,
    required String pType,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          '$baseUrl/frontdesk/app/getOPDPayments',
        ),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json', // Ensure correct headers
        },
        body: jsonEncode({
          'P_Date': pDate,
          'P_Type': pType,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        UnauthorizedHelper.handle();
        return null;
      } else {
        print('Failed to load getOpdPaymnetData: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching getOpdPaymnetData: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getOpdVisitData(
    String accessToken,
    BuildContext context, {
    required bool isMonthly,
    required String pDate,
    required String pType,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          '$baseUrl/frontdesk/app//getVisit',
        ),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json', // Ensure correct headers
        },
        body: jsonEncode({
          'P_Date': pDate,
          'P_Type': pType,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        UnauthorizedHelper.handle();
        return null;
      } else {
        print('Failed to load getVisit: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching getVisit: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getDepositData(
    String accessToken,
    BuildContext context, {
    required bool isMonthly,
    required String pDate,
    required String pType,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          '$baseUrl/frontdesk/app/getDeposite',
        ),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json', // Ensure correct headers
        },
        body: jsonEncode({
          'P_Date': pDate,
          'P_Type': pType,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        UnauthorizedHelper.handle();
        return null;
      } else {
        print('Failed to load getOpdPaymnetData: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching getOpdPaymnetData: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getDiscountData(
    String accessToken,
    BuildContext context, {
    required bool isMonthly,
    required String pDate,
    required String pType,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          '$baseUrl/frontdesk/app/getDiscount',
        ),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json', // Ensure correct headers
        },
        body: jsonEncode({
          'P_Date': pDate,
          'P_Type': pType,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        UnauthorizedHelper.handle();
        return null;
      } else {
        print('Failed to load getOpdPaymnetData: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching getOpdPaymnetData: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getRefundData(
    String accessToken,
    BuildContext context, {
    required bool isMonthly,
    required String pDate,
    required String pType,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          '$baseUrl/frontdesk/app/getRefund',
        ),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json', // Ensure correct headers
        },
        body: jsonEncode({
          'P_Date': pDate,
          'P_Type': pType,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        UnauthorizedHelper.handle();
        return null;
      } else {
        print('Failed to load getOpdPaymnetData: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching getOpdPaymnetData: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getDischargaeData(
    String accessToken,
    BuildContext context, {
    required bool isMonthly,
    required String pDate,
    required String pType,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          '$baseUrl/frontdesk/app/getIPDDischarge',
        ),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json', // Ensure correct headers
        },
        body: jsonEncode({
          'P_Date': pDate,
          'P_Type': pType,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        UnauthorizedHelper.handle();
        return null;
      } else {
        print('Failed to load getOpdPaymnetData: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching getOpdPaymnetData: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getIpdSettlementData(
    String accessToken,
    BuildContext context, {
    required bool isMonthly,
    required String pDate,
    required String pType,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          '$baseUrl/frontdesk/app/getIPDSettelment',
        ),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json', // Ensure correct headers
        },
        body: jsonEncode({
          'P_Date': pDate,
          'P_Type': pType,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        UnauthorizedHelper.handle();
        return null;
      } else {
        print('Failed to load getOpdPaymnetData: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching getOpdPaymnetData: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getProfileData(
    String accessToken,
    BuildContext context, {
    required String mobile_no,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          '$baseUrl/frontdesk/app/getProfile',
        ),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json', // Ensure correct headers
        },
        body: jsonEncode({
          'mobile_no': mobile_no,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        UnauthorizedHelper.handle();
        return null;
      } else {
        print('Failed to load getProfileData: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching getProfileData: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getDeviceId(
    String accessToken,
    BuildContext context, {
    required String mobile_no,
    required String deviceId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          '$baseUrl/frontdesk/app/checkDeviceId',
        ),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json', // Ensure correct headers
        },
        body: jsonEncode({
          'mobile_no': mobile_no,
          'deviceId': deviceId,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        UnauthorizedHelper.handle();
        return null;
      } else {
        print('Failed to load getProfileData: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching getProfileData: $e');
      return null;
    }
  }
}
