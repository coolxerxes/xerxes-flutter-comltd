import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';
import 'package:jyo_app/resources/app_colors.dart';
import 'package:jyo_app/resources/app_routes.dart';
import 'package:jyo_app/resources/app_strings.dart';
import 'package:jyo_app/utils/common.dart';

import '../repository/registration_repo/registration_repo_impl.dart';
import '../utils/secured_storage.dart';

class BirthdayScreenVM extends GetxController {
  RegistrationRepoImpl registrationRepoImpl = RegistrationRepoImpl();
  
  DateTime? selectedDate = DateTime(1993, 1, 1);
  String? selectedDateStr;

  TextEditingController d1Ctrl = TextEditingController();
  TextEditingController d2Ctrl = TextEditingController();

  TextEditingController m1Ctrl = TextEditingController();
  TextEditingController m2Ctrl = TextEditingController();

  TextEditingController y1Ctrl = TextEditingController();
  TextEditingController y2Ctrl = TextEditingController();
  TextEditingController y3Ctrl = TextEditingController();
  TextEditingController y4Ctrl = TextEditingController();

  Future<void> selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: getContext(),
      initialDate: DateTime.now(),
      firstDate: DateTime(1800),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.orangePrimary, // <-- SEE HERE
              // onPrimary: Colors.redAccent, // <-- SEE HERE
              onSurface: AppColors.textColor, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.grad1Color, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    update();
    if (picked != null) {
      selectedDate = picked;
      selectedDateStr = DateFormat("ddMMyyyy").format(selectedDate!);
      debugPrint("slectedDateStr $selectedDateStr");
      d1Ctrl.text = selectedDateStr!.substring(0, 1);
      d2Ctrl.text = selectedDateStr!.substring(1, 2);
      m1Ctrl.text = selectedDateStr!.substring(2, 3);
      m2Ctrl.text = selectedDateStr!.substring(3, 4);
      y1Ctrl.text = selectedDateStr!.substring(4, 5);
      y2Ctrl.text = selectedDateStr!.substring(5, 6);
      y3Ctrl.text = selectedDateStr!.substring(6, 7);
      y4Ctrl.text = selectedDateStr!.substring(7, 8);
      showCupertinoDialog<void>(
          context: getContext(),
          builder: (BuildContext context) => CupertinoAlertDialog(
            content: const Text(AppStrings.dateWarning),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                child: const Text(AppStrings.iUnderstand),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      update();
    }
  }
  
  @override
  void onInit() {
    SecuredStorage.initiateSecureStorage();
    super.onInit();
  }

  void onNextPressed() {
    if (selectedDate==null) {
      return;
    } else {
      createOrUpdateUserInfo();
    }
  }

  Future<void> createOrUpdateUserInfo() async {
    var userId = await SecuredStorage.readStringValue(Keys.userId) ;
    var firstName = await SecuredStorage.readStringValue(Keys.firstName) ;
    var lastName = await SecuredStorage.readStringValue(Keys.lastName) ;
    var birthday = DateFormat("dd-MM-yyyy").format(selectedDate!);
    var data = {
      "userId": userId,
      "info": {
        "firstName": firstName.toString().trim(),
        "lastName": lastName.toString().trim(),
        "birthday" : birthday
      }
    };
    debugPrint("DATAA $data");
    await registrationRepoImpl.createOrUpdateUserInfo(data).then((response) async {
      debugPrint("RESPONSE ${response.status}");
      if (response.status == 200) {
        await SecuredStorage.writeStringValue(
            Keys.birthday, birthday); 
        getOffNamed(mostLikedScreenRoute);
      } else {
        showAppDialog(msg: response.message.toString());
      }
    }).onError((error, stackTrace) {
      debugPrint("RESPONSE ${error.toString()}");
    });
  }
  
}
