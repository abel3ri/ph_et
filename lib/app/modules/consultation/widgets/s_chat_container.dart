import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class SChatContainer extends StatelessWidget {
  const SChatContainer({
    super.key,
    required this.message,
    required this.sender,
    required this.date,
  });

  final String message;
  final String sender;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            sender,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Material(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
            elevation: 5.0,
            color: Theme.of(context).colorScheme.primary,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            timeago.format(date),
            style: context.textTheme.bodySmall!.copyWith(
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}
