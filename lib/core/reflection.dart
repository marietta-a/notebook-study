import 'dart:nativewrappers/_internal/vm/lib/mirrors_patch.dart';

void reflectObject(Object obj) {
  // Get the reflection of the object
  dynamic instanceMirror = reflect(obj);

  // Get the type of the object
  dynamic classMirror = instanceMirror.type;

  print(instanceMirror);

  // List all properties (fields)
  classMirror.declarations.forEach((key, declaration) {
    try{
      var propertyName = MirrorSystem.getName(key);
      var propertyType = MirrorSystem.getName(declaration.type.simpleName);
  
    }
    catch(ex){
      rethrow; 
    }
  });
}
