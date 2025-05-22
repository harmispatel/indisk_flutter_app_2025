import 'package:flutter/material.dart';
import 'package:indisk_app/app_ui/screens/splash/splash_view_model.dart';
import 'package:indisk_app/utils/common_colors.dart';
import 'package:indisk_app/utils/local_images.dart';
import 'package:provider/provider.dart';

 class SplashView extends StatefulWidget {
   const SplashView({super.key});

   @override
   State<SplashView> createState() => _SplashViewState();
 }

 class _SplashViewState extends State<SplashView> {

   late SplashViewModel mViewModel;

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero,(){
      mViewModel.attachedContext(context);
    });
  }

   @override
   Widget build(BuildContext context) {
     mViewModel = Provider.of<SplashViewModel>(context);
     return Scaffold(
       backgroundColor: CommonColors.white,
       body: Center(
         child: Image.asset(LocalImages.appLogo,height: 100.0,width: 100.0,),
       ),
     );
   }
 }
