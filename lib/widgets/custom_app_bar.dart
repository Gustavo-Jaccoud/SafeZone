import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(67);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actionsPadding: EdgeInsets.zero,
      titleSpacing: 0,
      toolbarHeight: 67,
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.primaryDark,

      flexibleSpace: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 60,

              decoration: const BoxDecoration(
                color: AppColors.white,

                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),

              child: Padding(
                padding: const EdgeInsets.all(10),

                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                  children: const [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Safe',

                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          TextSpan(
                            text: 'Zone',

                            style: TextStyle(
                              color: AppColors.textDark,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    FlutterLogo(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
    );
  }
}