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
  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['Id'],
      name: json['name'],
      alamat: json['alamat'],
      countryCode: json['country_code'],
      handphone: json['handphone'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "alamat": alamat,
      "handphone": handphone,
      "country_code": countryCode,
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
    this.client,
  });
  factory ProjectsModel.fromJson(Map<String, dynamic> json) {
    return ProjectsModel(
      id: json['Id'] ?? 0,
      clientId: json['client_id'] ?? 0,
      agenda: json['agenda'] ?? '',
      desc: json['desc'] ?? '',
      price: json['estimatedValue'] ?? 0  ,
      startAt: json['startAt'] ??  '',
      endAt: json['endAt'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['createdAt'] ?? '',
      client: json['client_name'] != null
          ? ClientModel(
              name: json['client_name'] ?? '',
              alamat: json['client_alamat'] ?? '',
              handphone: json['client_handphone'] ?? '',
              countryCode: json['client_countryCode'] ?? '',
            )
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "client_id": clientId,
      "agenda": agenda,
      "desc": desc,
      "estimatedValue": price,
      "startAt": startAt,
      "endAt": endAt,
      "status": status,
      "createdAt": createdAt,
    };
  }
}

class InvoiceModel {
  int? id;
  int projectsId;
  String status;
  int subtotal;
  int? pajak;
  int? discount;
  int totalAmount;
  String tanggal;
  String jatuhTempo;
  int isRounded;
  int? roundedValue;
  String? notes;
  String invoiceNumber;
  String createdAt;
  ProjectsModel? projectsModel;
  ClientModel? clientModel;
  InvoiceModel({
    this.id,
    required this.projectsId,
    required this.status,
    required this.subtotal,
    this.pajak,
    this.discount,
    required this.totalAmount,
    required this.tanggal,
    required this.jatuhTempo,
    required this.isRounded,
    this.roundedValue,
    this.notes,
    required this.invoiceNumber,
    required this.createdAt,
    this.projectsModel,
    this.clientModel,
  });
  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['Id'] ?? 0,
      projectsId: json['project_id'] ?? 0,
      status: json['status'] ?? 'nope',
      subtotal: json['subtotal'] ?? 0,
      pajak: json['pajak'] ?? 0,
      discount: json['discount'] ?? 0,
      totalAmount: json['total_amount'] ?? 0,
      tanggal: json['tanggal'] ?? 'miss',
      jatuhTempo: json['jatuh_tempo'] ?? 'miss',
      isRounded: json['isRounded'] ?? 0,
      roundedValue: json['rounded_value'] ?? 0,
      notes: json['notes'],
      invoiceNumber: json['invoice_number'],
      createdAt: json['createdAt'] ?? 'string',
      projectsModel: json['id_projects'] != null
          ? ProjectsModel.fromJson({
              'Id': json['id_projects'] ?? 0,
              'agenda': json['projects_agenda'] ?? '',
              'desc': json['projects_desc'],
              'status': json['projects_status'] ?? '',
              'client_id': json['projects_client_id'] ?? 0,
              'estimatedValue': json['projects_price'] ?? 0,
              'startAt': json['projects_startAt'] ?? '',
              'endAt': json['projects_endAt'] ?? '',
              'createdAt': json['projects_createdAt'] ?? '',
            })
          : null,
      clientModel: json['id_client'] != null
          ? ClientModel.fromJson({
              'Id': json['id_client'] ?? '',
              'name': json['client_name'] ?? '',
              'handphone': json['client_phone'] ?? '',
              'country_code': json['client_cc'] ?? '',
              'alamat': json['client_alamat'] ?? '',
            })
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'project_id': projectsId,
      'status': status,
      'subtotal': subtotal,
      'pajak': pajak,
      'discount': discount,
      'total_amount': totalAmount,
      'tanggal': tanggal,
      'jatuh_tempo': jatuhTempo,
      'isRounded': isRounded,
      'rounded_value': roundedValue,
      'createdAt': createdAt,
      'notes': notes,
      'invoice_number': invoiceNumber,
    };
  }
}
