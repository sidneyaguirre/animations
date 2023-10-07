import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../widgets/recipe/model/recipe.dart';

class RecipeListPage extends StatefulWidget {
  const RecipeListPage({super.key});

  @override
  State<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage>
    with SingleTickerProviderStateMixin {
  final http.Client _client = http.Client();
  final RecipeActions _recipeActions = RecipeActions();
  final List<Recipe> _recipes = [];

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      value: 100,
      duration: Duration(
        seconds: 3,
      ),
      vsync: this,
    )
      ..forward()
      ..repeat();

    _getRecipes('a');
  }

  @override
  void dispose() {
    _controller.dispose();
    _client.close();
    super.dispose();
  }

  void _getRecipes(String initial) async {
    var recipes = await _recipeActions.getRecipesByInitial(initial);
    _recipes.addAll(recipes!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Hero(
                tag: _recipes[index].id!,
                child: RecipeItem(recipe: _recipes[index]));
          },
          itemCount: _recipes.length,
        ),
      ),
    );
  }
}

class RecipeItem extends StatelessWidget {
  const RecipeItem({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    const padding = 15.0;
    const titleSize = 16.0;
    const bodySize = 13.0;

    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                context.go(
                  '/recipe-details?${recipe.id}',
                  extra: recipe,
                );
              },
              child: Image.network(
                recipe.thumbnail!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: padding),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name!,
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: padding),
                  Text(
                    recipe.tags ?? '',
                    style: TextStyle(
                      fontSize: bodySize,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecipeDetailsPage extends StatefulWidget {
  const RecipeDetailsPage({
    required this.id,
    super.key,
    required this.recipe,
  });

  final String id;
  final Recipe recipe;

  @override
  State<RecipeDetailsPage> createState() => _RecipeDetailsPageState();
}

class _RecipeDetailsPageState extends State<RecipeDetailsPage> {
  static const _padding = 15.0;
  static const _titleSize = 16.0;
  static const _bodySize = 13.0;

  late Recipe _recipe;

  @override
  void initState() {
    super.initState();

    _recipe = widget.recipe;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: _recipe.id!,
              child: Image.network(
                _recipe.thumbnail!,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              _recipe.name!,
              style: TextStyle(
                fontSize: _titleSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: _padding),
            Text(
              _recipe.instructions ?? '',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: _bodySize,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: _padding),
            Text(
              _recipe.tags ?? '',
              style: TextStyle(
                fontSize: _bodySize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: _padding),
            Text(
              _recipe.youtubeLink ?? '',
              style: TextStyle(
                color: Colors.deepPurpleAccent,
                fontSize: _bodySize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeActions {
  Future<List<Recipe>?> getRecipesByInitial(String initial) async {
    final apiResponse = await http.get(
      Uri.parse(
          'https://www.themealdb.com/api/json/v1/1/search.php?f=$initial'),
    );

    List<Recipe>? result;

    if (apiResponse.statusCode == 200) {
      var json = jsonDecode(apiResponse.body) as Map<String, dynamic>;
      result = Recipe.fromDynamic(json['meals']);
    } else {
      throw Exception('Failed to load recipes');
    }

    return result;
  }
}
