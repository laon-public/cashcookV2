class MenuModel {
  int id;
  final String name;
  final int price;
  bool isCheck = false;
  String imgUrl;
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
      this.imgUrl = json['menu_img'],
      this.count = 1;
}

class BigMenuMinify {
  int id;
  String name;

  BigMenuMinify.fromJson(Map<String, dynamic> json)
    :
      this.id = json['id'],
      this.name = json['big_name'];
}

class BigMenuModel {
  int id;
  String name;
  List<MenuModel> menuList;
  bool isCheck; // delete 용

  BigMenuModel({
    this.id,
    this.name,
    this.menuList,
  });

  BigMenuModel.fromJson(Map<String, dynamic> json)
    :
      this.id = json['id'],
      this.name = json['big_name'],
      this.menuList = (json['menuList'] as List).map((e) => MenuModel.fromJson(e)).toList(),
      this.isCheck = false;
}