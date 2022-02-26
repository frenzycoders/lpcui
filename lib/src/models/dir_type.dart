class DirType {
  String name;
  bool isFile;
  String exactPath;

  DirType({required this.name, required this.isFile, this.exactPath = ''});

  DirType.fromJSON(Map<String, dynamic> json)
      : name = json['name'],
        isFile = json['isFile'],
        exactPath = '';
}
