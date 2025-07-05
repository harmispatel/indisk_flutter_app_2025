import 'package:flutter/material.dart';
import 'package:indisk_app/main.dart';
import 'package:indisk_app/utils/common_colors.dart';
import 'package:indisk_app/utils/common_styles.dart';

import '../../../database/app_preferences.dart';
import '../../../utils/app_dimens.dart';
import '../../../utils/common_utills.dart';
import '../login/login_view.dart';

class LanguagesView extends StatefulWidget {
  const LanguagesView({super.key});

  @override
  State<LanguagesView> createState() => _LanguagesViewState();
}

class _LanguagesViewState extends State<LanguagesView> {
  String _selectedLanguage = '';
  final Map<String, String> _languageCodes = {
    'English': 'en',
    'Danish': 'da',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                '${language.chooseYourPrefferedLanguage}:',
                style: getBoldTextStyle(fontSize: 28.0),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _languageCodes.keys.map((language) {
                final isSelected =
                    _selectedLanguage == _languageCodes[language];
                return GestureDetector(
                  onTap: () async {
                    _selectedLanguage = _languageCodes[language]!;
                    await SP.instance.setLanguageCode(_selectedLanguage);
                    pushAndRemoveUntil(LoginView());
                    setState(() {});
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 200.0,
                        height: 200.0,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        foregroundDecoration: BoxDecoration(
                          color: isSelected
                              ? CommonColors.black.withAlpha(50)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        decoration: BoxDecoration(
                          color: CommonColors.cardColor,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _getLanguageFlag(language),
                            Text(
                              language,
                              style: getBoldTextStyle(fontSize: 28.0),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check_circle,
                          color: CommonColors.green,
                          size: 80.0,
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            // Uncomment if you want to add confirm button
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //   child: PrimaryButton(
            //     text: "${language.confirm}",
            //     onPressed: () async {
            //       if (_selectedLanguage.isNotEmpty) {
            //         await SP.instance.setLanguageCode(_selectedLanguage);
            //         pushAndRemoveUntil(LoginView());
            //       }
            //     },
            //   ),
            // ),
            SizedBox(height: 16), // instead of kBottomPadding
          ],
        ),
      ),
    );
  }

  Widget _getLanguageFlag(String language) {
    switch (language) {
      case 'English':
        return const Text('🇬🇧', style: TextStyle(fontSize: 80));
      case 'Danish':
        return const Text('🇩🇰', style: TextStyle(fontSize: 80));
      default:
        return const Text('🌐', style: TextStyle(fontSize: 80));
    }
  }
}
