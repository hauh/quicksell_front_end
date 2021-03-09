import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quicksell_app/authorization.dart' show AuthenticationRequired;
import 'package:quicksell_app/feed.dart' show FeedBuilder;
import 'package:quicksell_app/state.dart' show AppState, UserState;

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthenticationRequired(
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: TabBar(
              tabs: [
                Tab(
                  text: "Profile",
                  icon: Icon(Icons.person),
                  iconMargin: EdgeInsets.only(top: 5),
                ),
                Tab(
                  text: "Listings",
                  icon: Icon(Icons.shopping_cart),
                  iconMargin: EdgeInsets.only(top: 5),
                ),
                Tab(
                  text: "Favorites",
                  icon: Icon(Icons.favorite),
                  iconMargin: EdgeInsets.only(top: 5),
                ),
                Tab(
                  text: "Settings",
                  icon: Icon(Icons.settings),
                  iconMargin: EdgeInsets.only(top: 5),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _ProfileView(),
              FeedBuilder(filters: {
                'seller': context.read<UserState>().user?.profile.uuid
              }),
              _Favorites(),
              _Settings(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var userState = context.read<UserState>();
    var profile = userState.user!.profile;

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(5.0),
      child: ListView(
        children: [
          ElevatedButton(
            onPressed: () => userState.logOut(),
            child: Text("Log out"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 5,
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Image(image: AssetImage('assets/no_image.png')),
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(profile.fullName),
                      Text("Rating: ${profile.rating}"),
                      Text(
                        "Registration date: "
                        "${AppState.datetimeFormat(profile.dateCreated)}",
                      ),
                    ],
                  ),
                ),
              ),
              Divider(color: Colors.black),
            ],
          ),
        ],
      ),
    );
  }
}

class _Favorites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("Favorites");
  }
}

class _Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("Settings");
  }
}
