import 'package:flutter/widgets.dart';

import 'nyanya_route_path.dart';

class NyaNyaRouteInformationParser
    extends RouteInformationParser<NyaNyaRoutePath> {
  @override
  Future<NyaNyaRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location ?? '');
    if (uri.pathSegments.isEmpty) {
      return NyaNyaRoutePath.home();
    } else if (uri.pathSegments.length >= 1) {
      return NyaNyaRoutePath(
          PageKindSlug.fromSlug(uri.pathSegments[0]) ?? PageKind.Home,
          uri.pathSegments.length >= 2
              ? TabKindSlug.fromSlug(uri.pathSegments[1])
              : null,
          uri.pathSegments.length == 3 ? uri.pathSegments[2] : null);
    }

    // Handle unknown routes
    return NyaNyaRoutePath.home();
  }

  @override
  RouteInformation restoreRouteInformation(NyaNyaRoutePath path) {
    if (path.id == null || path.tabKind == null) {
      if (path.tabKind != null)
        return RouteInformation(
            location: '/${path.kind.slug}/${path.tabKind!.slug}');
      else
        return RouteInformation(location: '/${path.kind.slug}');
    } else {
      return RouteInformation(
          location: '/${path.kind.slug}/${path.tabKind!.slug}/${path.id}');
    }
  }
}
