import 'package:flutter/widgets.dart';

import 'nyanya_route_path.dart';

class NyaNyaRouteInformationParser
    extends RouteInformationParser<NyaNyaRoutePath> {
  @override
  Future<NyaNyaRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location ?? '');
    if (uri.pathSegments.length == 0) {
      return NyaNyaRoutePath.home();
    } else if (uri.pathSegments.length == 1) {
      switch (uri.pathSegments[0]) {
        case 'puzzles':
          return NyaNyaRoutePath.puzzles();
        case 'challenges':
          return NyaNyaRoutePath.challenges();
        case 'multiplayer':
          return NyaNyaRoutePath.multiplayer();
        case 'editor':
          return NyaNyaRoutePath.editor();
      }
    } else if (uri.pathSegments.length == 2) {
      var id = uri.pathSegments[1];
      switch (uri.pathSegments[0]) {
        case 'puzzle':
          return NyaNyaRoutePath.puzzle(id);
        case 'challenge':
          return NyaNyaRoutePath.challenge(id);
      }
    }

    // Handle unknown routes
    return NyaNyaRoutePath.home();
  }

  @override
  RouteInformation restoreRouteInformation(NyaNyaRoutePath path) {
    switch (path.kind) {
      case PageKind.Home:
        return RouteInformation(location: '/');
      case PageKind.Puzzles:
        return RouteInformation(location: '/puzzles');
      case PageKind.Puzzle:
        return RouteInformation(location: '/puzzle/${path.id}');
      case PageKind.Challenge:
        if (path.id == null)
          return RouteInformation(location: '/challenges');
        else
          return RouteInformation(location: '/challenge/${path.id}');
      case PageKind.Editor:
        return RouteInformation(location: '/editor');
      case PageKind.Multiplayer:
        return RouteInformation(location: '/multiplayer');
      case PageKind.Guide:
        return RouteInformation(location: '/guide');
    }
  }
}
