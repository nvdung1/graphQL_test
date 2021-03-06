import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
const productsGraphQl= """ 
   query user {
    User(name: "nádasd") {
      id
      name
      about
      updatedAt
      avatar {
        medium
      }
  }
}""";


void main() {
  final HttpLink httpLink = HttpLink("https://graphql.anilist.co");
  ValueNotifier<GraphQLClient> client= ValueNotifier(GraphQLClient(link: httpLink, cache: GraphQLCache(store: InMemoryStore())));
  var app= GraphQLProvider(client: client,child: const MyApp());

  runApp(app);
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Query(
        options: QueryOptions(
          document: gql(productsGraphQl),
        ),
        builder: ( QueryResult result,{ fetchMore, refetch}){
          if(result.hasException){
            print(result.exception);
            return Text(result.exception.toString());
          }
          if(result.isLoading){
            return const Center(
              child:  CircularProgressIndicator(),
            );
          }
          final productList= result.data?['User']['name'];
          print(productList);
          return const Text("hello");
          // return Column(
          //   children: [
          //     Padding(padding: const EdgeInsets.all(10),
          //       child: Text("Products", style: Theme.of(context).textTheme.headline5),),
          //     Expanded(child: GridView.builder(
          //         itemCount: productList.length,
          //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //           crossAxisCount: 2,
          //           mainAxisSpacing: 2.0,
          //           crossAxisSpacing: 2.0,
          //           childAspectRatio: 0.75
          //         ),
          //         itemBuilder: (_,index) {
          //           var product= productList[index]['node'];
          //           return Column(
          //             children: [
          //               Container(
          //                 padding: const EdgeInsets.all(2),
          //                 width: 180,
          //                 height: 180,
          //                 child: Image.network(product['thumbnail']['url']),
          //               ),
          //               Padding(
          //                 padding: const EdgeInsets.symmetric(vertical: 8.0),
          //                 child: Text(product['name']),
          //               ),
          //               const Text("4.50\$")
          //             ],
          //           );
          //         })
          //     )
          //   ],
          // );
        } ,
      )
    );
  }
}
