import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:quicksell_app/extensions.dart';
import 'package:quicksell_app/feed.dart' show Feed, SearchFilters;

class Search extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SearchState();
}

class SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.search),
          tooltip: "Set up filters",
          onPressed: setUpFilters,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.highlight_remove),
            tooltip: "Reset filters",
            onPressed: clearFilters,
          )
        ],
      ),
      body: context.appState.searchFilters != null
          ? Feed(context.appState.searchFilters)
          : Center(
              child: ElevatedButton(
                onPressed: setUpFilters,
                child: Text("Set up search filters"),
              ),
            ),
    );
  }

  void clearFilters() => setState(() => context.appState.searchFilters = null);

  void setUpFilters() {
    context.appState.searchFilters ??= SearchFilters();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => SearchFiltersView()))
        .then((_) => setState(() {}));
  }
}

class SearchFiltersView extends StatelessWidget {
  final formKey = GlobalKey<FormState>();

  SearchFiltersView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search filters")),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 25.0),
          alignment: Alignment.center,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Icon(Icons.search, size: 100.0),
                SizedBox(height: 40.0),
                _TitleField(),
                _MinPriceField(),
                _MaxPriceField(),
                SizedBox(height: 40.0),
                ElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    var formState = formKey.currentState!;
                    formState.save();
                    if (formState.validate()) {
                      context.appState.searchFilters!.reloadSearchView();
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Search'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  late final SearchFilters filters;

  @override
  Widget build(BuildContext context) {
    filters = context.appState.searchFilters!;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.create),
      title: TextFormField(
        decoration: InputDecoration(
          labelText: "Title",
          hintText: "Filter listings by title",
        ),
        initialValue: filters.title,
        keyboardType: TextInputType.text,
        validator: (input) =>
            input != null && input.isNotEmpty && input.length < 4
                ? "You must enter at least four characters"
                : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        onSaved: (input) {
          if (input != null && input.length > 3) filters.title = input;
        },
      ),
    );
  }
}

class _MinPriceField extends StatelessWidget {
  late final SearchFilters filters;

  @override
  Widget build(BuildContext context) {
    filters = context.appState.searchFilters!;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.monetization_on),
      title: TextFormField(
        decoration: InputDecoration(
          labelText: "Minimum price",
          hintText: "Enter some digits",
        ),
        initialValue: filters.minPrice?.toString(),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        onSaved: (input) {
          if (input != null) filters.minPrice = int.tryParse(input);
        },
      ),
    );
  }

  String? validator(String? input) {
    if (input != null && input.isNotEmpty) {
      var price = int.parse(input);
      if (price < 10 || price > 9999999)
        return "Price must be in range 10 - 9999999";
      if (filters.maxPrice != null && price > filters.maxPrice!)
        return "Minimum price can't be greater than maximum";
    }
  }
}

class _MaxPriceField extends StatelessWidget {
  late final SearchFilters filters;

  @override
  Widget build(BuildContext context) {
    filters = context.appState.searchFilters!;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.monetization_on),
      title: TextFormField(
        decoration: InputDecoration(
          labelText: "Maximum price",
          hintText: "Enter some digits",
        ),
        initialValue: filters.maxPrice?.toString(),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        onSaved: (input) {
          if (input != null) filters.maxPrice = int.tryParse(input);
        },
      ),
    );
  }

  String? validator(String? input) {
    if (input != null && input.isNotEmpty) {
      var price = int.parse(input);
      if (price < 10 || price > 9999999)
        return "Price must be in range 10 - 9999999";
      if (filters.minPrice != null && price < filters.minPrice!)
        return "Maximum price can't be lower than minimum";
    }
  }
}
