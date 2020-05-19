import 'package:flutter/material.dart';
import 'package:meal_practice_app/widget/order.dart';
import 'package:provider/provider.dart';
import '../providers/Orders_Providers.dart';

class Order_Screen extends StatefulWidget {
  static const routename = "/orderscreen";

  @override
  _Order_ScreenState createState() => _Order_ScreenState();
}

class _Order_ScreenState extends State<Order_Screen> {
  var init = true;
  var isloading = false;
  var idx=0;
  @override
  void initState() {
    idx++;
    Future.delayed(Duration.zero).then((_) async{
//      setState(() {
//        //print("1");
//        isloading=true;
//      });
       await Provider.of<Orders_list>(context,listen: false).fetchorder();
       setState(() {
         //print("2");
         isloading=false;
       });
    });
    super.initState();
  }


//  @override
//  void didChangeDependencies() async {
//    if (init) {
//      setState(() {
//        isloading = true;
//      });
//      try {
//        await Provider.of<Orders_list>(context).fetchorder();
//      } catch (error) {
//        showDialog(
//            context: context,
//            child: AlertDialog(
//              content: Text("sorry no orders can be loadid"),
//            ));
//        setState(() {
//
//          isloading = false;
//        });
//      } finally {
//
//        setState(() {
//          isloading = false;
//        });
//     }
//    }
//    init = false;
//
//    super.didChangeDependencies();
//  }
  @override
  Widget build(BuildContext context) {
     final orders=Provider.of<Orders_list>(context);

   // orders.order_map.forEach((id,value)=>print(value.prod));
     idx++;
    print("sdf");
    print(idx);
    
    return Scaffold(

        appBar: AppBar(

          title: Text(
            "Orders$idx",
          ),
        ),
        body:isloading?CircularProgressIndicator() : ListView(
          children: orders.order_map.values.toList().map((od) {
              return Orders(amt: od.amount,cart: od.prod,);
          }).toList(),
        ));
  }
}
