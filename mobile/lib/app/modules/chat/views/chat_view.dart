import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';
import '../../../core/theme/app_theme.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5C3A1A), // Deep brown background
      appBar: AppBar(
        title: const Text('Chat'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/wallpaper.jpeg',
                ), // Egyptian pattern
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Optional decorative background image
          Opacity(
            opacity: 0.2,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              width: 350,
              height: 600,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/cat_man.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Column(
            children: [
              // Quick questions
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0, bottom: 4.0),
                      child: Text(
                        'Quick Questions',
                        style: TextStyle(
                          color: Color(0xFFF5E6C8),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.quickQuestions.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(right: 8),
                            child: ElevatedButton(
                              onPressed: () => controller.handleQuickQuestion(
                                controller.quickQuestions[index],
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFB88C4A),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                controller.quickQuestions[index],
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Messages area
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    itemCount:
                        controller.messages.length +
                        (controller.isTyping.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Check if this is the typing indicator
                      if (controller.isTyping.value &&
                          index == controller.messages.length) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage(
                                'assets/images/cat_man.png',
                              ),
                              radius: 24,
                            ),
                            const SizedBox(width: 12),
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF5E6C8),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 8,
                                      offset: Offset(2, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      margin: EdgeInsets.only(right: 4),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFB88C4A),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const LoadingDots(),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "AnubAI is consulting the ancient texts...",
                                      style: TextStyle(
                                        color: Color(0xFF5C3A1A),
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      // Regular message
                      final message = controller.messages[index];

                      if (message.isUser) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Color(
                                    0xFFB88C4A,
                                  ), // Brownish user bubble
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 8,
                                      offset: Offset(2, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      message.text,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      _formatTime(message.timestamp),
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        // AI message
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage(
                                'assets/images/cat_man.png',
                              ),
                              radius: 24,
                            ),
                            const SizedBox(width: 12),
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF5E6C8), // Parchment color
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 8,
                                      offset: Offset(2, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      message.text,
                                      style: TextStyle(
                                        color: Color(0xFF5C3A1A),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      _formatTime(message.timestamp),
                                      style: TextStyle(
                                        color: Color(
                                          0xFF5C3A1A,
                                        ).withOpacity(0.6),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
              // Input area
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFF5E6C8),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.textEditingController,
                        decoration: InputDecoration(
                          hintText: 'Ask me about ancient Egypt...',
                          border: InputBorder.none,
                          fillColor: Color(0xFFF5E6C8),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 16,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(fontSize: 16),
                        onChanged: controller.setInputMessage,
                        onSubmitted: (_) => controller.sendMessage(),
                      ),
                    ),
                    Obx(
                      () => Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFB88C4A),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.send, color: Colors.white),
                          onPressed: controller.isTyping.value
                              ? null
                              : controller.sendMessage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class LoadingDots extends StatefulWidget {
  const LoadingDots({super.key});

  @override
  _LoadingDotsState createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<LoadingDots>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final delay = index * 0.33;
            final animation = (_controller.value * 6.28 + delay) % 6.28;
            final position = 3 * math.sin(animation);
            return Transform.translate(
              offset: Offset(0, position),
              child: Container(
                width: 5,
                height: 5,
                margin: EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: Color(0xFF5C3A1A),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
