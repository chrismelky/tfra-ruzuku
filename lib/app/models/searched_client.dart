class SearchedClient {
  int? id;
  String? name;

  SearchedClient({this.id, this.name});

  factory SearchedClient.empty() => SearchedClient();

  factory SearchedClient.formFarmer(Map<String, dynamic> json) =>
      SearchedClient(
          id: json['id'], name: json['firstName'] + " " + json['lastName']);

  factory SearchedClient.fromCooperative(Map<String, dynamic> json) =>
      SearchedClient(id: json['id'], name: json['businessName']);
}
