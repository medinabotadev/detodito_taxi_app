
class Payment {
  String id;
  double price;
  String status;
  String method;

  Payment.init();

  Payment(this.method);

  Payment.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      price = jsonMap['price'] != null ? double.parse(jsonMap['price'].toString()) : 0.0;
      status = jsonMap['status'] ?? '';
      method = jsonMap['method'] ?? '';
    } catch (e) {
      id = '';
      price = 0.0;
      status = '';
      method = '';
      print('El problema es aqui ${e}');
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
      'method': method,
    };
  }
}
