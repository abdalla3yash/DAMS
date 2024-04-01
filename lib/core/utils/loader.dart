import 'package:dams/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AppLoader extends StatelessWidget {
  final String? progress,titleAction;

  const AppLoader({super.key,this.progress,this.titleAction});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SpinKitCubeGrid(color: AppColors.primary, size: 64),
            const SizedBox(height: 12),
            Text(titleAction ?? '',style: const TextStyle(fontSize: 18,color: AppColors.black),),
            progress == null ? const SizedBox() : Text('$progress %',style: const TextStyle(fontSize: 18,color: AppColors.black)),
          ],
        ),
      );
}
