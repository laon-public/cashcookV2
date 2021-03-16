class MenuModel {
  final String menu_name;
  final String menu_price;

  MenuModel({this.menu_name, this.menu_price});

  MenuModel.fromJson(Map<String, dynamic> json)
      : menu_name = json['menu_name'],
        menu_price = json['menu_price'];
}
