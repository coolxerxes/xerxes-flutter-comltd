import 'package:jyo_app/models/registration_model/mobile_verification_response.dart';
import 'package:jyo_app/models/registration_model/save_interest_model.dart';
import 'package:jyo_app/models/registration_model/sign_in_response.dart';

import '../../models/registration_model/check_otp_response.dart';
import '../../models/registration_model/create_or_update_user_response.dart';
import '../../models/registration_model/create_user_response.dart';
import '../../models/registration_model/interest_data_response.dart';

abstract class RegistrationRepo {
  Future<MobileVerificationResponse?> sendOtp(Map data);
  Future<CheckOtpResponse> checkOtp(Map data);
  Future<CreateUserResponse> userCreate(Map data);
  Future<CreateOrUpdateUserResponse>? createOrUpdateUserInfo(Map data);
  Future<SingInResponse>? signIn(Map data);
  Future<InterestDataResponse>? getAllIntrest();
  Future<SaveInterestResponse>? saveIntrest(Map data);
}
