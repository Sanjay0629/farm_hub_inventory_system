import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AIChatScreenState createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final CollectionReference messages = FirebaseFirestore.instance.collection(
    'ai_chats',
  );
  final String openAIAPIKey =
      "sk-proj-bcOzsBhbzDr8OQyuYqyevULkQ7u_L9IQcu3SWEKufKO4VjRAYp6DJaE6o5YcP-wxspQE3HJB-ST3BlbkFJEuvqJk1ljZY1S3zxz9BDO2F81YQrpawOXe5ODtGWuK12D1dNwEY98MF4RMpfjDxu1gGaZDTKw"; // Replace with actual OpenAI API Key

  Future<void> _sendMessage(String userMessage) async {
    if (userMessage.isEmpty) return;

    // Add user message to Firestore
    await messages.add({
      'text': userMessage,
      'sender': 'user',
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Send request to OpenAI API
    String aiResponse = await _fetchAIResponse(userMessage);

    // Add AI response to Firestore
    await messages.add({
      'text': aiResponse,
      'sender': 'ai',
      'timestamp': FieldValue.serverTimestamp(),
    });

    _controller.clear();
  }

  Future<String> _fetchAIResponse(String userMessage) async {
    const String apiUrl = "https://api.openai.com/v1/chat/completions";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $openAIAPIKey",
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo", // You can use "gpt-4" if needed
          "messages": [
            {
              "role": "system",
              "content": "You are a helpful assistant for farmers.",
            },
            {"role": "user", "content": userMessage},
          ],
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        return jsonResponse['choices'][0]['message']['content'].toString();
      } else {
        print("OpenAI API Error: ${response.body}");
        return "Sorry, I couldn't process your request.";
      }
    } catch (e) {
      print("Error fetching AI response: $e");
      return "Error: Unable to connect to AI.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("FarmHub AI Chat")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  messages.orderBy('timestamp', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());

                return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var doc = snapshot.data!.docs[index];
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;

                    bool isUser = data['sender'] == 'user';

                    return Align(
                      alignment:
                          isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isUser ? Colors.green[300] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(data['text']),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Ask the AI something...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.green),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
