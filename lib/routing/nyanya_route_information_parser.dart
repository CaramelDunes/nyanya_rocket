import 'package:flutter/widgets.dart';

import 'nyanya_route_path.dart';

class NyaNyaRouteInformationParser
    extends RouteInformationParser<NyaNyaRoutePath> {
  @override
  Future<NyaNyaRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location ?? '');
    if (uri.pathSegments.isEmpty) {
      return const NyaNyaRoutePath.home();
    } else {
      return NyaNyaRoutePath(
          PageKindSlug.fromSlug(uri.pathSegments[0]) ?? PageKind.home,
          uri.pathSegments.length >= 2
              ? TabKindSlug.fromSlug(uri.pathSegments[1])
              : null,
          uri.pathSegments.length == 3 ? uri.pathSegments[2] : null);
    }
  }

  @override
  RouteInformation restoreRouteInformation(NyaNyaRoutePath configuration) {
    if (configuration.id == null || configuration.tabKind == null) {
      if (configuration.tabKind != null) {
        return RouteInformation(
            location:
                '/${configuration.kind.slug}/${configuration.tabKind!.slug}');
      } else {
        return RouteInformation(location: '/${configuration.kind.slug}');
      }
    } else {
      return RouteInformation(
          location:
              '/${configuration.kind.slug}/${configuration.tabKind!.slug}/${configuration.id}');
    }
  }
}
