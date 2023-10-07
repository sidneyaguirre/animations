import 'package:json_class/json_class.dart';

class Recipe extends JsonClass {
  Recipe({
    this.area,
    this.category,
    this.id,
    this.instructions,
    this.name,
    this.tags,
    this.thumbnail,
    this.youtubeLink,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        area: json['strArea'],
        category: json['strCategory'],
        id: json['idMeal'],
        instructions: json['strInstructions'],
        name: json['strMeal'],
        tags: json['strTags'],
        thumbnail: json['strMealThumb'],
        youtubeLink: json['strYoutube'],
      );

  static List<Recipe> fromDynamic(List list) => list
      .map(
        (item) => Recipe.fromJson(item),
      )
      .toList();

  final String? area;
  final String? category;
  final String? id;
  final String? instructions;
  final String? name;
  final String? tags;
  final String? thumbnail;
  final String? youtubeLink;

  @override
  Map<String, dynamic> toJson() => {
        'area': area,
        'category': category,
        'id': id,
        'name': name,
        'tags': tags,
        'thumbnail': thumbnail,
        'youtubeLink': youtubeLink,
      };
}
