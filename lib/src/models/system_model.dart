class SystemDetails {
  SystemDetails({
    required this.operatingSys,
    required this.hostName,
    required this.platform,
    required this.ostype,
    required this.release,
    required this.arch,
    required this.homeDir,
    required this.version,
    required this.totalSpace,
    required this.free,
    required this.available,
  });
  late final String operatingSys;
  late final String hostName;
  late final String platform;
  late final String ostype;
  late final String release;
  late final String arch;
  late final String homeDir;
  late final String version;
  late final String totalSpace;
  late final String free;
  late final String available;
  
  SystemDetails.fromJson(Map<String, dynamic> json){
    operatingSys = json['operatingSys'];
    hostName = json['hostName'];
    platform = json['platform'];
    ostype = json['ostype'];
    release = json['release'];
    arch = json['arch'];
    homeDir = json['homeDir'];
    version = json['version'];
    totalSpace = json['totalSpace'];
    free = json['free'];
    available = json['available'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['operatingSys'] = operatingSys;
    _data['hostName'] = hostName;
    _data['platform'] = platform;
    _data['ostype'] = ostype;
    _data['release'] = release;
    _data['arch'] = arch;
    _data['homeDir'] = homeDir;
    _data['version'] = version;
    _data['totalSpace'] = totalSpace;
    _data['free'] = free;
    _data['available'] = available;
    return _data;
  }
}