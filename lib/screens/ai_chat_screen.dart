import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../theme/app_theme.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<_Message> _messages = [];
  bool _loading = false;

  // ⚠️  Replace with your Gemini API key (free at aistudio.google.com)
  static const _apiKey = 'AIzaSyAQ.Ab8RN6Jv4SvJ_drhcujOrZSWtI6y7ksol8rDoEksfEqkSGjumw';

  static const _systemPrompt = '''
You are AURA, an AI Life Manager that helps people manage their energy, not just their tasks.
You give concise, warm, practical advice about:
- Daily planning based on energy levels
- When to eat, move, and rest
- Task prioritization (high-energy work = deep tasks, low-energy = admin)
- Habit building and self-compassion

Keep responses short (3–5 sentences max), actionable, and encouraging.
Never lecture. Be a smart friend, not a productivity guru.
''';

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_Message(text: text, isUser: true));
      _loading = true;
    });
    _controller.clear();
    _scrollToBottom();

    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: _apiKey,
        systemInstruction: Content.system(_systemPrompt),
      );

      final history = _messages
          .where((m) => !m.isLoading)
          .map((m) => m.isUser
              ? Content.user(m.text)
              : Content.model([TextPart(m.text)]))
          .toList();

      final response = await model.generateContent(history);
      final reply = response.text ?? 'I couldn\'t process that. Try again.';

      setState(() {
        _messages.add(_Message(text: reply, isUser: false));
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(_Message(
          text: 'Connection error. Check your API key in the code.',
          isUser: false,
          isError: true,
        ));
        _loading = false;
      });
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    gradient: AuraTheme.accentGrad,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(child: Text('✦', style: TextStyle(color: Colors.white, fontSize: 16))),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('AURA AI', style: TextStyle(color: AuraTheme.textPrim, fontSize: 16, fontWeight: FontWeight.w700)),
                    Text('Your life manager', style: TextStyle(color: AuraTheme.textSec, fontSize: 11)),
                  ],
                ),
                const Spacer(),
                Container(
                  width: 8, height: 8,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: AuraTheme.accent),
                ),
                const SizedBox(width: 6),
                const Text('Online', style: TextStyle(color: AuraTheme.accent, fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Divider(color: AuraTheme.border, height: 1),

          // Messages
          Expanded(
            child: _messages.isEmpty
                ? _emptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(20),
                    itemCount: _messages.length + (_loading ? 1 : 0),
                    itemBuilder: (ctx, i) {
                      if (i == _messages.length) return _typingIndicator();
                      return _MessageBubble(message: _messages[i]);
                    },
                  ),
          ),

          // Input
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            decoration: BoxDecoration(
              color: AuraTheme.surface,
              border: const Border(top: BorderSide(color: AuraTheme.border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _send(),
                    style: const TextStyle(color: AuraTheme.textPrim, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Ask AURA anything...',
                      hintStyle: const TextStyle(color: AuraTheme.textMuted, fontSize: 14),
                      filled: true,
                      fillColor: AuraTheme.card,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AuraTheme.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AuraTheme.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AuraTheme.accent, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _send,
                  child: Container(
                    width: 46, height: 46,
                    decoration: BoxDecoration(
                      gradient: AuraTheme.accentGrad,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.arrow_upward_rounded, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
Widget _emptyState() {
    final suggestions = [
      'Plan my day — I have medium energy',
      'I keep skipping lunch, help',
      'What should I tackle first today?',
      'I feel burnt out, what should I do?',
    ];
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('✦', style: TextStyle(fontSize: 48, color: AuraTheme.accent)),
          const SizedBox(height: 12),
          const Text('How can I help today?', style: TextStyle(
            color: AuraTheme.textPrim, fontSize: 20, fontWeight: FontWeight.w700,
          )),
          const SizedBox(height: 8),
          const Text('Try one of these', style: TextStyle(color: AuraTheme.textSec, fontSize: 13)),
          const SizedBox(height: 20),
          ...suggestions.map((s) => GestureDetector(
            onTap: () {
              _controller.text = s;
              _send();
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AuraTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AuraTheme.border),
              ),
              child: Row(
                children: [
                  Expanded(child: Text(s, style: const TextStyle(color: AuraTheme.textSec, fontSize: 13))),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AuraTheme.textMuted),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _typingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 30, height: 30,
            decoration: BoxDecoration(gradient: AuraTheme.accentGrad, borderRadius: BorderRadius.circular(8)),
            child: const Center(child: Text('✦', style: TextStyle(color: Colors.white, fontSize: 12))),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AuraTheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AuraTheme.border),
            ),
            child: const Text('AURA is thinking...', style: TextStyle(color: AuraTheme.textSec, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final _Message message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 30, height: 30,
              decoration: BoxDecoration(gradient: AuraTheme.accentGrad, borderRadius: BorderRadius.circular(8)),
              child: const Center(child: Text('✦', style: TextStyle(color: Colors.white, fontSize: 12))),
            ),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: message.isUser
                    ? AuraTheme.accentGrad
                    : null,
                color: message.isUser ? null : (message.isError ? Colors.red.withOpacity(0.1) : AuraTheme.surface),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(14),
                  topRight: const Radius.circular(14),
                  bottomLeft: Radius.circular(message.isUser ? 14 : 4),
                  bottomRight: Radius.circular(message.isUser ? 4 : 14),
                ),
                border: message.isUser ? null : Border.all(color: AuraTheme.border),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : (message.isError ? Colors.redAccent : AuraTheme.textPrim),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Message {
  final String text;
  final bool isUser;
  final bool isError;
  final bool isLoading;
  const _Message({required this.text, required this.isUser, this.isError = false, this.isLoading = false});
}
