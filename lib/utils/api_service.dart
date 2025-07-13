import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl:
          'https://skincheckbackend.onrender.com', // ganti sesuai IP backend kamu
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  // Ambil token dan set di header setiap kali request
  static Future<void> _setAuthToken() async {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user?.getIdToken();

    if (token != null) {
      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.options.headers["Content-Type"] = "application/json";
    }
  }

  // POST ke endpoint /chat
  static Future<String?> sendChat({
    required String chatId,
    required String timestamp,
    String? message,
    String? imageBase64,
  }) async {
    try {
      await _setAuthToken();
      final user = FirebaseAuth.instance.currentUser;
      final userId = user!.uid;
      final response = await _dio.post(
        '/chat',
        data: {
          "chat_id": chatId,
          "timestamp": timestamp,
          "message": message ?? "",
          "image_base64": imageBase64 ?? "",
          "user_id": userId ?? "",
        },
      );

      return response.data['reply'];
    } on DioException catch (e) {
      print("API Error: ${e.response?.data}");
      return null;
    }
  }

  // GET riwayat chat user
  static Future<List<dynamic>> getChatHistory({required String chatId}) async {
    try {
      await _setAuthToken();
      final user = FirebaseAuth.instance.currentUser;
      final userId = user!.uid;
      final response = await _dio.get('/chat/$userId/$chatId/history');
      return response.data['history'];
    } on DioException catch (e) {
      print("Get History Error: ${e.response}");
      return [];
    }
  }
}
