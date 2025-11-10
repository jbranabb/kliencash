class ClientModel {
  int? id;
  String name;
  String alamat;
  String handphone;
  
  ClientModel({
    this.id,
    required this.name,
    required this.alamat,
    required this.handphone,
  });
  factory ClientModel.fromJson(Map<String, dynamic> json){
   return ClientModel(
    id: json['Id'],
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