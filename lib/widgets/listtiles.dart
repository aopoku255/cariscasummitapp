import 'package:cbfapp/routes/routes.dart';
import 'package:cbfapp/utils/liststyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ListTiles extends StatelessWidget {
  const ListTiles({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: menuItems.length, // Use the imported array
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(
            menuItems[index]['icon'],
            color: Colors.blueAccent,
          ),
          title: Text(menuItems[index]['text'],
              style: const TextStyle(color: Colors.blueAccent)),
          onTap: () async {
            // Handle item tap
            String route = menuItems[index]['route'];
            if (appRoutes.containsKey(route)) {
              if (route == '/keynoteSpeakers') {
                final url = 'https://cariscabusinessforum.com/speakers';

                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url),
                      mode: LaunchMode.inAppWebView);
                } else {
                  throw 'Could not launch $url';
                }
              }
              if (route == '/agenda') {
                final url = 'https://cariscabusinessforum.com/program';

                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url),
                      mode: LaunchMode.inAppWebView);
                } else {
                  throw 'Could not launch $url';
                }
              } else {
                Navigator.pushNamed(context, route);
                print('$route tapped');
              }
            } else {
              print('Route $route is not defined in appRoutes');
            }
          },
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(
          color: Colors.grey, // Divider color
          thickness: 0.3, // Divider thickness
        );
      },
    );
  }
}
