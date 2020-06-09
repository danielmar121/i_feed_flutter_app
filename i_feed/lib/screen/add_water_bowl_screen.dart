import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widget/button_with_icon.dart';
import '../model/feed_element.dart';
import '../provider/elements.dart';
import '../provider/actions.dart';
import '../model/details/user_id.dart';
import '../provider/users.dart';

class AddWaterBowlScreen extends StatefulWidget {
  static const routeName = '/add_water_bowl';
  @override
  _AddWaterBowlScreenState createState() => _AddWaterBowlScreenState();
}

class _AddWaterBowlScreenState extends State<AddWaterBowlScreen> {
  final _formKey = GlobalKey<FormState>();
  FeedElement _editedWaterBowl = FeedElement(
      elementId: null,
      type: 'water_bowl',
      name: "water bowl",
      active: true,
      createdTimestamp: null,
      createdBy: null,
      location: null,
      elementAttributes: {
        "state": false,
        "waterQuality": "",
      });

  var _initWaterBowl = {
    'waterQuality': '',
  };

  var _isInit = true;
  var _isLoading = false;

  void didChangeDependencies() {
    if (_isInit) {
      final _bowlId = ModalRoute.of(context).settings.arguments as String;
      if (_bowlId != null) {
        final _bowlId = ModalRoute.of(context).settings.arguments as String;
        final currentWaterBowl =
            Provider.of<Elements>(context, listen: false).findBowl(_bowlId);
        if (currentWaterBowl != null) {
          _editedWaterBowl = currentWaterBowl;
          _initWaterBowl = {
            'waterQuality': _editedWaterBowl.elementAttributes['waterQuality'],
          };
        }
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
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
      if (_editedWaterBowl.elementId != null) {
        await Provider.of<FeedActions>(context, listen: false)
            .updateWaterBowl(_editedWaterBowl, userId);
      } else {
        await Provider.of<FeedActions>(context, listen: false)
            .addWaterBowl(_editedWaterBowl, feedArea, userId);
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

    final _feedArea = _editedWaterBowl.elementId == null
        ? _elementData.findFeedArea(_feedAreaId)
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text('Water Bowl'),
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
                              initialValue: _initWaterBowl['waterQuality'],
                              enabled:
                                  !_editedWaterBowl.elementAttributes['state'],
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                labelText: 'water quality',
                              ),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) =>
                                  _submit(_feedArea, _userId),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'please provide the water quality';
                                }
                                return null;
                              },
                              onSaved: (value) => _editedWaterBowl
                                  .elementAttributes['waterQuality'] = value,
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
                title: _editedWaterBowl.elementId == null ? 'Add' : 'Update',
                color: Colors.green,
                icon: _editedWaterBowl.elementId == null
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
