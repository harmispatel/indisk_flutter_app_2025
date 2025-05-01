
 import 'package:flutter/cupertino.dart';

import '../../utils/common_styles.dart';

class FormFieldLabel extends StatelessWidget {

  final String? label;

   const FormFieldLabel({Key? key,required this.label});

   @override
   Widget build(BuildContext context) {
     return  Text('$label', style: getMediumTextStyle(
         fontSize: 20.0
     ));
   }
 }
