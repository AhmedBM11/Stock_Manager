import 'package:auto_route/auto_route.dart';

import 'package:sat/views/pages/page_two/home_page.dart';
import 'package:sat/views/pages/page_two/stores_page.dart';
import 'package:sat/views/pages/page_two/profile_page.dart';

part 'router_one.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: NavBarRoute.page,
      initial: true,
      children: [
        AutoRoute(page: HomeRoute.page),
        AutoRoute(page: StoresRoute.page),
        AutoRoute(page: ProfileRoute.page),
      ],
    ),
  ];
}
