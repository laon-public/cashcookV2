class RecoModel {
  final Parent parent;
  final Child child;
  final String created_at;
  final String updated_at;

  RecoModel({this.parent, this.child, this.created_at, this.updated_at});

  RecoModel.fromJson(Map<String, dynamic> json)
      : parent = Parent(
            id: json['parent']['id'],
            username: json['parent']['username'],
            name: json['parent']['name'],
            phone: json['parent']['phone']),
        child = Child(
            id: json['child']['id'],
            username: json['child']['username'],
            name: json['child']['name'],
            phone: json['child']['phone']),
        created_at = json['created_at'],
        updated_at = json['updated_at'];

  RecoModel.fromRecognition(Map<String, dynamic> json)
      : parent = Parent(

        ),
        child = Child(
          name: json['child']['name'],
          phone: json['child']['phone']
        )  ,
        created_at = json['created_at'],
        updated_at = json['updated_at']
  ;
}

class Parent {
  final int id;
  final String username;
  final String name;
  final String phone;

  Parent({this.id, this.username, this.name, this.phone});

  Parent.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        name = json['name'],
        phone = json['phone'];
}

class Child {
  final int id;
  final String username;
  final String name;
  final String phone;

  Child({this.id, this.username, this.name, this.phone});
}
