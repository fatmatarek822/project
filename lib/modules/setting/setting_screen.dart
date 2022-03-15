
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_project1/modules/cubit/cubit.dart';
import 'package:flutter_app_project1/modules/cubit/states.dart';
import 'package:flutter_app_project1/shared/components/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingScreen extends StatelessWidget {
   SettingScreen({Key? key}) : super(key: key);

  var nameController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state)
      {
        var userModel = AppCubit.get(context).userModel;
        var profileImage = AppCubit.get(context).profileImage;


        nameController.text = userModel!.name!;
        phoneController.text = userModel.phone!;

        return ConditionalBuilder(
          condition: AppCubit.get(context).userModel !=null,
          builder: (context) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                if(state is UserUpdateLoadingState)
                  const LinearProgressIndicator(),
                if(state is UserUpdateLoadingState)
                  const SizedBox(
                    height: 5,
                  ),
                Center(
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      CircleAvatar(
                        backgroundImage: profileImage == null ? NetworkImage(
                            '${userModel.image}'
                        ) :FileImage(profileImage) as ImageProvider,
                        maxRadius: 100,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          onPressed: ()
                          {
                            AppCubit.get(context).getProfileImage();
                          },
                          icon: Icon(Icons.camera_alt),
                          color: Colors.black,
                          iconSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                defaultFormField(
                  controller: nameController,
                  type: TextInputType.name,
                  validate: (value)
                  {
                    if(value!.isEmpty)
                    {
                      return 'Please Enter Your Name';
                    }
                  },
                  label: 'Name',
                  prefix: Icons.person,
                ),

                const SizedBox(
                  height: 10,
                ),
                defaultFormField(
                  controller: phoneController,
                  type: TextInputType.phone,
                  validate: (value)
                  {
                    if(value!.isEmpty)
                    {
                      return 'Please Enter Your phone';
                    }
                  },
                  label: 'Phone',
                  prefix: Icons.phone,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: ()
                        {
                          AppCubit.get(context).updateUser(name: nameController.text, phone: phoneController.text);
                        },
                        child: const Text(
                          'Upload Profile Data',
                        ),
                      ),
                    ),

                  ],
                ),
                if(AppCubit.get(context).profileImage != null)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: ()
                          {
                            AppCubit.get(context).uploadProfileImage(name: nameController.text, phone: phoneController.text);
                          },
                          child: const Text(
                            'Upload Profile Image',
                          ),
                        ),
                      ),
                    ],
                  ),

                const SizedBox(
                  height: 20,
                ),

                defaultButton(
                  function: ()
                  {
                    AppCubit.get(context).currentIndex =0;
                    AppCubit.get(context).signOut(context);
                  },
                  text: 'Logout',
                ),
              ],
            ),
          ),
        ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
