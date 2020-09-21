import 'package:example/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_network_library/data_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await RESTExecutor.initialize(config, domains);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return RESTListenableBuilder(
          executor: RESTExecutor(
              domain: 'appState',
              label: 'theme'
            ),
            exact: true,
          builder:(response){
            print("inside listenable");
            return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          brightness: (response.value('dark')??true)?Brightness.dark:Brightness.light,
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: 'Network Library Example'),
      );
          }
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  RESTExecutor _changeTheme = RESTExecutor(
    domain: 'appState',
    label: 'theme'
  );

  RESTExecutor _getData = RESTExecutor(
    domain: 'api',
    label: 'list'
  );

  @override
  Widget build(BuildContext context) {

    print("building");

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
         
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[ 
            Text(
              'For Local State Management',
              style: TextStyle(
                fontSize:18,
                height: 2
              ),
            ),
            SizedBox(height: 20,),
            Text(
                _changeTheme.response.data.toString(),
              ),
            SizedBox(height: 20,),
            RaisedButton(
              onPressed: (){
                _changeTheme.execute(
                  data: {
                    'dark':!(_changeTheme.response.value('dark')??true)
                  }
                );
              },
                          child: Text(
                'Change Theme',
              ),
            ),
            Divider(),
            Text(
              'For Network Request Caching',
              style: TextStyle(
                fontSize:18,
                height: 2
              ),
            ),
            SizedBox(height: 20,),
             ValueListenableBuilder(
               valueListenable: _getData.getListenable(),
                            builder:(_,__,___)=> Text(
                              _getData.response.fetching?
                              'Loading...':
                  _getData.response.data.toString(),
                ),
             ),
            SizedBox(height: 20,),
            RaisedButton(
              onPressed: (){
                _getData.execute(
                  
                );
              },
                          child: Text(
                'Fetch Data',
              ),
            ),
            RESTListenableBuilder(
              executor: RESTExecutor(domain: 'appState',label: 'theme'),
              builder: (response)=>Text(response.data.toString()),
            )
          ],
        ),
      ),
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
