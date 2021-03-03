part of listing;

class EditListing extends StatelessWidget {
  final Widget title;
  final Widget form;

  EditListing.create()
      : title = const Text('Create Listing'),
        form = _Create();
  EditListing.update(Listing listing)
      : title = const Text('Update Listing'),
        form = _Update(listing);

  @override
  Widget build(BuildContext context) {
    return AuthenticationRequired(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(title: title, centerTitle: true),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 25.0),
              child: form,
            ),
          ),
        ),
      ),
    );
  }
}

class _Create extends StatelessWidget {
  @override
  Widget build(BuildContext _) {
    return Provider(
      create: (_) => ListingFormData(),
      child: Consumer2<API, ListingFormData>(
        builder: (context, api, formData, _) => _Form(
          onSubmit: () {
            AppState.waiting("Creating listing...");
            api
                .createListing(formData)
                .whenComplete(() => AppState.stopWaiting())
                .then(
              (listing) {
                AppState.notify("Listing ${listing.title} created!");
                formData.clear();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => _ListingView(listing)),
                );
              },
            ).catchError((err) => AppState.notify(err.toString()));
          },
        ),
      ),
    );
  }
}

class _Update extends StatelessWidget {
  final Listing listing;
  _Update(this.listing);

  @override
  Widget build(BuildContext _) {
    return Provider(
      create: (_) => ListingFormData.fromListing(listing),
      child: Consumer2<API, ListingFormData>(
        builder: (context, api, formData, _) => _Form(
          onSubmit: () {
            AppState.waiting("Updating listing...");
            api
                .updateListing(formData)
                .whenComplete(() => AppState.stopWaiting())
                .then(
              (savedFormData) {
                AppState.notify("Listing ${savedFormData.title} updated!");
                listing.updateWithForm(savedFormData);
                Navigator.of(context).pop();
              },
            ).catchError((err) => AppState.notify(err.toString()));
          },
        ),
      ),
    );
  }
}

class _Form extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final Function() onSubmit;
  _Form({this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          SizedBox(height: 40.0),
          _TitleField(),
          _PriceField(),
          _DescriptionField(),
          _ConditionField(),
          _CategoryField(),
          SizedBox(height: 40.0),
          ElevatedButton(
            child: Text('Submit'),
            onPressed: () {
              FocusScope.of(context).unfocus();
              if (formKey.currentState.validate()) {
                formKey.currentState.save();
                onSubmit();
                formKey.currentState.reset();
              }
            },
          ),
        ],
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  _TitleField();

  @override
  Widget build(BuildContext _) {
    return Consumer<ListingFormData>(
      builder: (context, formData, _) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(Icons.create),
        title: TextFormField(
          decoration: InputDecoration(
            labelText: "Title",
            hintText: "Name the item you want to sell.",
          ),
          keyboardType: TextInputType.text,
          initialValue: formData.title,
          validator: (input) => input.isEmpty ? "Required" : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onEditingComplete: () => FocusScope.of(context).nextFocus(),
          onSaved: (input) => formData.title = input,
        ),
      ),
    );
  }
}

class _PriceField extends StatelessWidget {
  @override
  Widget build(BuildContext _) {
    return Consumer<ListingFormData>(
      builder: (context, formData, _) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(Icons.money),
        title: TextFormField(
          decoration: InputDecoration(
            labelText: "Price",
            hintText: "Enter some digits.",
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          initialValue: formData.price?.toString(),
          validator: (input) => input.length > 7 || input.length < 3
              ? "Price must be in range 100 - 9999999"
              : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onEditingComplete: () => FocusScope.of(context).nextFocus(),
          onSaved: (input) => formData.price = int.parse(input),
        ),
      ),
    );
  }
}

class _DescriptionField extends StatelessWidget {
  @override
  Widget build(BuildContext _) {
    return Consumer<ListingFormData>(
      builder: (context, formData, _) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(Icons.article),
        title: TextFormField(
          decoration: InputDecoration(
            labelText: "Description",
            hintText: "Describe your item.",
          ),
          keyboardType: TextInputType.multiline,
          maxLines: null,
          initialValue: formData.description,
          validator: (input) => input.isEmpty ? "Required" : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onEditingComplete: () => FocusScope.of(context).unfocus(),
          onSaved: (input) => formData.description = input,
        ),
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
  @override
  Widget build(BuildContext _) {
    return Consumer<ListingFormData>(
      builder: (context, formData, _) => FormField<List<bool>>(
        initialValue: formData.conditionNew != null
            ? [!formData.conditionNew, formData.conditionNew]
            : [false, false],
        validator: (toggles) => !toggles.contains(true) ? "Required" : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onSaved: (toggles) => formData.conditionNew = toggles[1],
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
            },
          ),
        ),
      ),
    );
  }
}

class _CategoryField extends StatelessWidget with _ErrorMessage {
  final String defaultValue = "Choose a category";

  @override
  Widget build(BuildContext _) {
    return Consumer<ListingFormData>(
      builder: (context, formData, _) => FormField<String>(
        initialValue: formData.category ?? defaultValue,
        validator: (choice) => choice == defaultValue ? "Required" : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onSaved: (choice) => formData.category = choice,
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
                builder: (_) => _CategoryTree(state),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _CategoryTree extends StatefulWidget {
  final FormFieldState<String> state;
  _CategoryTree(this.state);

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