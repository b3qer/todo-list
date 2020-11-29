class Todo {
  int id;
  String title;
  String subtitle;
  int done;
  int categoryId;

  Todo({this.id, this.title, this.subtitle, this.done, this.categoryId});

  Todo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    subtitle = json['subtitle'];
    done = json['done'];
    categoryId = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['done'] = this.done;
    data['category_id'] = this.categoryId;
    return data;
  }
}
