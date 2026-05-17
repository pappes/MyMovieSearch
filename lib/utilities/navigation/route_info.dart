import 'dart:convert';

enum ScreenRoute {
  search,
  searchresults,
  persondetails,
  moviedetails,
  addlocation,
  errordetails,
  about,
  changelog,
  navigationHistory,
}

class RouteInfo {
  RouteInfo(this.routePath, this.params, this.reference, this.description);

  final ScreenRoute routePath;
  final Object params;
  final String reference;
  final String description;

  @override
  String toString() => json.encode({
    'path': routePath.toString(),
    'params': params.toString(),
    'ref': reference,
    'description': description,
  });
}
