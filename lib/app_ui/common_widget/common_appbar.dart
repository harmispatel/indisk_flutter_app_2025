import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:indisk_app/utils/common_styles.dart';

class CommonAppbar extends StatelessWidget implements PreferredSizeWidget {
  final double height;

  final String? title;

  final Function? onBackPressed;

  final List<Widget>? actions;

  final bool? isBackButtonVisible;

  CommonAppbar({
    required this.title,
    this.onBackPressed,
    this.actions,
    this.isBackButtonVisible = true,
    this.height = kToolbarHeight,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight + 23,
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).viewPadding.top,
          ),
          Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (isBackButtonVisible!)
                  InkWell(
                    onTap: () {
                      if (onBackPressed != null) {
                        onBackPressed!();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Icon(Icons.arrow_back),
                  )
                else
                  Container(
                    height: 30.0,
                    width: 40.0,
                  ),
                Text(title ?? "", style: getMediumTextStyle(fontSize: 20.0)),
                if (actions != null)
                  ...actions!
                else
                  Container(
                    height: 30.0,
                    width: 40.0,
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
