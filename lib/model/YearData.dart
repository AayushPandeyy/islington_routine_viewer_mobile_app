import 'package:islington_routine_viewer_app/model/Field.dart';
import 'package:islington_routine_viewer_app/model/Section.dart';



class YearData {
  final int year;
  final List<Field> fields;

  YearData({
    required this.year,
    required this.fields,
  });

  factory YearData.fromJson(Map<String, dynamic> json) {
    var fieldsFromJson = json['fields'] as List;
    List<Field> fieldList = fieldsFromJson.map((f) => Field.fromJson(f)).toList();

    return YearData(
      year: json['year'],
      fields: fieldList,
    );
  }
}