import 'dart:convert';

import 'package:animations/src/form/search_bar.dart';
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

  @override
  void initState() {
    super.initState();

    _getRecipes();
  }

  @override
  void dispose() {
    _client.close();
    super.dispose();
  }

  void _getRecipes() async {
    var alphabet = List.generate(
        26, (index) => String.fromCharCode(index + 65).toLowerCase());

    for (var letter in alphabet) {
      var recipes = await _recipeActions.getRecipesByInitial(letter);
      _recipes.addAll(recipes ?? []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade50,
        title: MySearchBar(),
        toolbarHeight: 80,
      ),
      backgroundColor: Colors.deepPurple.shade50,
      body: Center(
        child: _recipes.isNotEmpty
            ? ListView.builder(
                itemBuilder: (context, index) {
                  return RecipeItem(recipe: _recipes[index]);
                },
                itemCount: _recipes.length,
              )
            : CircularProgressIndicator(),
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

    return GestureDetector(
      onTap: () {
        context.push(
          '/recipe-details/${recipe.id}',
          extra: recipe,
        );
      },
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.all(8),
        surfaceTintColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Flexible(
                child: Hero(
                  tag: recipe.id!,
                  child: CircleAvatar(
                    radius: 48,
                    backgroundImage: NetworkImage(
                      recipe.thumbnail!,
                    ),
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
        ),
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
  static const _titleSize = 20.0;
  static const _bodySize = 13.0;

  final ScrollController _scrollController = ScrollController();

  late Recipe _recipe;

  bool _expandedIngredients = false;

  @override
  void initState() {
    super.initState();

    _recipe = widget.recipe;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade50,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back_rounded),
        ),
        title: Text(
          _recipe.name!,
          style: TextStyle(
            fontSize: _titleSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            size.width <= 610
                ? Hero(
                    tag: _recipe.id!,
                    child: Image.network(
                      _recipe.thumbnail!,
                      fit: BoxFit.cover,
                    ),
                  )
                : Center(
                    child: Hero(
                      tag: _recipe.id!,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: 350,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.network(
                              _recipe.thumbnail!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: _padding),
                  if (_recipe.tags != null)
                    Text(
                      'Tags:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (_recipe.tags != null) SizedBox(height: 8),
                  if (_recipe.tags != null)
                    Text(
                      _recipe.tags!,
                      style: TextStyle(
                        fontSize: _bodySize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  SizedBox(height: _padding),
                  ExpansionTile(
                    backgroundColor: Colors.purple.shade100,
                    collapsedBackgroundColor: Colors.purple.shade100,
                    collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                    ),
                    title: _expandedIngredients
                        ? Text('Hide Ingredients')
                        : Text('See Ingredients'),
                    onExpansionChanged: (value) {
                      _expandedIngredients = value;
                      setState(() {});
                      final offset =
                          size.width <= 610 ? size.height * 0.5 : 0.0;

                      _scrollController.animateTo(
                        offset,
                        curve: Curves.easeOut,
                        duration: const Duration(milliseconds: 500),
                      );
                    },
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          _recipe.ingredients ?? '',
                          style: TextStyle(
                            fontSize: _bodySize,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: _padding),
                  Text(
                    'Instructions:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _recipe.instructions ?? '',
                    style: TextStyle(
                      fontSize: _bodySize,
                      fontWeight: FontWeight.normal,
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
                  SizedBox(height: _padding),
                ],
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
      result = Recipe.fromDynamic(json['meals'] ?? []);
    } else {
      throw Exception('Failed to load recipes');
    }

    return result;
  }
}
