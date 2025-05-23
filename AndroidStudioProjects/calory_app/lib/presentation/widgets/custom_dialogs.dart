import 'package:flutter/material.dart';
import 'package:calory_app/core/constants/border_styles.dart';

void errorDialog({
  required BuildContext context,
  required int statusCode,
  required String description,
  required Color color,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      String friendlyMessage;
      String title = "Đã xảy ra lỗi";
      
      if (statusCode == 401) {
        title = "Lỗi xác thực";
        friendlyMessage = "Phiên đăng nhập đã hết hạn hoặc không hợp lệ. Vui lòng đăng nhập lại.";
      } else if (statusCode == 404) {
        title = "Không tìm thấy";
        friendlyMessage = "Thông tin bạn đang tìm kiếm không tồn tại.";
      } else if (statusCode == 400) {
        title = "Yêu cầu không hợp lệ";
        friendlyMessage = "Dữ liệu bạn gửi không hợp lệ. Vui lòng kiểm tra lại.";
      } else if (statusCode >= 500) {
        title = "Lỗi máy chủ";
        friendlyMessage = "Đã xảy ra lỗi từ máy chủ. Vui lòng thử lại sau.";
      } else {
        friendlyMessage = "Đã xảy ra lỗi. Vui lòng thử lại sau.";
      }
      
      return AlertDialog(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(title),
        ),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(friendlyMessage),
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

Future<bool> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  required Color color,
}) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            MaterialButton(
              color: color,
              textColor: Colors.white,
              padding: const EdgeInsets.all(18),
              hoverElevation: 0,
              elevation: 0,
              focusElevation: 0,
              shape: BorderStyles.buttonBorder,
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Cancel"),
            ),
            MaterialButton(
              color: color,
              textColor: Colors.white,
              padding: const EdgeInsets.all(18),
              hoverElevation: 0,
              elevation: 0,
              focusElevation: 0,
              shape: BorderStyles.buttonBorder,
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Confirm"),
            )
          ],
        );
      }).then((value) => value ?? false);
} 