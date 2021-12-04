import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import 'routing/nyanya_route_path.dart';
import 'routing/nyanya_router_delegate.dart';

extension PlayerColorColor on PlayerColor {
  Color get color {
    switch (this) {
      case PlayerColor.Blue:
        return Colors.blue;
      case PlayerColor.Red:
        return Colors.red;
      case PlayerColor.Green:
        return Colors.green;
      case PlayerColor.Yellow:
        return Colors.yellow;
    }
  }
}

void softNavigate(BuildContext context, NyaNyaRoutePath routePath) {
  Router.of(context).routeInformationProvider!.routerReportsNewRouteInformation(
      Router.of(context)
          .routeInformationParser!
          .restoreRouteInformation(routePath)!,
      type: RouteInformationReportingType.none);
  (Router.of(context).routerDelegate as NyaNyaRouterDelegate)
      .setVirtualNewRoutePath(routePath);
}
