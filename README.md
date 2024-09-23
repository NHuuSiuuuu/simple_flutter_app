# Làm quen với ứng dụng đơn giản sử dụng Flutter và Datt

Trong bài lab này tôi sẽ hướng dẫn phát triển ứng dụng full-stack đơn giản với Dart và Flutter bao gồm backend và frontend

Việc sử dụng các framework hiện đại trong phát triển ứng dụng web giúo tăng tốc quá trình phát triển và dễ dàng quản lý dự án.
Flutter là 1 công cụ phát triển ứng dụng đa nền tảng, cho phép chúng ta tạo ra các ứng dụng cho web, di động (Android, iOS) và desktop (Window, macOs và Linux) từ cùng 1 dự án mã nguồn (codebase). Điều này giúp chúng ta tiết kiệm thời gian và công sức khi chúng ta cần viết mã một lần mà có thể biên dịch để chạy trên nhiều nền tảng khác nhau.

Quá trình biên dịch và phát hành ứng dụng web từ Dart và Framework sẽ tự động sinh ra mã cho backend và mã cho frontend (HTML, CSS và JavaScript) mà chúng ta không cần phải viết chúng trực tiếp. Điều này giúp chúng ta tập trung vào logic ứng dụng và giảm nhiều thời gian viết mã lặp lại. Tương tự, khi biên dịch ra các nền tảng di động hay desktop, chúng cũng sinh ra ứng dựng native trên cùng 1 codebase.

##Mục tiêu 
- Hiểu và áp dụng được các khái niệm cơ bản về ứng dụng web di động, ứng dụng đa nền tảng.
- Sử dụng Flutter framework để tạo ra giao diện đơn giản cho 1 ứng dụng.
- Sử dụng dart và thư viện shelf, shelf_router để tạo server đơn giản xử lý yêu các yêu cầu HTTP theo chuẩn RESTful API.
- Tích hợp giao diện với logic và sử lý phản hồi từ sẻver, thực hiện thao tác gửi dữ liệu từ client lên server thông qua HTTP POST.
- Kiểm thử đơn giản với Postman để kiểm tra phản hồi từ server đối với các yêu cầu GET và POST, bano gồm cả trường hợp lệ và không hợp lệ.

## Cấu trúc thư mục
Để tiện cho việc quản lý và có thể đẩy lên GitHub, chúng ta sẽ cài đặt backend và frontend trong cùng 1 mục dự án
```plaintext
simple_flutter_project\
|-- frontend/ # thư mục chứa mã nguồn Dart và Flutter cho frontend
|-- backend/ # thư mục chứa mã nguồn Dart cho backend
```
## Các bước thực hiện
### Bước 1: Khởi tạo dự án
1. Tạo thư mục gốc chứa dự án `simple_flutter_project`
2. Tạo thư mục `backend` và `frontend` trong thư mục `simple_flutter_project` như cấu trúc ở trên
3. Mở ứng dụng VS Code và mở thư mục `simple_flutter_project`


## Bước 2: Tạo ứng dụng server cho backend với Dart framework
1. Đi đến thư mục backend từ thư mục `simple_flutter_project`
```bash
cd backend
```
2. Khởi tạo dự án Dart mới cho server
```bash
dart create -t server-shelf . --force
```

**Lưu ý:**

- Lệnh `dart create -t server-shelf . --force` sẽ tạo 1 dự án với mẫu `-t, template` là `server-shelf` trong thư mục hiện tại `.` và tham số `--force` cho biết sẽ tạo dự án cho dù thư mục gốc có tồn tại (mặc định là sẽ tạo mới thư mục).

3. Thêm các thư viện và dự án backend nếu cần.
- Trong ứng dụng mẫu `server-shelf`, flutter đã sử dụng các thư viện `shelf` và `shelf-router` trong tệp `pubspec.yaml`

###Bước 3: Tạo ứng dụng frontend bằng Flutter framework
1. Quay lại thư mục dự án chính (nếu bạn đang ở thư mục backend)
```bash
    cd ..
```
2. Chuyển đến thư mục frontend
```bash
    cd frontend
```
3. Khởi tạo dự án Flutter mới trong thư mục frontend
```bash
    flutter create -e .
```
**Lư ý:** Lệnh trên sẽ tạo 1 dự án Flutter mới trong thư mục frontend với mẫu là `Empty Application` hay là tham số `-e` và tham số dấu `.` sẽ cho biết khởi tạo trong thư mục hiện tại là thư mục `frontend`.
4. Thêm thư viện `http` vào dự án frontend
```bash
    flutter pub add http
```

