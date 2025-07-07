import 'package:flutter/material.dart';
import 'register_screen.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String selectedLanguage = 'English';

  final List<Map<String, String>> languages = [
    {'name': 'English', 'subtitle': 'Hi'},
    {'name': 'Hindi', 'subtitle': 'नमस्ते'},
    {'name': 'Bengali', 'subtitle': 'হ্যালো'},
    {'name': 'Kannada', 'subtitle': 'ನಮಸ್ಕಾರ'},
    {'name': 'Punjabi', 'subtitle': 'ਸਤ ਸ੍ਰੀ ਅਕਾਲ'},
    {'name': 'Tamil', 'subtitle': 'வணக்கம்'},
    {'name': 'Telugu', 'subtitle': 'హలో'},
    {'name': 'French', 'subtitle': 'Bonjour'},
    {'name': 'Spanish', 'subtitle': 'Hola'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                textAlign: TextAlign.center,
                'Choose Your Language',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Color.fromRGBO(203, 213, 225, 1),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: languages.length,
                    separatorBuilder:
                        (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final language = languages[index];
                      final isSelected = selectedLanguage == language['name'];

                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedLanguage = language['name']!;
                          });
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      language['name']!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      language['subtitle']!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? Colors.black
                                            : Colors.grey[400]!,
                                    width: 2,
                                  ),
                                  color:
                                      isSelected
                                          ? Colors.black
                                          : Colors.transparent,
                                ),
                                child:
                                    isSelected
                                        ? const Icon(
                                          Icons.circle,
                                          size: 9,
                                          color: Colors.white,
                                        )
                                        : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedLanguage == 'English') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('This language is not available yet!'),
                          backgroundColor: Colors.orange,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4285F4),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Select',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
