class Attachement{
  String size;
  String name;
  String mimetype;
  String url;

  Attachement();

  Attachement.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      size     = jsonMap['size']             != null ? jsonMap['size']                      : '';
      name     = jsonMap['name']             != null ? jsonMap['name']                      : '';
      mimetype = jsonMap['mimetype']         != null ? jsonMap['mimetype']                  : '';
      url      = jsonMap['url']              != null ? jsonMap['url']                       : '';
    } catch (e) {
      size          = '';
      name          = '';
      mimetype      = '';
      url           = '';
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['size']       = size;
    map['name']       = name;
    map['mimetype']   = mimetype;
    map['url']        = url;
    return map;
  }
}