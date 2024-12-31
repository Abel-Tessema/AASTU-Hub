import 'package:flutter/material.dart';

import '../../models/departments.dart';

class DepartmentCard extends StatelessWidget {
  final Department department;

  const DepartmentCard({super.key, required this.department});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              department.name ?? "Unnamed Department",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(department.description ?? "No description available."),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.location_on, color: Theme.of(context).primaryColor),
                const SizedBox(width: 5),
                Text(
                  "Block: ${department.blockNumber ?? '-'}, Room: ${department.roomNumber ?? '-'}",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              department.isEngineering == true
                  ? "Engineering Department"
                  : "Applied Science Department",
              style: TextStyle(
                color: department.isEngineering == true
                    ? Colors.green
                    : Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
