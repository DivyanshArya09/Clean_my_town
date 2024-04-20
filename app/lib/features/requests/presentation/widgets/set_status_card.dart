import 'dart:async';

import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/constants/default_contants.dart';
import 'package:app/core/enums/request_enums.dart';
import 'package:app/core/styles/app_styles.dart';
import 'package:app/core/utils/custom_spacers.dart';
import 'package:app/features/requests/presentation/models/request_model.dart';
import 'package:app/features/requests/presentation/widgets/status_bottom_sheet.dart';
import 'package:app/ui/custom_button.dart';
import 'package:flutter/material.dart';

class SetStatusCard extends StatefulWidget {
  final RequestModel requestModel;
  const SetStatusCard({super.key, required this.requestModel});

  @override
  State<SetStatusCard> createState() => _SetStatusCardState();
}

class _SetStatusCardState extends State<SetStatusCard> {
  StreamController<RequestStatus> _streamController =
      StreamController<RequestStatus>.broadcast();

  RequestStatus? statusValue;

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _streamController.add(widget.requestModel.status);
    });
    super.initState();
  }

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
            _buildStatusText(),
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
            CustomButton(
                btnTxt: 'Change Status',
                onTap: () => _showBottomSheet(context)),
          ],
        ),
      ),
    );
  }

  _buildStatusText() {
    return StreamBuilder<RequestStatus>(
      stream: _streamController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          statusValue = snapshot.data;
          return Text(
            snapshot.data!.statusValue,
            style: AppStyles.headingDark.copyWith(
              color: snapshot.data!.colorValue,
            ),
          );
        }
        return SizedBox();
      },
    );
  }

  _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => StatusBottomSheet(
        requestId: widget.requestModel.docId!,
        status: statusValue ?? widget.requestModel.status,
        onChanged: (status) {
          _streamController.add(status);
        },
      ),
    );
  }
}
