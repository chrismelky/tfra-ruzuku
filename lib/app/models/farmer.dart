class SelectedClient {
  int? id;
  String? name;

  SelectedClient({this.id, this.name});
  factory SelectedClient.empty() => SelectedClient();

  factory SelectedClient.formFarmer(Map<String, dynamic> json) =>
      SelectedClient(
          id: json['id'], name: json['firstName'] + " " + json['lastName']);
}
