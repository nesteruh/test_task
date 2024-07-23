import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../data/models/task.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TaskDetails extends StatelessWidget {
  final Task task;
  TaskDetails({required this.task});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 5.h),
        Container(
          width: 345.w,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Color(0xFFECF1F7),
            borderRadius: BorderRadius.circular(2.w),
          ),
          child: Column(
            children: [
              if(task.nameStaff=='0' && task.typeMachine=='0')
              Row(children: [Text('')],),
              task.nameStaff != '0'
                  ? Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: CachedNetworkImageProvider(
                              'https://media.istockphoto.com/id/1337144146/vector/default-avatar-profile-icon-vector.jpg?s=612x612&w=0&k=20&c=BIbFwuv7FxTWvh5S3vB6bkT0Qv8Vn8N5Ffseq84ClGI='),
                        ),
                        SizedBox(width: 10.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment(-0.70, 0),
                              child: Text(
                                task.nameStaff,
                                style: TextStyle(
                                    fontSize: 12.w,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [Text(task.positionStaff)],
                            ),
                          ],
                        ),
                      ],
                    )
                  : Row(),
              task.nameStaff != '0' ? SizedBox(height: 15.h) : SizedBox(),
              task.typeMachine != '0'
                  ? Row(
                      children: [
                        Image.asset(
                          machineTypePic(task.typeMachine) ?? '',
                          height: 50.h,
                          width: 55.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment(-0.70, 0),
                              child: Text(
                                '${task.brandMachine.toUpperCase()} ${task.modelMachine}',
                                style: TextStyle(
                                    fontSize: 12.w,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assets/tractor_icon.svg'),
                                Text(machineTypeStr(task.typeMachine)),
                                SizedBox(width: 5.w),
                                SvgPicture.asset('assets/profile_icon.svg'),
                                Text(
                                  abbreviateName(task.nameStaffMachine) +
                                      ' (' +
                                      task.positionStaffMachine +
                                      ')',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  : Row(),
            ],
          ),
        ),
      ],
    );
  }

  String? machineTypePic(String type) {
    if (type == 'tractor') {
      return 'assets/tractor.png';
    } else {
      return null;
    }
  }

  String machineTypeStr(String type) {
    if (type == 'tractor') {
      return 'Трактора';
    } else if (type == 'combine') {
      return 'Комбайн';
    } else if (type == 'plow') {
      return 'Плуг';
    }
    return type;
  }

  String abbreviateName(String fullName) {
    List<String> parts = fullName.split(' ');

    if (parts.length == 3) {
      String lastName = parts[0];
      String firstName = parts[1];
      String patronymic = parts[2];

      return '$lastName ${firstName[0]}.${patronymic[0]}.';
    } else {
      return fullName;
    }
  }
}
