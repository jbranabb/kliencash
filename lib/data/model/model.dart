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
class ProjectsModel {
  int? id;
  int clientId;
  String agenda;
  String? desc;
  int price;
  String startAt;
  String endAt;
  String status;
  String createdAt;
  ClientModel? client;
  ProjectsModel({
    this.id,
    required this.clientId,
    required this.agenda,
    this.desc,
    required this.price,
    required this.startAt,
    required this.endAt,
    required this.status,
    required this.createdAt,
    this.client
    });
    factory ProjectsModel.fromJson(Map<String, dynamic> json){
      return ProjectsModel(
      id: json['Id'], 
      clientId: json['client_id'], 
      agenda: json['agenda'],
      desc: json['desc'],
      price: json['estimatedValue'],
      startAt: json['startAt'],
      endAt: json['endAt'],
      status: json['status'],
      createdAt: json['createdAt'],
      client: json['client_name'] !=null ?
       ClientModel(
       name: json['client_name'],
       alamat: json['client_alamat'],
       handphone: json['client_handphone'],
       countryCode: json['client_countryCode']) : null 
      );
    }
    Map<String,dynamic> toJson() {
      return {
        "Id":id,
        "client_id":clientId,
        "agenda":agenda,
        "desc":desc,
        "estimatedValue":price,
        "startAt":startAt,
        "endAt":endAt,
        "status":status,
        "createdAt":createdAt
      };
    }
}