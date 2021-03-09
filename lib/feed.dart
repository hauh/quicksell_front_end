import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:quicksell_app/api.dart' show API;
import 'package:quicksell_app/listing/lib.dart' show Listing, ListingCard;

class Feed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
        centerTitle: true,
      ),
      body: FeedBuilder(),
    );
  }
}

class FeedBuilder extends StatefulWidget {
  final Map<String, dynamic>? filters;
  FeedBuilder({this.filters});

  @override
  State createState() => _FeedState();
}

class _FeedState extends State<FeedBuilder> {
  final pagingController = PagingController<int, Listing>(firstPageKey: 1);

  @override
  void initState() {
    pagingController.addPageRequestListener((pageKey) => fetchPage(pageKey));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, Listing>(
      pagingController: pagingController,
      builderDelegate: PagedChildBuilderDelegate<Listing>(
        itemBuilder: (_, item, __) => ListingCard(item),
      ),
    );
  }

  Future<void> fetchPage(int pageKey) async {
    try {
      final newItems = await API().getListings(pageKey);
      newItems.length >= 10
          ? pagingController.appendPage(newItems, pageKey + 1)
          : pagingController.appendLastPage(newItems);
      // TODO: fix exception when pagingController is already disposed
    } catch (error) {
      pagingController.error = error;
    }
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }
}
