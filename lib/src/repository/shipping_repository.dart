import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../helpers/custom_trace.dart';
import '../models/shipping_status.dart';
import '../models/shipping.dart';

import '../helpers/helper.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;

Future<Stream<Shipping>> getShippings() async {
  Uri uri = Helper.getUri('api/me/shippings');
  Map<String, dynamic> _queryParams = {};
  final String orderStatusId = "5"; // for delivered status
  User _user = userRepo.currentUser.value;

  _queryParams['api_token'] = _user.apiToken;
  _queryParams['with'] = 'user;driver;shippingMethod;shippingStatus;payment';
  _queryParams['search'] = 'driver.id:${_user.id}';
  _queryParams['searchJoin'] = 'and';
  _queryParams['orderBy'] = 'id';
  _queryParams['sortedBy'] = 'desc';
  uri = uri.replace(queryParameters: _queryParams);
  print(uri);
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', uri));

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
      return Shipping.fromJSON(data);
    });
}

Future<Stream<ShippingStatus>> getShippingStatuses() async {
  Uri uri = Helper.getUri('api/shipping_statuses');
  Map<String, dynamic> _queryParams = {};
  User _user = userRepo.currentUser.value;

  _queryParams['api_token'] = _user.apiToken;
  _queryParams['orderBy'] = 'id';
  _queryParams['sortedBy'] = 'asc';
  _queryParams['filter'] = 'id;status';
  uri = uri.replace(queryParameters: _queryParams);

  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
      return ShippingStatus.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(ShippingStatus.fromJSON({}));
  }
}

Future<Shipping> updateShipping(Shipping shipping) async {
  Uri uri = Helper.getUri('api/shippings/${shipping.id}');
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Shipping();
  }
  Map<String, dynamic> _queryParams = {};
  _queryParams['api_token'] = _user.apiToken;
  uri = uri.replace(queryParameters: _queryParams);

  //final String url = '${GlobalConfiguration().getString('api_base_url')}orders/${order.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.put(
    uri.toString(),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(shipping.editableMap()),
  );
  print(uri.toString());
  print(json.encode(shipping.editableMap()).toString());
  return Shipping.fromJSON(json.decode(response.body)['data']);
}

Future<Stream<Shipping>> getShippingsHistory() async {
  Uri uri = Helper.getUri('api/me/shippings');
  Map<String, dynamic> _queryParams = {};
  final String orderStatusId = "6"; // for delivered status
  User _user = userRepo.currentUser.value;

  _queryParams['api_token'] = _user.apiToken;
  _queryParams['with'] = 'user;driver;shippingMethod;shippingStatus;payment';
  _queryParams['search'] = 'driver.id:${_user.id}';
  _queryParams['searchJoin'] = 'and';
  _queryParams['orderBy'] = 'id';
  _queryParams['sortedBy'] = 'desc';
  uri = uri.replace(queryParameters: _queryParams);
  // print(uri);
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', uri));

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
      return Shipping.fromJSON(data);
    });
}

Future<Stream<Shipping>> getRecentShippings() async {
  Uri uri = Helper.getUri('api/me/shippings');
  Map<String, dynamic> _queryParams = {};
  final String orderStatusId = "5"; // for delivered status
  User _user = userRepo.currentUser.value;

  _queryParams['api_token'] = _user.apiToken;
  _queryParams['with'] = 'user;driver;shippingMethod;shippingStatus;payment';
  _queryParams['search'] = 'driver.id:${_user.id}';
  _queryParams['searchJoin'] = 'and';
  _queryParams['orderBy'] = 'id';
  _queryParams['sortedBy'] = 'desc';
  _queryParams['limit'] = '4';
  uri = uri.replace(queryParameters: _queryParams);
  // print(uri);
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', uri));

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
      return Shipping.fromJSON(data);
    });
}