import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_project1/models/user_model.dart';
import 'package:flutter_app_project1/modules/chat/chat_screen.dart';
import 'package:flutter_app_project1/modules/cubit/states.dart';
import 'package:flutter_app_project1/modules/favourite/favourite_screen.dart';
import 'package:flutter_app_project1/modules/home/home_screen.dart';
import 'package:flutter_app_project1/modules/map/map_screen.dart';
import 'package:flutter_app_project1/modules/setting/setting_screen.dart';
import 'package:flutter_app_project1/shared/components/constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;

  void getUserData() {
    emit(AppGetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uid).get().
    then((value) {
       print(value.data());
      userModel = UserModel.fromJson(value.data()!);
      emit(AppGetUserSuccessState());
    })
        .catchError((error) {
      print(error.toString());
      emit(AppGetUserErrorState(error.toString()));
    });
  }

  List<Widget> Screens = [
    HomeScreen(),
    MapScreen(),
    FavouriteScreen(),
    ChatScreen(),
    SettingScreen(),
  ];

  // List<String> titles = [
  //   'Home',
  //   'Map',
  //   'Favourite',
  //   'Chat',
  //   'Setting',
  // ];
  int currentIndex = 0;

  void ChangeBottomNav(int index)
  {
      currentIndex = index;
      emit(AppChangeBottomNavState());
  }

  File? profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async
  {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if(pickedFile != null)
    {
      profileImage = File(pickedFile.path);
      print(pickedFile.path);
      emit(ProfileImagePickedSuccessState());
    }else
    {
      print('No image selected');
      emit(ProfileImagePickedErrorState());
    }
  }

//  String profileImageUrl ='';

  void uploadProfileImage({
    required String name,
    required String phone,
})
  {
    emit(UserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value)
    {
      value.ref.getDownloadURL()
          .then((value)
      {
     //   emit(UploadProfileImageSuccessState());
        print(value);
        updateUser(
            name: name,
            phone: phone,
            image: value,
        );
       // profileImageUrl = value;
      })
          .catchError((error){
            emit(UploadProfileImageErrorState());
      });
    })
        .catchError((error){
      emit(UploadProfileImageErrorState());
    });
  }

//   void updateUserImage({
//   required String name,
//   required String phone,
// })
//   {
//     emit(UserUpdateLoadingState());
//     if(profileImage !=null)
//     {
//       uploadProfileImage();
//     }else
//       {
//        updateUser(
//            name: name,
//            phone: phone,
//        );
//       }
//   }

  void updateUser({
    required String name,
    required String phone,
    String? image,
})
  {
    UserModel model = UserModel(
      name: name,
      phone: phone,
      email: userModel!.email,
      image: image?? userModel!.image,
      uid: userModel!.uid,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uid)
        .update(model.toMap())
        .then((value)
    {
      getUserData();
    })
        .catchError((error)
    {
      emit(UserUpdateErrorState());
    });
  }

}