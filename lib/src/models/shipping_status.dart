import '../helpers/custom_trace.dart';

class ShippingStatus {
  String id;
  String status;

  ShippingStatus();

  ShippingStatus.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      status = jsonMap['status'] != null ? jsonMap['status'] : '';
    } catch (e) {
      id = '';
      status = '';
      print(CustomTrace(StackTrace.current, message: e));
    }
  }
}
