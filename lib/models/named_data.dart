import 'package:slugify/slugify.dart';

class NamedData<T> {
  final String name;
  final String slug;
  final T data;

  NamedData({required this.name, required this.data}) : slug = slugify(name);
}
