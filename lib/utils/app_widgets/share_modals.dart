import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jyo_app/resources/app_colors.dart';
import 'package:jyo_app/resources/app_image.dart';
import 'package:jyo_app/resources/app_strings.dart';
import 'package:jyo_app/resources/app_styles.dart';
import 'package:jyo_app/utils/common.dart';

Future<void> shareModals(
  BuildContext context, {
  void Function()? onCreatePostTap,
  void Function()? onShareTap,
  void Function()? onCopyLinkTap,
  void Function()? onSendToFriend,
}) async {
  await showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadiusDirectional.only(
        topEnd: Radius.circular(25),
        topStart: Radius.circular(25),
      ),
    ),
    context: context,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.only(left: 22, right: 22, bottom: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 24,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColors.tabBkgColor,
                      borderRadius: BorderRadius.circular(100)),
                  width: 54,
                  height: 4,
                ),
              ),
            ),
            sizedBoxH(height: 16),
            Row(
              children: [
                _ShareModelsItem(
                  icon: AppBarIcons.shareHSvg,
                  text: AppStrings.shareVia,
                  onTap: onShareTap,
                ),
                sizedBoxW(width: 8),
                _ShareModelsItem(
                  icon: AppIcons.link,
                  text: AppStrings.createPost,
                  isSvg: false,
                  onTap: onCreatePostTap,
                ),
                sizedBoxW(width: 8),
                _ShareModelsItem(
                  icon: AppIcons.copyLink,
                  text: AppStrings.copyLink,
                  onTap: onCopyLinkTap,
                ),
                sizedBoxW(width: 8),
                _ShareModelsItem(
                  icon: AppIcons.sendToFriend,
                  text: AppStrings.sendToFriend,
                  onTap: onSendToFriend,
                ),
              ],
            ),
            sizedBoxH(height: 16),
            const _CancelButton(),
          ],
        ),
      );
    },
  );
}

class _ShareModelsItem extends StatelessWidget {
  const _ShareModelsItem({
    Key? key,
    required this.icon,
    required this.text,
    this.isSvg = true,
    this.onTap,
  }) : super(key: key);

  final String icon;
  final String text;
  final bool isSvg;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 81,
          width: 81,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: AppColors.tabBkgColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isSvg)
                SvgPicture.asset(
                  icon,
                  width: 24,
                  height: 24,
                )
              else
                Image.asset(
                  icon,
                  width: 24,
                  height: 24,
                ),
              Flexible(
                child: Text(
                  text,
                  style: AppStyles.interMediumStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CancelButton extends StatelessWidget {
  const _CancelButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context, rootNavigator: true).pop(),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.tabBkgColor,
        ),
        child: Center(
          child: Text(
            AppStrings.cancel,
            style: AppStyles.interMediumStyle(color: AppColors.editBorderColor),
          ),
        ),
      ),
    );
  }
}
