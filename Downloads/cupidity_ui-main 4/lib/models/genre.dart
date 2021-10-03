import 'dart:ui';

class Genre {
  Genre({
    this.color,
    this.name,
    this.isSelected = false,
  });
  String name;
  Color color;
  bool isSelected = false;
  printGenre() {
    print(name);
  }
}
