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
