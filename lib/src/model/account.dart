class AccountModel {
  final String id;
  final String type;
  final String quantity;
  final String created_at;
  final String updated_at;

  AccountModel(
      {this.id, this.type, this.quantity, this.created_at, this.updated_at});

  AccountModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        type = json['type'],
        quantity = json['quantity'],
        created_at = json['created_at'],
        updated_at = json['updated_at'];
}

class AccountListModel {
  final int idx;
  final String amount;
  final String purpose;
  final String created_at;
  final String updated_at;

  AccountListModel(
      {this.idx,
      this.amount,
      this.purpose,
      this.created_at,
      this.updated_at});

  AccountListModel.fromJson(Map<String, dynamic> json)
      : idx = json['idx'],
        amount = json['amount'],
        purpose = json['description'],
        created_at = json['created_at'],
        updated_at = json['updated_at'];
}
