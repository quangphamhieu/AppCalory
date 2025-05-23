import 'package:flutter/material.dart';
import 'package:calory_app/core/constants/border_styles.dart';
import 'package:calory_app/domain/entities/user.dart';
import 'package:calory_app/presentation/widgets/custom_text_fields.dart';

void userDetails({
  required BuildContext context,
  required User user,
  required Color color,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            const Text("User Details"),
            const SizedBox(height: 10),
            userDetailsTextField(label: "Email", value: user.email),
            const SizedBox(height: 10),
            userDetailsTextField(
                label: "Phone Number",
                value: user.phoneNumber ?? "Not Provided"),
            const SizedBox(height: 10),
            userDetailsTextField(
              label: "Weight",
              value: user.weight != null ? user.weight.toString() : "Not Provided"
            ),
            const SizedBox(height: 10),
            userDetailsTextField(
              label: "Height",
              value: user.height != null ? user.height.toString() : "Not Provided"
            ),
            const SizedBox(height: 10),
            userDetailsTextField(
              label: "BMI",
              value: user.bmi != null ? user.bmi.toString() : "Not Calculated"
            ),

          ],
        ),
        actions: [
          MaterialButton(
            color: color,
            textColor: Colors.white,
            padding: const EdgeInsets.all(18),
            hoverElevation: 0,
            elevation: 0,
            focusElevation: 0,
            shape: BorderStyles.buttonBorder,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Ok"),
          )
        ],
        actionsAlignment: MainAxisAlignment.center,
      );
    },
  );
} 