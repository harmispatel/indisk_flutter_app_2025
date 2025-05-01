import 'package:flutter/material.dart';
import 'package:indisk_app/app_ui/common_widget/primary_button.dart';
import 'package:indisk_app/app_ui/screens/login/login_view.dart';
import 'package:indisk_app/main.dart';
import 'package:indisk_app/utils/common_colors.dart';
import 'package:indisk_app/utils/common_styles.dart';
import 'package:indisk_app/utils/common_utills.dart';

import '../../../database/app_preferences.dart';
import '../../../utils/app_dimens.dart';

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
      body: Column(
        children: [
          SizedBox(
            height: kToolbarHeight,
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              '${language.chooseYourPrefferedLanguage}:',
              style: getBoldTextStyle(fontSize: 28.0),
            ),
          ),
          Spacer(),
          Expanded(
            child: Center(
              child: ListView.builder(
                itemCount: _languageCodes.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final language = _languageCodes.keys.elementAt(index);
                  return Center(
                    child: InkWell(
                      onTap: () {
                        _selectedLanguage =
                            _languageCodes.values.elementAt(index);
                        setState(() {});
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 200.0,
                            height: 200.0,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            foregroundDecoration: BoxDecoration(
                                color: _selectedLanguage ==
                                        _languageCodes.values.elementAt(index)
                                    ? CommonColors.black.withAlpha(50)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10.0)),
                            decoration: BoxDecoration(
                                color: CommonColors.cardColor,
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _getLanguageFlag(language),
                                Text(
                                  language,
                                  style: getBoldTextStyle(fontSize: 28.0),
                                )
                              ],
                            ),
                          ),
                          if (_selectedLanguage ==
                              _languageCodes.values.elementAt(index))
                            Center(
                              child: Icon(
                                Icons.check_circle,
                                color: CommonColors.green,
                                size: 80.0,
                              ),
                            )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Spacer(),
          PrimaryButton(
              text: "${language.confirm}",
              onPressed: () async {
                if (_selectedLanguage.isNotEmpty) {
                  await SP.instance.setLanguageCode(_selectedLanguage);
                  pushAndRemoveUntil(LoginView());
                }
              }),
          kBottomPadding,
        ],
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
