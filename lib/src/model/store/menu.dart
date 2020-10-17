class MenuModel {
  int id;
  final String name;
  final int price;
  bool isCheck = false;
  int count = 1;

  MenuModel({
    this.id,
    this.name,
    this.price
  });

  MenuModel.fromJson(Map<String,dynamic> json)
    : this.id = json['id'],
      this.name = json['menu_name'],
      this.price = json['menu_price'],
      this.isCheck = false,
      this.count = 1;
}

class BigMenuModel {
  int id;
  String name;
  List<MenuModel> menuList;

  BigMenuModel({
    this.id,
    this.name,
    this.menuList,
  });

  BigMenuModel.fromJson(Map<String, dynamic> json)
    :
      this.id = json['id'],
      this.name = json['big_name'],
      this.menuList = (json['menuList'] as List).map((e) => MenuModel.fromJson(e)).toList();
}