// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';


class DocumentModal {
  final String title;
  final String uid;
  final List content;
  final DateTime createdAt;
  final String id;
  DocumentModal({
    required this.title,
    required this.uid,
    required this.content,
    required this.createdAt,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'uid': uid,
      'content': content,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'id': id,
    };
  }

  factory DocumentModal.fromMap(Map<String, dynamic> map) {
    return DocumentModal(
      title: map['title'] ?? '',
      uid: map['uid'] ?? '',
      content: List.from(map['content']) ,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      id: map['_id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DocumentModal.fromJson(String source) => DocumentModal.fromMap(json.decode(source) as Map<String, dynamic>);

  DocumentModal copyWith({
    String? title,
    String? uid,
    List? content,
    DateTime? createdAt,
    String? id,
  }) {
    return DocumentModal(
      title: title ?? this.title,
      uid: uid ?? this.uid,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
    );
  }
}
