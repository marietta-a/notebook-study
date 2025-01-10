import 'package:flutter/material.dart';
import 'package:notebook_study/helpers/enums.dart';

class CrudNotificationItem extends StatelessWidget {
  final int actionMesage;


  const CrudNotificationItem({Key? key, required this.actionMesage}) : super(key: key);

  @override
  Widget build(BuildContext context) {

   final color = actionMesage == CrudActionMessages.error.index ? Colors.red : Colors.green;
   var message = "";
   switch (CrudActionMessages.values[actionMesage]) {
     case CrudActionMessages.added:
        message = "Item successfully aded!";
       break;
     case CrudActionMessages.deleted:
        message = "Item successfully deleted!";
       break;
     case CrudActionMessages.updated:
        message = "Item successfully updated!";
       break;
     case CrudActionMessages.error:
        message = "Oops! \n Operation failed! :(";
       break;
   }

    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.white),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
