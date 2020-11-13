import 'package:intl/intl.dart';

class ServiceLogListItem {
  String date;
  List<OrderLog> orderLogList;

  ServiceLogListItem.initFromJson(Map<String, dynamic> json) {
    this.date = DateFormat("yyyy.MM.dd").format(
        DateTime.parse(json['created_at'].toString()));
    this.orderLogList = [OrderLog.fromJson(json)];
  }

  void addfromJson(Map<String, dynamic> json) {
    this.orderLogList.add(OrderLog.fromJson(json));
  }
}

class OrderLog {
  int id;
  String storeName;
  String storeImg;
  int storeId;
  String content;
  bool playGame;
  int pay;
  int dl;
  String logType;
  int reviewId;
  int gameQuantity;

  DateTime createdAt;
  DateTime updatedAt;

  List<OrderMainCat> mainCatList;

  OrderLog({this.id, this.storeName, this.storeImg,this.storeId, this.content,
      this.pay, this.dl, this.logType, this.reviewId, this.gameQuantity, this.createdAt, this.updatedAt});

  OrderLog.fromJson(Map<String, dynamic> json)
    :
      this.id = json['id'],
      this.storeName = json['storeName'],
      this.storeImg = json['storeImg'],
      this.storeId = json['storeId'],
      this.content = json['content'],
      this.pay = json['pay'],
      this.dl = json['dl'],
      this.logType = json['logType'],
      this.reviewId = json['reviewId'],
      this.playGame = json['playGame'],
      this.gameQuantity = json['gameQuantity'],
      this.createdAt = DateTime.parse(json['created_at'].toString()),
      this.updatedAt = DateTime.parse(json['updated_at'].toString()),
      this.mainCatList = (json['mainCatList'] as List).map((e) => OrderMainCat.fromJson(e)).toList();
}

class OrderMainCat {
  int id;
  int orderId;
  String menuName;

  DateTime createdAt;
  List<OrderSubCat> subCatList;

  OrderMainCat({this.id, this.orderId, this.menuName,
      this.createdAt});

  OrderMainCat.fromJson(Map<String, dynamic> json)
    :
      this.id = json['id'],
      this.orderId = json['orderId'],
      this.menuName = json['menuName'],
      this.createdAt = DateTime.parse(json['created_at'].toString()),
      this.subCatList = (json['subCatList'] as List).map((e) => OrderSubCat.fromJson(e)).toList();
}

class OrderSubCat {
  int id;
  int mainId;
  String menuName;
  int amount;
  int price;

  DateTime createdAt;

  OrderSubCat({this.id, this.mainId, this.menuName,
    this.amount, this.price});

  OrderSubCat.fromJson(Map<String, dynamic> json)
    :
        this.id = json['id'],
        this.mainId = json['mainId'],
        this.menuName = json['menuName'],
        this.amount = json['amount'],
        this.price = json['price'],
        this.createdAt = DateTime.parse(json['created_at'].toString());
}