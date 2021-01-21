import 'dart:async' show Future;

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:quicksell_app/api.dart' as api;
import 'package:quicksell_app/listing.dart';
import 'package:quicksell_app/models.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  final PagingController<int, Listing> pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    pagingController.addPageRequestListener((pageKey) => fetchPage(pageKey));
    super.initState();
  }

  Future<void> fetchPage(int pageKey) async {
    try {
      final newItems = await api.getListings(pageKey);
      if (newItems.length < 10) {
        pagingController.appendLastPage(newItems);
      } else {
        pagingController.appendPage(newItems, pageKey + 1);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
        centerTitle: true,
      ),
      body: PagedListView<int, Listing>(
        pagingController: pagingController,
        builderDelegate: PagedChildBuilderDelegate<Listing>(
          itemBuilder: (context, item, index) => ListingCard(item),
        ),
      ),
    );
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }
}
