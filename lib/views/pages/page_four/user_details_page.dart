import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sat/data/models/action_model.dart';
import 'package:sat/data/models/bill_item_model.dart';
import 'package:sat/logic/blocs/action_bloc/action_bloc.dart';
import 'package:sat/logic/blocs/action_bloc/action_event.dart';
import 'package:sat/logic/blocs/action_bloc/action_state.dart';
import 'package:sat/views/widgets/filter_appbar_container.dart';

class UserDetailsPage extends StatefulWidget {
  final String storeId;
  final String userId;

  const UserDetailsPage({
    super.key,
    required this.storeId,
    required this.userId,
  });

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  @override
  void initState() {
    super.initState();
    // Load actions as soon as page opens
    context
        .read<ActionBloc>()
        .add(LoadUserActions(storeId: widget.storeId, userId: widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Details"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          UserActionsFilterBar(storeId: widget.storeId, userId: widget.userId),
          Expanded(
            child: BlocBuilder<ActionBloc, ActionState>(
            builder: (context, state) {
              if (state is UserActionsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is UserActionsError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                );
              } else if (state is UserActionsLoaded) {
                final actions = state.actions;
                if (actions.isEmpty) {
                  return const Center(
                    child: Text(
                      "No actions found for this user.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: actions.length,
                  itemBuilder: (context, index) {
                    final action = actions[index];
                    final bill = action.bill;

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ExpansionTile(
                        title: Text("Date: "+
                            bill.createdAt.toString().split(' ').first,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Hour: ${bill.createdAt.toString().split(' ').last.substring(0, 8)}",
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text("Total Price: ${bill.totalPrice.toStringAsFixed(3)} DT",
                                style: const TextStyle(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.w500,)
                            ),
                            Text("Bill ID: ${bill.id ?? 'Unknown'}",
                                style: const TextStyle(
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.w500,)
                            ),
                          ],
                        ),
                        children: [
                          ...bill.billItems.map((item) => _buildBillItemRow(item)),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Total: ${bill.totalPrice.toStringAsFixed(2)} DT",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
              return const SizedBox();
            },
          ),)
        ],
      )
    );
  }

  Widget _buildBillItemRow(BillItemModel item) {
    final itemTotal = (item.quantity * item.price).toStringAsFixed(3);

    return ListTile(
      dense: true,
      leading: item.imageUrl != null && item.imageUrl!.isNotEmpty
          ? ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          item.imageUrl!,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),
        ),
      )
          : const Icon(Icons.shopping_bag, size: 40, color: Colors.grey),
      title: Text(item.name ?? "Unknown Product"),
      subtitle: Text("Qty: ${item.quantity} × ${item.price.toStringAsFixed(3)} DT"),
      trailing: Text(
        "$itemTotal DT",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

}
