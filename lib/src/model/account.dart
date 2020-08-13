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
  final int id;
  final String amount;
  final String purpose;
  final String created_at;
  final String updated_at;
  final AccountModel account;

  AccountListModel(
      {this.id,
      this.amount,
      this.purpose,
      this.created_at,
      this.updated_at,
      this.account});

  AccountListModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        amount = json['amount'],
        purpose = json['purpose'],
        created_at = json['created_at'],
        updated_at = json['updated_at'],
        account = AccountModel(
            id: json['account']['id'],
            type: json['account']['type'],
            quantity: json['account']['quantity'],
            created_at: json['account']['created_at'],
            updated_at: json['account']['updated_at']);
}
