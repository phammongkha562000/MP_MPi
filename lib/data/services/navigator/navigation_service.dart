import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<T?> pushNamed<T extends Object?>(String routeName,
      {Object? args}) async {
    return navigatorKey.currentState?.pushNamed<T>(
      routeName,
      arguments: args,
    );
  }

  Future<T?> push<T extends Object?>(Route<T> route) async {
    return navigatorKey.currentState?.push<T>(route);
  }

  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
      String routeName,
      {Object? args}) async {
    return navigatorKey.currentState?.pushReplacementNamed<T, TO>(
      routeName,
      arguments: args,
    );
  }

  Future<T?> popAndPushNamed<T extends Object?, TO extends Object?>(
      String routeName,
      {Object? args}) async {
    return navigatorKey.currentState?.popAndPushNamed<T, TO>(
      routeName,
      arguments: args,
    );
  }

  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String routeName, {
    Object? args,
    bool Function(Route<dynamic>)? predicate,
  }) async {
    return navigatorKey.currentState?.pushNamedAndRemoveUntil<T>(
      routeName,
      predicate ?? (_) => false,
      arguments: args,
    );
  }

  Future<T?> pushAndRemoveUntil<T extends Object?>(
    Route<T> route, {
    bool Function(Route<dynamic>)? predicate,
  }) async {
    return navigatorKey.currentState?.pushAndRemoveUntil<T>(
      route,
      predicate ?? (_) => false,
    );
  }

  Future<bool?> maybePop<T extends Object?>([Object? args]) async {
    return navigatorKey.currentState?.maybePop<T>(args as T?);
  }

  bool canPop() => navigatorKey.currentState!.canPop();

  void goBack<T extends Object?>({T? result}) {
    navigatorKey.currentState?.pop<T>(result);
  }

  void popUntil(String route) {
    navigatorKey.currentState?.popUntil(ModalRoute.withName(route));
  }

  Future<T?> navigateAndDisplaySelection<T extends Object?>(String routeName,
      {Object? args}) async {
    return await navigatorKey.currentState?.pushNamed<T>(
      routeName,
      arguments: args,
    );
  }

  RouteSettings? pageSettings(BuildContext context) {
    return ModalRoute.of<RouteSettings>(context)?.settings;
  }
}
