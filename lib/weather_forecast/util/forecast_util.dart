import 'package:intl/intl.dart';

class Util {
   //static String appId ="ADD YOUR OWN APPID";
  static String appId = "ADD YOUR APPID";

  static String getFormattedDate(DateTime dateTime) {

    return new DateFormat("EEEE, MMM d, y").format(dateTime);
    //... 1999
  }


}