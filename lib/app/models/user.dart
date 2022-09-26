class User {
  final int id;
  final String name;
  final String email;
  final int? fertilizerDealerId;
  final int? premiseId;

  User(
      {required this.id,
      required this.name,
      required this.email,
      this.fertilizerDealerId,
      this.premiseId});

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      fertilizerDealerId: json['fertilizerDealerId'],
      premiseId: json['premiseId']);

  Map toJson() => {
        'name': name,
        'id': id,
        'email': email,
        'fertilizerDealerId': fertilizerDealerId,
        'premiseId': premiseId
      };
}
