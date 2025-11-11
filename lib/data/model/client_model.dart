class ClientModel {
  int? id;
  String name;
  String alamat;
  String handphone;
  String countryCode;
  ClientModel({
    this.id,
    required this.name,
    required this.alamat,
    required this.handphone,
    required this.countryCode,
  });
  factory ClientModel.fromJson(Map<String, dynamic> json){
   return ClientModel(
    id: json['Id'],
    name: json['name'],
    alamat: json['alamat'],
    countryCode: json['country_code'],
    handphone: json['handphone']);
  }
  Map<String,dynamic> toJson(){
    return {
    "name":name,
    "alamat":alamat,
    "handphone":handphone,
    "country_code":countryCode
    };
  }
}