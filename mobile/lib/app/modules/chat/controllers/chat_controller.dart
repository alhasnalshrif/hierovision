import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../core/config/env.dart';

class Message {
  final int id;
  final String text;
  final bool isUser;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class ChatController extends GetxController {
  final RxBool isTyping = false.obs;
  final RxString inputMessage = ''.obs;
  final RxList<Message> messages = <Message>[].obs;

  // Text editing controller for the chat input
  late final TextEditingController textEditingController;

  // API key from environment configuration
  final String geminiApiKey = Environment.geminiApiKey;

  final List<String> quickQuestions = [
    "Tell me about the pyramids",
    "Explain hieroglyphs",
    "Who was Cleopatra?",
    "What is the Book of the Dead?",
    "Describe ancient Egyptian gods",
    "How were mummies made?",
  ];

  @override
  void onInit() {
    super.onInit();
    // Initialize the text controller
    textEditingController = TextEditingController();

    // Add initial welcome message
    messages.add(
      Message(
        id: 1,
        text:
            "Welcome to HieroVision's AnubAI! I am here to share the wisdom of ancient Egypt. Ask me about hieroglyphs, pharaohs, monuments, or any aspect of this magnificent civilization.",
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  void onClose() {
    // Dispose of the text controller when the controller is closed
    textEditingController.dispose();
    super.onClose();
  }

  void setInputMessage(String message) {
    inputMessage.value = message;
  }

  void handleQuickQuestion(String question) {
    inputMessage.value = question;
    textEditingController.text = question;
  }

  Future<void> sendMessage() async {
    if (inputMessage.value.trim().isEmpty) return;

    final userMessage = Message(
      id: messages.length + 1,
      text: inputMessage.value,
      isUser: true,
      timestamp: DateTime.now(),
    );

    messages.add(userMessage);

    final currentMessage = inputMessage.value;
    inputMessage.value = '';
    textEditingController.clear(); // Clear the text field
    isTyping.value = true;

    try {
      final aiResponseText = await callGeminiAPI(currentMessage);

      final aiResponse = Message(
        id: messages.length + 1,
        text: aiResponseText,
        isUser: false,
        timestamp: DateTime.now(),
      );

      messages.add(aiResponse);
    } catch (error) {
      print('Error generating response: $error');

      final errorResponse = Message(
        id: messages.length + 1,
        text:
            "I apologize, but I'm having trouble consulting the ancient texts right now. Please try again in a moment. 𓂀",
        isUser: false,
        timestamp: DateTime.now(),
      );

      messages.add(errorResponse);
    } finally {
      isTyping.value = false;
    }
  }

  Future<String> callGeminiAPI(String message) async {
    try {
      final prompt =
          '''You are AnubAI, an AI assistant specializing in ancient Egyptian history and culture. You have deep knowledge of hieroglyphs, pharaohs, monuments, gods, daily life, and all aspects of ancient Egyptian civilization. Respond to the following question about ancient Egypt in an engaging, educational manner. Keep responses informative but accessible. Add appropriate Egyptian hieroglyphic symbols (𓂀, 𓉴, 𓊪𓏏𓇯, etc.) occasionally to enhance the ancient Egyptian theme.

Question: $message''';

      final response = await http.post(
        Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent',
        ),
        headers: {
          'Content-Type': 'application/json',
          'X-goog-api-key': geminiApiKey,
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt},
              ],
            },
          ],
          'generationConfig': {'maxOutputTokens': 500, 'temperature': 0.7},
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('API request failed: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      return data['candidates'][0]['content']['parts'][0]['text'];
    } catch (error) {
      print('Error calling Gemini API: $error');
      return "I apologize, but I'm having trouble accessing the ancient texts right now. Please try asking your question again in a moment. 𓂀";
    }
  }
}
