import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sat/data/models/action_model.dart';
import 'package:sat/logic/blocs/action_bloc/action_bloc.dart';
import 'package:sat/logic/blocs/action_bloc/action_event.dart';

class UserActionsFilterBar extends StatefulWidget {
  final String storeId;
  final String userId;

  const UserActionsFilterBar({super.key, required this.storeId, required this.userId});

  @override
  State<UserActionsFilterBar> createState() => _UserActionsFilterBarState();
}

class _UserActionsFilterBarState extends State<UserActionsFilterBar> {
  String filterTitle = "Filter By";

  void _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        filterTitle = "${picked.year}/${picked.month}/${picked.day}";
      });
      context.read<ActionBloc>().add(FilterActionsByDay(widget.storeId, widget.userId, picked));
    }
  }

  void _selectPeriod() async {
    final options = ["All Actions", "This Day", "This Week", "This Month", "This Year"];
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => ListView(
        shrinkWrap: true,
        children: options.map((e) {
          return ListTile(
            title: Text(e),
            onTap: () => Navigator.pop(context, e),
          );
        }).toList(),
      ),
    );

    if (selected != null) {
      setState(() {
        filterTitle = selected;
      });

      context.read<ActionBloc>().add(FilterActionsByPeriod(storeId: widget.storeId, userId: widget.userId, period: selected));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.calendar_today, color: Colors.blueAccent),
          onPressed: _pickDate,
        ),
        Expanded(
          child: ListTile(
            title: Text(filterTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: const Icon(Icons.arrow_drop_down),
            onTap: _selectPeriod,
          ),
        ),
      ],
    );
  }
}
