import '../helpers/custom_trace.dart';

class ShippingMethod{
  String id;
  String name;

  ShippingMethod();

  ShippingMethod.fromJSON(Map<String, dynamic> jsonMap){
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'] != null ? jsonMap['name'] : '';
    } catch (e) {
      id = '';
      name = '';
      print(CustomTrace(StackTrace.current, message: e));
    }
  } 
}