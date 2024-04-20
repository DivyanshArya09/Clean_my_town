import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/constants/default_contants.dart';
import 'package:app/core/enums/request_enums.dart';
import 'package:app/core/styles/app_styles.dart';
import 'package:app/core/utils/custom_spacers.dart';
import 'package:app/features/requests/presentation/blocs/request_bloc/request_bloc.dart';
import 'package:app/features/requests/presentation/models/request_model.dart';
import 'package:app/injection_container.dart';
import 'package:app/ui/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatusBottomSheet extends StatefulWidget {
  final RequestStatus status;
  final String requestId;
  final Function(RequestStatus) onChanged;
  const StatusBottomSheet(
      {super.key,
      required this.status,
      required this.onChanged,
      required this.requestId});

  @override
  State<StatusBottomSheet> createState() => _StatusBottomSheetState();
}

class _StatusBottomSheetState extends State<StatusBottomSheet> {
  String groupValue = '';
  List<String> value = [
    RequestStatus.pending.textValue,
    RequestStatus.inProgress.textValue,
    RequestStatus.completed.textValue
  ];

  @override
  void initState() {
    groupValue = widget.status.textValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RequestBloc, RequestState>(
      bloc: sl<RequestBloc>(),
      listener: (context, state) {
        if (state is UpdateRequestSuccess) {
          widget.onChanged(
            groupValue.requestStatus,
          );
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        if (state is UpdateRequestLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: DEFAULT_Horizontal_PADDING,
              vertical: DEFAULT_VERTICAL_PADDING),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Update Status",
                    style: AppStyles.headingDark,
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close),
                  )
                ],
              ),
              CustomSpacers.width32,
              ...List.generate(
                value.length,
                (index) => RadioListTile(
                  activeColor: AppColors.primary,
                  title:
                      Text(value[index], style: AppStyles.roboto_14_500_dark),
                  value: value[index],
                  groupValue: groupValue,
                  onChanged: (value) {
                    setState(
                      () {
                        groupValue = value as String;
                      },
                    );
                  },
                ),
              ),
              CustomSpacers.height30,
              CustomButton(
                btnTxt: 'Update',
                onTap: () {
                  sl.get<RequestBloc>().add(
                        UpdateRequestEvent(
                            entity: RequestUpdateEntity(
                                status: groupValue.requestStatus),
                            docId: widget.requestId),
                      );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
