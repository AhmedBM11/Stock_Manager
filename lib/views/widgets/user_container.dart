import 'package:flutter/material.dart';

class UserContainer extends StatelessWidget {
  final String? avatarUrl;
  final String email;
  final String userName;
  final String accessibility;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onSeeDetails;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isEditing;
  final TextEditingController? accessibilityController;

  const UserContainer({
    super.key,
    this.avatarUrl,
    required this.email,
    required this.userName,
    required this.accessibility,
    required this.onPrev,
    required this.onNext,
    required this.onSeeDetails,
    required this.onEdit,
    required this.onDelete,
    this.isEditing = false,
    this.accessibilityController,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          onPrev();
        } else if (details.primaryVelocity! < 0) {
          onNext();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Edit / Delete buttons row
          (int.parse(accessibility)<3)?Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: onEdit,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: Text(isEditing ? "Save" : "Edit"),
              ),
              ElevatedButton(
                onPressed: onDelete,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red),
                child: Text(isEditing ? "Cancel" : "Delete"),
              ),
            ],
          ):SizedBox(),
          const SizedBox(height: 10),

          // Avatar with navigation arrows
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(icon: const Icon(Icons.chevron_left), onPressed: onPrev),
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(avatarUrl??"https://img.freepik.com/vecteurs-libre/cercle-utilisateurs-defini_78370-4704.jpg?semt=ais_hybrid&w=740&q=80"),
              ),
              IconButton(icon: const Icon(Icons.chevron_right), onPressed: onNext),
            ],
          ),
          const SizedBox(height: 10),

          // User name
          Text(userName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

          // Email
          Text(email, style: const TextStyle(fontSize: 16)),

          // Accessibility
          isEditing
              ? SizedBox(
            width: 100,
            child: TextField(
              controller: accessibilityController,
              textAlign: TextAlign.center,
            ),
          )
              : Text("Access Level: $accessibility", style: const TextStyle(fontSize: 16)),

          // See details
          TextButton(onPressed: onSeeDetails, child: const Text("See Details")),
        ],
      ),
    );
  }
}
