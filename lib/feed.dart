import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:quicksell_app/extensions.dart';
import 'package:quicksell_app/listing/lib.dart' show Listing, ListingCard;
import 'package:quicksell_app/profile/lib.dart' show Profile;

class SearchFilters with ChangeNotifier {
  String? title;
  int? minPrice;
  int? maxPrice;
  String? category;
  String? sellerUuid;
  String? orderBy;

  SearchFilters();
  SearchFilters.byProfile(Profile profile)
      : sellerUuid = profile.uuid,
        orderBy = '-ts_spawn';

  Map<String, String> toJson() {
    return {
      if (title != null) 'title': title!,
      if (minPrice != null) 'min_price': minPrice.toString(),
      if (maxPrice != null) 'max_price': maxPrice.toString(),
      if (category != null) 'category': category!,
      if (sellerUuid != null) 'seller': sellerUuid!,
      if (orderBy != null) 'order_by': orderBy!
    };
  }

  void reloadSearchView() => notifyListeners();
}

class Feed extends StatefulWidget {
  final SearchFilters? filters;
  Feed([this.filters]);

  @override
  State createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  final pagingController = PagingController<int, Listing>(firstPageKey: 0);

  @override
  void initState() {
    pagingController.addPageRequestListener((pageKey) => fetchPage(pageKey));
    widget.filters?.addListener(refresh);
    super.initState();
  }

  void refresh() => pagingController.refresh();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(refresh),
      child: PagedListView<int, Listing>(
        pagingController: pagingController,
        builderDelegate: PagedChildBuilderDelegate<Listing>(
          itemBuilder: (_, listing, __) {
            listing.addListener(() => pagingController.refresh());
            return ListingCard(listing);
          },
        ),
      ),
    );
  }

  Future<void> fetchPage(int pageKey) async {
    try {
      final newItems = await context.api.getListings(
        pageKey,
        widget.filters?.toJson(),
      );
      if (mounted)
        newItems.isNotEmpty
            ? pagingController.appendPage(newItems, pageKey + 1)
            : pagingController.appendLastPage(newItems);
    } catch (error) {
      pagingController.error = error;
    }
  }

  @override
  void dispose() {
    widget.filters?.removeListener(refresh);
    pagingController.dispose();
    super.dispose();
  }
}
