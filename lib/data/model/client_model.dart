class ClientModel {
  String name;
  String alamat;
  int handphone;
  
  ClientModel({
    required this.name,
    required this.alamat,
    required this.handphone,
  });
  factory ClientModel.fromJson(Map<String, dynamic> json){
   return ClientModel(
    name: json['name'],
    alamat: json['alamat'],
    handphone: json['handphone']);
  }
  Map<String,dynamic> toJson(){
    return {
    "name":name,
    "alamat":alamat,
    "handphone":handphone,
    };
  }
}