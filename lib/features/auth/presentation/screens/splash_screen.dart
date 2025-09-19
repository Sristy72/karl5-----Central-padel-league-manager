import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../core/common/constants/app_images.dart';
import '../../../../core/common/widgets/app_logo.dart';
import '../../../../core/common/widgets/app_scaffold.dart';
import '../controller/splash_screen_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final controller = Get.put(SplashController());
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: AppLogo(
              images: AppImages.appLogoPortrait,
              height: 144,
              width: 144,
            ),
          ),
        ],
      ),
    );
  }
}
