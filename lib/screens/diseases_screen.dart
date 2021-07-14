import 'package:covid_app/models/disease.dart';
import 'package:covid_app/providers/auth.dart';
import 'package:covid_app/providers/operation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/extensions.dart';

class DiseasesScreen extends StatefulWidget {
  static const routeName = 'diseases-screen';
  const DiseasesScreen({Key? key}) : super(key: key);

  @override
  _DiseasesScreenState createState() => _DiseasesScreenState();
}

class _DiseasesScreenState extends State<DiseasesScreen> {
  bool isInit = true;
  String? newName;
  bool _isChronicle = false;

  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<Operation>(context, listen: false)
          .getPatientDiseases(
        Provider.of<Auth>(context, listen: false).user!.id!,
      )
          .then((value) {
        setState(() {
          isInit = false;
        });
      });
    }
    super.didChangeDependencies();
  }

  Future<void> addNewDisease() async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text(
              "Disease Name",
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      newName = value;
                      print('$newName');
                    });
                  },
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: Text('is a chronicle disease?'),
                  value: _isChronicle,
                  onChanged: (value) {
                    setState(() {
                      _isChronicle = !_isChronicle;
                      print('$_isChronicle');
                    });
                  },
                ),
              ],
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "Add",
                  style: TextStyle(
                    color: Colors.green[900],
                  ),
                ),
                onPressed: newName == null || newName!.isEmpty
                    ? null
                    : () {
                        Navigator.of(context).pop();
                        if (newName == null || newName!.length <= 0) {
                          return;
                        }
                        Provider.of<Operation>(context, listen: false)
                            .addNewDisease(
                          Provider.of<Auth>(context, listen: false).user!.id!,
                          Disease(
                            name: newName!,
                            isChronicle: _isChronicle,
                          ),
                        );
                      },
              ),
              TextButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.green[900],
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final diseases = Provider.of<Operation>(context).diseases;
    final chronics = diseases.where((el) => el.isChronicle).toList();
    final previous = diseases.where((el) => !el.isChronicle).toList();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: addNewDisease,
              icon: Icon(Icons.add),
            ),
          ],
          bottom: TabBar(
            onTap: (index) {},
            tabs: [
              Tab(text: 'Chronic Diseases'),
              Tab(text: 'Previous Diseases'),
            ],
          ),
          title: Text('Diseases Screen'),
        ),
        body: isInit
            ? Center(
                child: CircularProgressIndicator(),
              )
            : TabBarView(
                children: [
                  chronics.length <= 0
                      ? Center(child: Text('No Chronic Diseases'))
                      : ListView(
                          shrinkWrap: true,
                          children: chronics
                              .map(
                                (item) => Column(
                                  children: [
                                    ListTile(
                                      title: Text(item.name.capitalize()),
                                    ),
                                    Divider()
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                  previous.length <= 0
                      ? Center(child: Text('No Previous Diseases'))
                      : ListView(
                          shrinkWrap: true,
                          children: previous
                              .map(
                                (item) => Column(
                                  children: [
                                    ListTile(
                                      title: Text(item.name.capitalize()),
                                    ),
                                    Divider(),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                ],
              ),
      ),
    );
  }
}
