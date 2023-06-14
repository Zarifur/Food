import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_restaurant/data/model/response/apple_login_model.dart';
import 'package:flutter_restaurant/data/model/response/social_login_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/screens/forgot_password/verification_screen.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';


class SocialLoginWidget extends StatefulWidget {
  @override
  State<SocialLoginWidget> createState() => _SocialLoginWidgetState();
}

class _SocialLoginWidgetState extends State<SocialLoginWidget> {
  SocialLoginModel socialLogin = SocialLoginModel();
  bool isAppleError = false;
  void route(
      bool isRoute,
      String token,
      String temporaryToken,
      String errorMessage,
      ) async {
    if (isRoute) {
      if(token != null){
        Navigator.pushNamedAndRemoveUntil(context, Routes.getDashboardRoute('home'), (route) => false,);

      }else if(temporaryToken != null && temporaryToken.isNotEmpty){
        if(Provider.of<SplashProvider>(context,listen: false).configModel.emailVerification){
          Provider.of<AuthProvider>(context, listen: false).checkEmail(socialLogin.email).then((value) async {
            if (value.isSuccess) {
              Provider.of<AuthProvider>(context, listen: false).updateEmail(socialLogin.email.toString());
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (_) => VerificationScreen(emailAddress: socialLogin.email, fromSignUp: true,)), (route) => false);

            }
          });
        }
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (_) => VerificationScreen(emailAddress: '', fromSignUp: true,)), (route) => false);
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage),
            backgroundColor: Colors.red));
      }

    } else {
      if(errorMessage == "Apple Sign in Error"){
        isAppleError = true;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage),
          backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    final _socialStatus = Provider.of<SplashProvider>(context,listen: false).configModel.socialLoginStatus;

    if(isAppleError){
      WidgetsBinding.instance
        .addPostFrameCallback((_) => showAlertDialog(context));
      }
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return Column(children: [

          Center(child: Text('${getTranslated('sign_in_with', context)}', style: poppinsRegular.copyWith(
              color: Theme.of(context).textTheme.bodyText1.color.withOpacity(0.6),
              fontSize: Dimensions.FONT_SIZE_SMALL))),
          SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
           if(_socialStatus.isGoogle)
             Row(
               children: [
                 InkWell(
                    onTap: () async {
                      try{
                        GoogleSignInAuthentication  _auth = await authProvider.googleLogin();
                        GoogleSignInAccount _googleAccount = authProvider.googleAccount;
                        print('---------------google ----------- ${_googleAccount.email}');

                        Provider.of<AuthProvider>(context, listen: false).socialLogin(SocialLoginModel(
                          email: _googleAccount.email, token: _auth.idToken, uniqueId: _googleAccount.id, medium: 'google',
                        ), route);


                      }catch(er){
                        print('access token error is : $er');
                      }
                    },
                    child: Container(
                      height: ResponsiveHelper.isDesktop(context)
                          ? 50 : 40,
                      width: ResponsiveHelper.isDesktop(context)
                          ? 130 :ResponsiveHelper.isTab(context)
                          ? 110 : 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).textTheme.bodyText1.color.withOpacity(0.1),
                        borderRadius: BorderRadius.all(Radius.circular(Dimensions.RADIUS_DEFAULT)),
                      ),
                      child:   Image.asset(
                        Images.google,
                        height: ResponsiveHelper.isDesktop(context)
                            ? 30 :ResponsiveHelper.isTab(context)
                            ? 25 : 20,
                        width: ResponsiveHelper.isDesktop(context)
                            ? 30 : ResponsiveHelper.isTab(context)
                            ? 25 : 20,
                      ),
                    ),
                  ),

                 if(_socialStatus.isFacebook || Platform.isIOS)
                   SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT,),
               ],
             ),

            if(Platform.isIOS)
              Row(
               children: [
                 InkWell(
                    onTap: () async {
                      try{
                        final credential = await SignInWithApple.getAppleIDCredential(
                          scopes: [
                            AppleIDAuthorizationScopes.email,
                            AppleIDAuthorizationScopes.fullName,
                          ],
                        );
                        final SharedPreferences prefs = await SharedPreferences.getInstance();
                        
                        
                        if(credential.email == null){
                          final String appleEmail = prefs.getString('appleEmail');
                          final String applefName = prefs.getString('applefName');
                          final String applelName = prefs.getString('applelName');

                          Provider.of<AuthProvider>(context, listen: false).appleLogin(AppleLoginModel(
                          email: appleEmail, token: credential.identityToken, uniqueId: credential.userIdentifier, medium: 'apple',
                          firstName: applefName,lastName: applelName
                        ), route);
                        }else{
                          await prefs.setString('appleEmail', credential.email);
                          await prefs.setString('applefName', credential.givenName);
                          await prefs.setString('applelName', credential.familyName);

                          Provider.of<AuthProvider>(context, listen: false).appleLogin(AppleLoginModel(
                          email: credential.email, token: credential.identityToken, uniqueId: credential.userIdentifier, medium: 'apple',
                          firstName: credential.givenName,lastName: credential.familyName
                          ), route);
                        }
                        

                      }catch(er){
                        print('access token error is : $er');
                      }
                    },
                    child: Container(
                      height: ResponsiveHelper.isDesktop(context)
                          ? 50 : 40,
                      width: ResponsiveHelper.isDesktop(context)
                          ? 130 :ResponsiveHelper.isTab(context)
                          ? 110 : 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).textTheme.bodyText1.color.withOpacity(0.1),
                        borderRadius: BorderRadius.all(Radius.circular(Dimensions.RADIUS_DEFAULT)),
                      ),
                      child:   Image.asset(
                        Images.apple,
                        height: ResponsiveHelper.isDesktop(context)
                            ? 30 :ResponsiveHelper.isTab(context)
                            ? 25 : 20,
                        width: ResponsiveHelper.isDesktop(context)
                            ? 30 : ResponsiveHelper.isTab(context)
                            ? 25 : 20,
                      ),
                    ),
                  ),

                 if(_socialStatus.isFacebook)
                   SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT,),
               ],
             ),

            if(_socialStatus.isFacebook)
              InkWell(
              onTap: () async{
                LoginResult _result = await FacebookAuth.instance.login();
                print('isuue ============== ${_result.message}');

                if (_result.status == LoginStatus.success) {
                 Map _userData = await FacebookAuth.instance.getUserData();

                 print('facebook --------------------------------------------------- $_userData');

                 Provider.of<AuthProvider>(context, listen: false).socialLogin(
                   SocialLoginModel(
                     email: _userData['email'],
                     token: _result.accessToken.token,
                     uniqueId: _result.accessToken.userId,
                     medium: 'facebook',
                   ), route,
                 );
                }
              },
              child: Container(
                height: ResponsiveHelper.isDesktop(context)?50 :ResponsiveHelper.isTab(context)? 40:40,
                width: ResponsiveHelper.isDesktop(context)? 130 :ResponsiveHelper.isTab(context)? 110: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).textTheme.bodyText1.color.withOpacity(0.1),
                  borderRadius: BorderRadius.all(Radius.circular(Dimensions.RADIUS_DEFAULT)),
                ),
                child:   Image.asset(
                  Images.facebook,
                  height: ResponsiveHelper.isDesktop(context)
                      ? 30 : ResponsiveHelper.isTab(context)
                      ? 25 : 20,
                  width: ResponsiveHelper.isDesktop(context)
                      ? 30 :ResponsiveHelper.isTab(context)
                      ? 25 : 20,
                ),
              ),
            ),
          ]),
          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL,),
        ]);
      }
    );
  }
}


showAlertDialog(BuildContext context) {

  // set up the button
  Widget okButton = TextButton(
    child: Text("Dismiss"),
    onPressed: () { 
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Apple Sign in Error"),
    content: Text("It seems there was an error the first time you logged in. Please remove this app from your sign in with apple list and try again."),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}