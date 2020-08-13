class Pageing{
  int page;
  int limit;
  int count;
  int offset;

  Pageing({this.page, this.limit, this.count, this.offset});

  Pageing.fromJson(Map<String, dynamic> json)
      : page = json['page'],
        limit = json['limit'],
        count = json['count'],
        offset = json['offset'];
}
