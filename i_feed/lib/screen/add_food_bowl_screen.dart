import 'package:flutter/material.dart';
import 'package:i_feed/model/details/user_id.dart';
import 'package:provider/provider.dart';

import '../widget/button_with_icon.dart';
import '../model/feed_element.dart';
import '../provider/elements.dart';
import '../provider/actions.dart';
import '../provider/users.dart';

class AddFoodBowlScreen extends StatefulWidget {
  static const routeName = '/add_food_bowl';
  @override
  _AddFoodBowlScreenState createState() => _AddFoodBowlScreenState();
}

class _AddFoodBowlScreenState extends State<AddFoodBowlScreen> {
  final _weightFocusNode = FocusNode();
  final _brandFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  FeedElement _editedFoodBowl = FeedElement(
      elementId: null,
      type: 'food_bowl',
      name: "food bowl",
      active: true,
      createdTimestamp: null,
      createdBy: null,
      location: null,
      elementAttributes: {
        "state": false,
        "animal": "",
        "weight": 0,
        "brand": "",
        "lastFillDate": "",
      });

  var _initFoodBowl = {
    "animal": "",
    "weight": 0,
    "brand": "",
  };

  var _isInit = true;
  var _isLoading = false;

  void didChangeDependencies() {
    if (_isInit) {
      final _bowlId = ModalRoute.of(context).settings.arguments as String;
      if (_bowlId != null) {
        final currentWaterBowl =
            Provider.of<Elements>(context).findBowl(_bowlId);
        if (currentWaterBowl != null) {
          _editedFoodBowl = currentWaterBowl;
          _initFoodBowl = {
            'animal': _editedFoodBowl.elementAttributes['animal'],
            'weight': _editedFoodBowl.elementAttributes['weight'],
            'brand': _editedFoodBowl.elementAttributes['brand'],
          };
        }
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _weightFocusNode.dispose();
    _brandFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit(FeedElement feedArea, UserId userId) async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_editedFoodBowl.elementId != null) {
        await Provider.of<FeedActions>(context, listen: false)
            .updateFoodBowl(_editedFoodBowl, userId);
      } else {
        await Provider.of<FeedActions>(context, listen: false)
            .addFoodBowl(_editedFoodBowl, feedArea, userId);
      }
      Navigator.of(context).pop();
    } catch (error) {
      const errorMessage = 'Cant sumbit, Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An Error Occurred'),
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Okay'),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final _feedAreaId = ModalRoute.of(context).settings.arguments as String;
    final _userId = Provider.of<Users>(context, listen: false).user.userId;
    final _elementData = Provider.of<Elements>(context, listen: false);
    final _feedArea = _editedFoodBowl.elementId == null
        ? _elementData.findFeedArea(_feedAreaId)
        : null;
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Bowl'),
        actions: <Widget>[],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 60,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.green,
                                blurRadius: 20,
                                offset: Offset(0, 10))
                          ]),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              initialValue: _initFoodBowl['animal'],
                              enabled:
                                  !_editedFoodBowl.elementAttributes['state'],
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                labelText: 'animal type',
                              ),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_weightFocusNode);
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'please provide the animal type';
                                }
                                return null;
                              },
                              onSaved: (value) => _editedFoodBowl
                                  .elementAttributes['animal'] = value,
                            ),
                            TextFormField(
                              initialValue: "${_initFoodBowl['weight']}",
                              enabled:
                                  !_editedFoodBowl.elementAttributes['state'],
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                labelText: 'weight',
                              ),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_brandFocusNode);
                              },
                              validator: (value) {
                                if (value.isEmpty && value == '0') {
                                  return 'please provide the weight';
                                }
                                return null;
                              },
                              onSaved: (value) => _editedFoodBowl
                                  .elementAttributes['weight'] = value,
                            ),
                            TextFormField(
                              initialValue: _initFoodBowl['brand'],
                              enabled:
                                  !_editedFoodBowl.elementAttributes['state'],
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                labelText: 'brand',
                              ),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) =>
                                  _submit(_feedArea, _userId),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'please provide the brand';
                                }
                                return null;
                              },
                              onSaved: (value) => _editedFoodBowl
                                  .elementAttributes['brand'] = value,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Container(
              margin: EdgeInsets.all(20),
              width: 150,
              child: ButtonWithIcon(
                title: _editedFoodBowl.elementId == null ? 'Add' : 'Update',
                color: Colors.green,
                icon: _editedFoodBowl.elementId == null
                    ? Icons.add
                    : Icons.update,
                function: () {
                  _submit(_feedArea, _userId);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
