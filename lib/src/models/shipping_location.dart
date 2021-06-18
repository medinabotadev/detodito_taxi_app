class ShippingLocation {  
  double latitude;
  double longitude;
  String address;
  String instruction;
  String vehicle_needed_by_user;

  ShippingLocation();

  ShippingLocation.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      latitude = jsonMap['lat'] != null ? double.parse(jsonMap['lat']) : 0.0 ;
      longitude = jsonMap['lon'] != null ? double.parse(jsonMap['lon']) : 0.0 ;
      address = jsonMap['address'] != null ? jsonMap['address'].toString() : '' ;
      instruction = jsonMap['instruction'] != null ? jsonMap['instruction'].toString() : '' ;
      vehicle_needed_by_user = jsonMap['vehicle_needed_by_user'] != null ? jsonMap['vehicle_needed_by_user'].toString() : '' ;
    } catch (e) {
      latitude = 0.0;
      longitude = 0.0;
      address = '';
      instruction = '';
      vehicle_needed_by_user = '';
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["lat"] = latitude;
    map["lon"] = longitude;
    map["address"] = address;
    map["instruction"] = instruction;
    map['vehicle_needed_by_user'] = vehicle_needed_by_user;
    return map;
  }

  // Map deliveredMap() {
  //   var map = new Map<String, dynamic>();
  //   map["id"] = id;
  //   map["order_status_id"] = 5;
  //   if (deliveryAddress?.id != null && deliveryAddress?.id != 'null') map["delivery_address_id"] = deliveryAddress.id;
  //   return map;
  // }

  // Map cancelMap() {
  //   var map = new Map<String, dynamic>();
  //   map["id"] = id;
  //   if (orderStatus?.id != null && orderStatus?.id == '1') map["active"] = false;
  //   return map;
  // }

  // bool canCancelOrder() {
  //   return this.active == true && this.orderStatus.id == '1'; // 1 for order received status
  // }
}
