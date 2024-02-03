import 'package:jyo_app/data/remote/api_service.dart';
import 'package:jyo_app/models/registration_model/mobile_verification_response.dart';
import 'package:jyo_app/models/registration_model/save_interest_model.dart';
import 'package:jyo_app/models/registration_model/sign_in_response.dart';
import 'package:jyo_app/models/registration_model/tour_update_model.dart';
import 'package:jyo_app/repository/registration_repo/registration_repo.dart';

import '../../models/registration_model/check_otp_response.dart';
import '../../models/registration_model/create_or_update_user_response.dart';
import '../../models/registration_model/create_user_response.dart';
import '../../models/registration_model/interest_data_response.dart';

class RegistrationRepoImpl extends RegistrationRepo {
  ApiService apiService = ApiService();

  @override
  Future<MobileVerificationResponse?> sendOtp(Map data) async {
    dynamic response = await apiService.sendOtp(data);
    return MobileVerificationResponse.fromJson(response);
  }

  @override
  Future<CheckOtpResponse> checkOtp(Map data) async {
    dynamic response = await apiService.checkOtp(data);
    return CheckOtpResponse.fromJson( response );
  }

  @override
  Future<CreateOrUpdateUserResponse> createOrUpdateUserInfo(Map data) async {
    dynamic response = await apiService.createOrUpdateUserInfo(data);
    return CreateOrUpdateUserResponse.fromJson( response );
  }

  @override
  Future<SingInResponse> signIn(Map data) async {
    dynamic response = await apiService.signIn(data);
    return SingInResponse.fromJson( response );
  }
  
  @override
  Future<CreateUserResponse> userCreate(Map data) async {
    dynamic response = await apiService.userCreate(data);
    return CreateUserResponse.fromJson( response );
  }

  @override
  Future<InterestDataResponse> getAllIntrest() async {
    dynamic response = await apiService.getAllIntrest();
    return InterestDataResponse.fromJson( response );
  }

  @override
  Future<SaveInterestResponse> saveIntrest(Map data) async {
    dynamic response = await apiService.saveIntrest(data);
    return SaveInterestResponse.fromJson( response );
  }

  @override
  Future<TourUpdateModel>? updateTour(Map data) async {
      dynamic response = await apiService.updateTourStep(data);
    return TourUpdateModel.fromJson( response );
  }
}
