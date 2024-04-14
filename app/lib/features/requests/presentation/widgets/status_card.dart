import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/constants/default_contants.dart';
import 'package:app/core/styles/app_styles.dart';
import 'package:app/core/utils/custom_spacers.dart';
import 'package:app/features/requests/presentation/widgets/status_bar.dart';
import 'package:app/ui/custom_button.dart';
import 'package:flutter/material.dart';

class StatusCard extends StatelessWidget {
  const StatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: DEFAULT_Horizontal_PADDING,
          vertical: DEFAULT_Horizontal_PADDING,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Pending',
                  style: AppStyles.headingDark,
                ),
                Spacer(),
                Text('Opened', style: AppStyles.activetabStyle),
              ],
            ),
            CustomSpacers.height12,
            SizedBox(
              width: MediaQuery.of(context).size.width * .7,
              child: Text(
                softWrap: true,
                'Make sure to update status of your request as per progress.It will be visible to other users.',
                style:
                    AppStyles.roboto_14_400_dark.copyWith(color: AppColors.err),
              ),
            ),
            CustomSpacers.height10,
            DragableBar(),
            CustomSpacers.height10,
            CustomButton(btnTxt: 'Set Progress', onTap: () {})
          ],
        ),
      ),
    );
  }
}
