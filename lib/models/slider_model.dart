class SlidersModel {
  final int? id;
  final String? picUrl;
  final int? sortId;
  final int? status;
  final String? title;
  final int? type;
  const SlidersModel(
      {this.id, this.sortId, this.picUrl, this.status, this.title, this.type});

  factory SlidersModel.fromJson(Map<String, dynamic> json) {
    return SlidersModel(
      id: json['id'] as int?,
      picUrl: json['picUrl'] as String?,
      sortId: json['sortId'] as int?,
      status: json['status'] as int?,
      title: json['title'] as String?,
      type: json['type'] as int?,
    );
  }
  @override
  String toString() {
    return 'SlidersModel(id: $id, picUrl: $picUrl, sortId: $sortId, status: $status, title: $title, type: $type)';
  }
}
