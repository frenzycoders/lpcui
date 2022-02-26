class Machine {
  String name;
  String id;
  bool status;
  String owner;
  String socketId;
  Machine({
    this.name = '',
    this.id = '',
    this.status = false,
    this.owner = '',
    this.socketId = '',
  });

  Machine.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['_id'],
        owner = json['owner'],
        status = json['status'],
        socketId = json['socketId'] == '' ? '' : json['socketId'];
}
