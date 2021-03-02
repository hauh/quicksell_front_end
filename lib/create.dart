import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:provider/provider.dart';
import 'package:quicksell_app/api.dart' show API;
import 'package:quicksell_app/authorization.dart' show AuthenticationRequired;
import 'package:quicksell_app/listing.dart' show ListingView;
import 'package:quicksell_app/state.dart' show AppState;

class CreateListing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthenticationRequired(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Listing'),
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: _CreateListingView(),
        ),
      ),
    );
  }
}

class _CreateListingView extends StatefulWidget {
  @override
  _CreateState createState() => _CreateState();
}

class _CreateState extends State<_CreateListingView> {
  GlobalKey<FormState> formKey;
  String title;
  String description;
  String category;
  int price;
  bool conditionNew;

  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 25.0),
          child: Column(
            children: [
              SizedBox(height: 40.0),
              _TitleField(setter: (input) => title = input),
              _PriceField(setter: (input) => price = int.parse(input)),
              _DescriptionField(setter: (input) => description = input),
              _ConditionField(setter: (choice) => conditionNew = choice),
              _CategoryField(setter: (choice) => category = choice),
              SizedBox(height: 40.0),
              ElevatedButton(
                child: Text('Create'),
                onPressed: () => submitForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submitForm() {
    FocusScope.of(context).unfocus();
    if (formKey.currentState.validate()) {
      AppState.waiting("Creating listing...");
      context
          .read<API>()
          .createListing(title, description, category, price, conditionNew)
          .whenComplete(() => AppState.stopWaiting())
          .then(
        (listing) {
          AppState.notify("Listing ${listing.title} created!");
          formKey.currentState.reset();
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ListingView(listing)),
          );
        },
      ).catchError((err) => AppState.notify(err.toString()));
    }
  }
}

class _TitleField extends StatelessWidget {
  final Function(String) setter;

  _TitleField({this.setter});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.create),
      title: TextFormField(
        decoration: InputDecoration(
          labelText: "Title",
          hintText: "Name the item you want to sell.",
        ),
        keyboardType: TextInputType.text,
        validator: (value) => value.isEmpty ? "Enter something" : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: setter,
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
      ),
    );
  }
}

class _PriceField extends StatelessWidget {
  final Function(String) setter;

  _PriceField({this.setter});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.money),
      title: TextFormField(
        decoration: InputDecoration(
          labelText: "Price",
          hintText: "Enter some digits.",
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (value) => value.length > 7 || value.length < 3
            ? "Price must be in range 100 - 9999999"
            : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: setter,
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
      ),
    );
  }
}

class _DescriptionField extends StatelessWidget {
  final Function(String) setter;

  _DescriptionField({this.setter});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.article),
      title: TextFormField(
        decoration: InputDecoration(
          labelText: "Description",
          hintText: "Describe your item.",
        ),
        keyboardType: TextInputType.multiline,
        maxLines: null,
        validator: (value) => value.isEmpty ? "Enter something" : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: setter,
        onEditingComplete: () => FocusScope.of(context).unfocus(),
      ),
    );
  }
}

mixin _ErrorMessage {
  Text showError(FormFieldState state) {
    var theme = Theme.of(state.context);
    return state.hasError
        ? Text(
            state.errorText,
            style: theme.textTheme.caption.copyWith(color: theme.errorColor),
          )
        : null;
  }
}

class _ConditionField extends StatelessWidget with _ErrorMessage {
  final Function(bool) setter;

  _ConditionField({this.setter});

  @override
  Widget build(BuildContext context) {
    return FormField<List<bool>>(
      initialValue: [false, false],
      validator: (value) => !value.contains(true) ? "Required" : null,
      builder: (state) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(Icons.important_devices),
        title: Text("Condition"),
        subtitle: showError(state),
        trailing: ToggleButtons(
          children: [Text("Used"), Text("New")],
          isSelected: state.value,
          onPressed: (index) {
            FocusScope.of(context).unfocus();
            state.didChange(
              List<bool>.generate(state.value.length, (i) => i == index),
            );
            setter(state.value[1]);
          },
        ),
      ),
    );
  }
}

class _CategoryField extends StatelessWidget with _ErrorMessage {
  final String defaultValue = "Choose a category";
  final Function(String) setter;

  _CategoryField({this.setter});

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: defaultValue,
      validator: (value) =>
          value.isEmpty || value == defaultValue ? "Required" : null,
      builder: (state) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(Icons.category),
        title: Text("Category"),
        subtitle: showError(state),
        trailing: TextButton(
          child: FractionallySizedBox(
            widthFactor: 0.5,
            child: Text(state.value, textAlign: TextAlign.end),
          ),
          onPressed: () {
            FocusScope.of(context).unfocus();
            showDialog(
              context: context,
              builder: (_) => _CategoryTree(state: state, setter: setter),
            );
          },
        ),
      ),
    );
  }
}

class _CategoryTree extends StatefulWidget {
  final FormFieldState<String> state;
  final Function(String) setter;

  _CategoryTree({this.state, this.setter});

  @override
  State<StatefulWidget> createState() => _CategoryTreeState();
}

class _CategoryTreeState extends State<_CategoryTree> {
  Map<String, dynamic> subcategories;
  List<String> path;
  String title;

  @override
  void initState() {
    subcategories = context.read<API>().categories;
    title = widget.state.value;
    path = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.all(15.0),
      title: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (path.isNotEmpty)
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => setState(() {
                subcategories = context.read<API>().categories;
                path.removeLast();
                path.forEach((branch) => subcategories = subcategories[branch]);
                title = path.isNotEmpty ? path.last : widget.state.value;
              }),
            ),
          Expanded(child: Text(title, textAlign: TextAlign.center)),
          IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      contentPadding: EdgeInsets.all(8.0),
      content: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            for (var node in subcategories.entries)
              Card(
                child: node.value.isNotEmpty
                    ? ListTile(
                        title: Text(node.key),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () => setState(() {
                          title = node.key;
                          subcategories = node.value;
                          path.add(title);
                        }),
                      )
                    : ListTile(
                        title: Text(node.key),
                        trailing: Icon(Icons.radio_button_off),
                        onTap: () {
                          widget.setter(node.key);
                          widget.state.didChange(node.key);
                          Navigator.of(context).pop();
                        },
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
