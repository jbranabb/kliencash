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
      id: json['id'],
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
  String createdAt;
  InvoiceModel? invoiceModel;
  ProjectsModel? projectsModel;
  ClientModel({
    this.id,
    required this.name,
    required this.alamat,
    required this.handphone,
    required this.countryCode,
    this.invoiceModel,
    this.projectsModel,
    String? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().toIso8601String();
  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['Id'],
      name: json['name'],
      alamat: json['alamat'],
      countryCode: json['country_code'],
      handphone: json['handphone'],
      createdAt: json['createdAt'],
      invoiceModel: json['invoice_id'] != null
          ? InvoiceModel(
              projectsId: json['invoice_projects_id'],
              paymentMethodId: json['invoice_payment_method_id'],
              status: json['invoice_status'],
              subtotal: json['invoice_subtotal'],
              title: json['invoice_title'],
              totalAmount: json['invoice_totalAmount'],
              tanggal: json['invoice_tanggal'],
              jatuhTempo: json['invoice_jatuhTempo'],
              isRounded: json['invoice_isRounded'],
              invoiceNumber: json['Invoice_invoiceNumber'],
              createdAt: json['invoicee_createdAt'],
            )
          : null,
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
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "alamat": alamat,
      "handphone": handphone,
      "country_code": countryCode,
      "createdAt": createdAt,
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
  bool isExpanded;
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
    this.isExpanded = false,
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
              createdAt: json['createdAt'] ?? '',
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

  ProjectsModel copyWith({bool? isExpanded}) {
    return ProjectsModel(
      clientId: clientId,
      agenda: agenda,
      price: price,
      startAt: startAt,
      endAt: endAt,
      status: status,
      createdAt: createdAt,
      desc: desc,
      client: client,
      id: id,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}

class InvoiceModel {
  int? id;
  int projectsId;
  int paymentMethodId;
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
  PaymentMethodModel? paymentMethod;
  InvoiceModel({
    this.id,
    required this.projectsId,
    required this.paymentMethodId,
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
    this.paymentMethod,
  });
  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['Id'] ?? 0,
      projectsId: json['project_id'] ?? 0,
      paymentMethodId: json['payement_method_id'] ?? 0,
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
      paymentMethod: json['payementMethod_id'] != null
          ? PaymentMethodModel.fromJson({
              'id': json['payementMethod_id'],
              'name': json['paymn_name'],
              'type': json['paymn_type'],
              'number': json['paymn_number'],
              'account_name': json['paymn_accountName'],
              'isActive': json['paymn_isActive'],
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
      'payement_method_id': paymentMethodId,
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
    this.id,
    required this.name,
    required this.type,
    this.accountName,
    this.number,
    required this.isActive,
  });
  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id'],
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

class PaymentModel {
  int? id;
  int invoiceId;
  int paymentMethodId;
  int amount;
  String tanggalBayar;
  String buktiPayment;
  String? notes;
  PaymentMethodModel? paymentMethodModel;
  InvoiceModel? invoicemodel;
  ProjectsModel? projectsModel;
  ClientModel? clientModel;
  PaymentModel({
    this.id,
    required this.invoiceId,
    required this.paymentMethodId,
    required this.amount,
    required this.buktiPayment,
    required this.tanggalBayar,
    this.notes,
    this.invoicemodel,
    this.paymentMethodModel,
    this.projectsModel,
    this.clientModel,
  });
  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      invoiceId: json['invoice_id'],
      paymentMethodId: json['payment_method_id'],
      amount: json['amount'],
      buktiPayment: json['bukti_payment'],
      tanggalBayar: json['tanggal_bayar'],
      notes: json['notes'],
      invoicemodel: json['invoice_projects_id'] != null
          ? InvoiceModel(
              projectsId: json['invoice_projects_id'],
              paymentMethodId: json['invoice_payment_method_id'],
              status: json['invoice_status'],
              subtotal: json['invoice_subtotal'],
              title: json['invoice_title'],
              totalAmount: json['invoice_totalAmount'],
              tanggal: json['invoice_tanggal'],
              jatuhTempo: json['invoice_jatuhTempo'],
              isRounded: json['invoice_isRounded'],
              invoiceNumber: json['Invoice_invoiceNumber'],
              createdAt: json['invoicee_createdAt'],
            )
          : null,
      paymentMethodModel: json['pm_id'] != null
          ? PaymentMethodModel(
              name: json['pm_name'],
              type: json['pm_type'],
              accountName: json['pm_accountName'],
              number: json['pm_number'],
              isActive: json['pm_isActive'],
            )
          : null,
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
      'invoice_id': invoiceId,
      'payment_method_id': paymentMethodId,
      'amount': amount,
      'tanggal_bayar': tanggalBayar,
      'bukti_payment': buktiPayment,
    };
  }
}

class OperasionalModdel {
  int? id;
  int projectId;
  String title;
  int amount;
  String date;
  ProjectsModel? projectsModel;
  OperasionalModdel({
    this.id,
    required this.projectId,
    required this.title,
    required this.amount,
    required this.date,
    this.projectsModel,
  });
  factory OperasionalModdel.fromJson(Map<String, dynamic> json) {
    return OperasionalModdel(
      id: json['id'],
      projectId: json['project_id'],
      title: json['title'],
      amount: json['amount'],
      date: json['date'],
      projectsModel: json['project_id'] != null
          ? ProjectsModel.fromJson({
              'Id': json['projects_id'] ?? 0,
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
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'project_id': projectId,
      'title': title,
      'amount': amount,
      'date': date,
    };
  }
}
