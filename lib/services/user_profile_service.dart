import 'package:firebase_auth/firebase_auth.dart';
import 'package:notebook_study/helpers/enums.dart';
import 'package:notebook_study/models/user_profile.dart';
import 'package:notebook_study/services/base_service.dart';

class UserProfileService extends BaseService {
    late String collectionName = CollectionNames.user_profiles.name;
   
    addCreateUserProfileIfNotExisits() async {
      try{
        
       User? loginUser = getUser();

       if(loginUser != null){
        var existing = await findItem(collectionName, 'userName', loginUser.displayName);
        if(!existing.docs.any((u) => u.exists)){
           UserProfile user = UserProfile(
            uid:  loginUser!.uid,
            firstName:  "",
            lastName:  "",
            userName: loginUser.displayName,
            email:  loginUser.email,
            role:  UserRoles.viewer.name
          );

          await addItem(collectionName, user.toJson());
        }
       }
      }
      catch(ex){
        print(ex);
        rethrow;
      }
    }
}