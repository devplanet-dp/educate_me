import 'package:get/get.dart';

import '../../data/user.dart';

enum PageKey {
  gender,
  name,
  email,
  dob,
  photos,
  height,
  body,
  qualification,
  occupation,
  drink,
  smoke,
  hobbies,
  drug,
  habbits,
  fitness,
  language,
  political,
  travel,
  interested,
  bio
}

class AppController extends GetxController {
  UserModel? appUser;
}
