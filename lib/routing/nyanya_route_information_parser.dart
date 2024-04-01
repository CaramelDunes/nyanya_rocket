import 'package:flutter/widgets.dart';

import 'nyanya_route_path.dart';

class NyaNyaRouteInformationParser
    extends RouteInformationParser<NyaNyaRoutePath> {
  @override
  Future<NyaNyaRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    String location = routeInformation.uri.path;

    // Strip URL # on mobile.
    if (location.startsWith('/#')) {
      location = location.substring(2);
    }

    final uri = Uri.parse(location);

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
    final kindSlug = configuration.kind.slug;
    final tabSlug = configuration.tabKind?.slug;
    final id = configuration.id;

    Uri uri;

    if (id != null && tabSlug != null) {
      uri = Uri.parse('/$kindSlug/$tabSlug/$id');
    } else if (tabSlug != null) {
      uri = Uri.parse('/$kindSlug/$tabSlug');
    } else {
      uri = Uri.parse('/$kindSlug');
    }

    return RouteInformation(uri: uri);
  }
}
