import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:sat/data/models/bill_model.dart';
import 'package:sat/logic/blocs/store_bloc/store_bloc.dart';
import 'package:sat/logic/blocs/store_bloc/store_event.dart';
import '../../../logic/blocs/store_bloc/store_state.dart';
import '../../../logic/change_notifiers/basket_notifier.dart';


class BasketPage extends StatelessWidget {
  final String storeId;
  const BasketPage({super.key,required this.storeId,});

  @override
  Widget build(BuildContext context) {
    final basket = context.watch<BasketProvider>();

    final user = FirebaseAuth.instance.currentUser;

    return BlocListener<StoreBloc, StoreState>(
      listener: (context, state) {
        if (state is BillConfirmed || state is StoreError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("✅ Bill confirmed successfully!"),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        }
        /*if (state is StoreError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }*/
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: basket.items.length,
                itemBuilder: (context, index) {
                  final item = basket.items[index];
                  return ListTile(
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(item.imageUrl??"https://cdn-icons-png.flaticon.com/512/962/962863.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(item.name),
                    subtitle: Text("Qty: ${item.quantity}  •  ${item.price} dt"),
                    trailing: Text(
                      "${(item.price * item.quantity).toStringAsFixed(3)} dt",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    "Total: ${basket.totalPrice.toStringAsFixed(3)} dt",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Date: ${DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now())}",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      context.read<StoreBloc>().add(ConfirmBillEvent(storeId: storeId, bill: BillModel(storeId: storeId, userId: user!.uid, billItems: basket.items, totalPrice: basket.totalPrice)));
                      basket.clear();
                    },
                    child: Text("Confirm Purchase"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
