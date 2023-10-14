import 'package:json_class/json_class.dart';

class Recipe extends JsonClass {
  Recipe({
    this.area,
    this.category,
    this.id,
    this.ingredients,
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
        ingredients:
            '${json['strIngredient1']}: ${json['strMeasure1']},\n${json['strIngredient2']}: ${json['strMeasure2']},\n${json['strIngredient3']}: ${json['strMeasure3']},\n${json['strIngredient4']}: ${json['strMeasure4']},\n${json['strIngredient5']}: ${json['strMeasure5']},\n${json['strIngredient6']}: ${json['strMeasure6']},\n${json['strIngredient7']}: ${json['strMeasure7']},\n${json['strIngredient8']}: ${json['strMeasure8']},\n${json['strIngredient9']}: ${json['strMeasure9']} ${json['strIngredient10']?.toString().isNotEmpty == true ? ",\n${json['strIngredient10']} : ${json['strMeasure10']}" : ''}',
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
  final String? ingredients;
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