### Bước 4: Thiết lập debug cho cả backend và frontend
- Mở tệp `frontend/lib/main.dart`
- Chọn `Run and Debug` ở thanh Side bar và chọn `create a launch.jsonfile` để tạo file vấu hình gỡ lỗi (debug).
- Tiến hành gỡ lỗi backend và frontend khi debug. Các bạn có thể thay đổi cổng.

***Lưu ý:** Chúng ta lập cổng mặc định cho server | là 8080 và cổng mặc định cho frontend là 

### Bước 5: Đẩy dự án mã nguồn lên GitHub và quản lý mã nguồn
- Chọn `Source Control` ở thanh Side Bar và chọn `Publish to GitHub`.
- Quản lý mã nguồn bằng cách commit, push, pull (Sunc Changes ...), ... từ cửa sổ `Source Control`.

### Bước 6: Phát triển backend và kiểm thử
1. Chỉnh sửa file `backend/bin/server.dart`:
- Mở file `server.dart` và chỉnh sửa:
```dart
import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

/// Cấu hình các routes
final _router = Router(notFoundHandler: _notFoundHandler)
  ..get('/', _rootHandler)
  ..get('/api/v1/check', _checkHandler)
  ..get('/api/v1/echo/<message>', _echoHandler)
  ..post('/api/v1/submit', _submitHandler);

/// Header mặc định cho dữ liệu trả về dưới dạng JSON
final _headers = {'Content-Type': 'application/json'};

/// Xử lý các yêu cầu đến các đường dẫn không định nghĩa (404 Not Found)
Response _notFoundHandler(Request req) {
  return Response.notFound('Không tìm thấy đường dẫn "${req.url}" trên server');
}

/// Hàm sử lý yêu cầu gốc tại đường dẫn `/`
///
/// Trả về một phản hồi thông điệp "Hello, Word!" dưới dạng JSON
///
/// `reg` : Đối tượng yêu cầu client
///
/// Trả về: Một đối tượng `Response` với mã trangj thái 200 và nội dung JSON
Response _rootHandler(Request req) {
  // Construcor `ok` của Response có statusCode là 200
  return Response.ok(
    json.encode({'mesage': 'Hello, World!\n'}),
    headers: _headers,
  );
}

/// Hàm xử lý yêu cầu tại đường dẫn '/api/v1/check'
Response _checkHandler(Request req) {
  return Response.ok(
    json.encode({'message': 'Chào mừng bạn đến với ứng dụng wqb động'}),
    headers: _headers,
  );
}

Response _echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}

Future<Response> _submitHandler(Request req) async{
  try {
    // Đọc payload từ request
    final payload = await req.readAsString();

    // Giải mã JSON từ payload
    final data = json.decode(payload);

    // Lấy giá trị 'name' từ data, ép kiểu về String? nếu có
    final name = data['name'] as String?;

    //Kiểm tra nếu 'name' hợp lệ
    if(name!=null && name.isNotEmpty){
      // Tạo phản hồi chào mừng
      final response = {'message': 'Chào mừng $name'}; 

      // Trả về phản hồi với StatusCode 200 và nội dung JSON
      return Response.ok(
        json.encode(response),
        headers: _headers,
      );
    } else {
      // Tạo phản hồi cung cấp tên
       final response = {'message': 'Server không nhận được tên của bạn.'}; 

      // Trả về phản hồi với StatusCode 400 và nội dung JSON
      return Response.badRequest(
        body: json.encode(response),
        headers: _headers,
      );
    }
  } catch (e) {
    // Xử lý ngoại lệ khi giải mã JSON
    final response = {'message': 'Yêu cầu không hợp lệ. Lỗi ${e.toString()}'};

    // Trả về phản hồi với statusCode 400
    return Response.badRequest(
      body: json.encode(response),
      headers: _headers,
    );

    }
  }


void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler =
      Pipeline().addMiddleware(logRequests()).addHandler(_router.call);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}

```
2. Debug backend và kiểm thử Postman
### Bước 7: Phát triển frontend và tích hợp hệ thống
