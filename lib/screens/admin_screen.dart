import '../models/data_model.dart';

import '../widgets/custom_app_bar_title.dart';
import '../models/product_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/pending_user_product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//  Screen only visible to the admin
//  Admin can approve or decline pendingProducts
class AdminScreen extends StatefulWidget {
  static const routeName = '/admin_screen';

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProductsProvider>(context, listen: false)
        .reloadPendingProducts();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: -5,
          title: CustomAppBarTitle(
              name: DataModel.APPROVE_PRODUCTS, icondata: Icons.done_all),
          actions: [
            IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  Provider.of<ProductsProvider>(context, listen: false)
                      .reloadPendingProducts();
                })
          ],
        ),
        drawer: AppDrawer(DataModel.APPROVE_PRODUCTS),
        body: Consumer<ProductsProvider>(
          builder: (ctx, ordersData, child) => RefreshIndicator(
            onRefresh: () {
              return Provider.of<ProductsProvider>(context, listen: false)
                  .reloadPendingProducts();
            },
            child: ordersData.getPendingProductItems.length <= 0
                ? Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        color: Colors.black,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.elliptical(1200, 2200),
                          ),
                          color: Colors.grey[900],
                        ),
                        width: MediaQuery.of(context).size.width - 1.5,
                        height: double.maxFinite,
                      ),
                      Center(
                        child: Text(DataModel.NO_PENDING_PRODUCTS),
                      ),
                    ],
                  )
                : Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        color: Colors.black,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.elliptical(1200, 2200),
                          ),
                          color: Colors.grey[900],
                        ),
                        width: MediaQuery.of(context).size.width - 1.5,
                        height: double.maxFinite,
                      ),
                      ListView.builder(
                        itemCount: ordersData.getPendingProductItems.length,
                        itemBuilder: (ctx, index) => PendingUserProductItem(
                          id: ordersData.getPendingProductItems[index].id,
                          title: ordersData.getPendingProductItems[index].title,
                          description: ordersData
                              .getPendingProductItems[index].description,
                          imageUrl:
                              ordersData.getPendingProductItems[index].imageUrl,
                          price: ordersData.getPendingProductItems[index].price,
                          productCategory: ordersData
                              .getPendingProductItems[index].productCategory,
                          retailerId: ordersData
                              .getPendingProductItems[index].retailerId,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
