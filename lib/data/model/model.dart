class User {
  int? id;
  String namaPerusahaaan;
  String username;
  String alamat;
  String countryCode;
  int phoneNumber;
  String emaiil;
  String? tagline;
  User({
    required this.namaPerusahaaan,
    required this.username,
    this.id,
    required this.alamat,
    required this.emaiil,
    required this.countryCode,
    required this.phoneNumber,
    this.tagline,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      namaPerusahaaan: json['nama_perusahaan'],
      alamat: json['alamat'],
      emaiil: json['email'],
      countryCode: json['countryCode'],
      phoneNumber: json['handphone'],
      tagline: json['tagline'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "nama_perusahaan": namaPerusahaaan,
      "alamat": alamat,
      "email": emaiil,
      "countryCode": countryCode,
      "handphone": phoneNumber,
      "tagline": tagline,
    };
  }
}

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
      price: json['estimatedValue'] ?? 0,
      startAt: json['startAt'] ?? '',
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
  String title;
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
    required this.title,
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
      title: json['title'] ?? 'nope',
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
      'title': title,
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

class PaymentMethodModel {
  int? id;
  String type;
  String name;
  String? number;
  String? accountName;
  int isActive;
  PaymentMethodModel({
    required this.name,
    required this.type,
    this.accountName,
    this.number,
    required this.isActive,
  });
  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      name: json['name'],
      type: json['type'],
      number: json['number'],
      accountName: json['account_name'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'number': number,
      'account_name': accountName,
      'isActive': isActive,
    };
  }
}
