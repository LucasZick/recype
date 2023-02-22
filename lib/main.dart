import 'package:flutter/material.dart';
import 'package:meals/screens/meal_detail_screen.dart';
import 'package:meals/screens/settings_screen.dart';
import 'package:meals/screens/tabs_screen.dart';

import 'models/settings.dart';
import 'screens/categories_screen.dart';
import 'screens/categories_meals_screen.dart';
import 'utils.dart/app_routes.dart';
import 'models/meal.dart';
import 'data/dummy_data.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ignore: prefer_final_fields
  Settings settings = Settings();
  List<Meal> _availableMeals = dummyMeals;
  // ignore: prefer_final_fields
  List<Meal> _favoriteMeals = [];

  void _filterMeals(Settings settings) {
    setState(() {
      _availableMeals = dummyMeals.where(
        (meal) {
          this.settings = settings;
          final filterGluten = settings.isGlutenFree && !meal.isGlutenFree;
          final filterLactose = settings.isLactoseFree && !meal.isLactoseFree;
          final filterVegan = settings.isVegan && !meal.isVegan;
          final filterVegetarian = settings.isVegetarian && !meal.isVegetarian;

          return !filterGluten &&
              !filterLactose &&
              !filterVegan &&
              !filterVegetarian;
        },
      ).toList();
    });
  }

  void _toggleFavorite(Meal meal) {
    setState(
      () {
        _favoriteMeals.contains(meal)
            ? _favoriteMeals.remove(meal)
            : _favoriteMeals.add(meal);
      },
    );
  }

  bool _isFavorite(Meal meal) {
    return _favoriteMeals.contains(meal);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeliMeals',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.pink)
            .copyWith(secondary: Colors.amber),
        fontFamily: 'Raleway',
        canvasColor: const Color.fromRGBO(255, 254, 229, 1),
        textTheme: ThemeData.light().textTheme.copyWith(
              titleMedium: const TextStyle(
                fontSize: 20,
                fontFamily: 'RobotoCondensed',
              ),
            ),
      ),
      initialRoute: '/',
      routes: {
        AppRoutes.home: (ctx) => TabsScreen(
              favoriteMeals: _favoriteMeals,
            ),
        AppRoutes.categoriesMeals: (ctx) => CategoriesMealsScreen(
              meals: _availableMeals,
            ),
        AppRoutes.mealDetail: (ctx) => MealDetailScreen(
              isFavorite: _isFavorite,
              onToggleFavorite: _toggleFavorite,
            ),
        AppRoutes.settings: (ctx) => SettingsScreen(
              settings: settings,
              onSettingsChanged: _filterMeals,
            )
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) {
            return const CategoriesScreen();
          },
        );
      },
    );
  }
}
