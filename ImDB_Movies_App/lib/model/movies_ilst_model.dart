// class MoviesListModel {
//   List<Items>? items;
//   String? errorMessage;

//   MoviesListModel({this.items, this.errorMessage});

//   MoviesListModel.fromJson(Map<String, dynamic> json) {
//     if (json['items'] != null) {
//       items = <Items>[];
//       json['items'].forEach((v) {
//         items!.add(new Items.fromJson(v));
//       });
//     }
//     errorMessage = json['errorMessage'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.items != null) {
//       data['items'] = this.items!.map((v) => v.toJson()).toList();
//     }
//     data['errorMessage'] = this.errorMessage;
//     return data;
//   }
// }

// class Items {
//   String? id;
//   String? rank;
//   String? title;
//   String? fullTitle;
//   String? year;
//   String? image;
//   String? crew;
//   String? imDbRating;
//   String? imDbRatingCount;

//   Items(
//       {this.id,
//       this.rank,
//       this.title,
//       this.fullTitle,
//       this.year,
//       this.image,
//       this.crew,
//       this.imDbRating,
//       this.imDbRatingCount});

//   Items.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     rank = json['rank'];
//     title = json['title'];
//     fullTitle = json['fullTitle'];
//     year = json['year'];
//     image = json['image'];
//     crew = json['crew'];
//     imDbRating = json['imDbRating'];
//     imDbRatingCount = json['imDbRatingCount'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['rank'] = this.rank;
//     data['title'] = this.title;
//     data['fullTitle'] = this.fullTitle;
//     data['year'] = this.year;
//     data['image'] = this.image;
//     data['crew'] = this.crew;
//     data['imDbRating'] = this.imDbRating;
//     data['imDbRatingCount'] = this.imDbRatingCount;
//     return data;
//   }
// }
class UsersListModel {
  int? page;
  int? perPage;
  int? total;
  int? totalPages;
  List<User>? data;
  Support? support;

  UsersListModel(
      {this.page,
      this.perPage,
      this.total,
      this.totalPages,
      this.data,
      this.support});

  UsersListModel.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    perPage = json['per_page'];
    total = json['total'];
    totalPages = json['total_pages'];
    if (json['data'] != null) {
      data = <User>[];
      json['data'].forEach((v) {
        data!.add(new User.fromJson(v));
      });
    }
    support =
        json['support'] != null ? new Support.fromJson(json['support']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['per_page'] = this.perPage;
    data['total'] = this.total;
    data['total_pages'] = this.totalPages;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.support != null) {
      data['support'] = this.support!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? email;
  String? firstName;
  String? lastName;
  String? avatar;

  User({this.id, this.email, this.firstName, this.lastName, this.avatar});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['avatar'] = this.avatar;
    return data;
  }
  String get fullName => "${this.firstName} ${this.lastName}";
 }

class Support {
  String? url;
  String? text;

  Support({this.url, this.text});

  Support.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['text'] = this.text;
    return data;
  }
}
