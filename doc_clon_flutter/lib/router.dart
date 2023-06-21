import 'package:doc_clon_flutter/screen/documant_screen.dart';
import 'package:doc_clon_flutter/screen/home_screen.dart';
import 'package:doc_clon_flutter/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

// final loggedOutRoute=RouteMap(routes: {'/':(route)=> MaterialPage(child: LoginScreen()),});

// final loggedInRoute=RouteMap(routes: {
//  '/':(route)=> MaterialPage(child: HomeScreen()),
//  '/document/id':((route) => MaterialPage(child: DocumentScreen(id: route.pathParameters['id']??'',)))

// });
final loggedOutRoute = RouteMap(routes: {
  '/': (route) =>  MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (route) =>  MaterialPage(child: HomeScreen()),
  '/document/:id': (route) => MaterialPage(
        child: DocumentScreen(
          id: route.pathParameters['id'] ?? '',
        ),
      ),
});