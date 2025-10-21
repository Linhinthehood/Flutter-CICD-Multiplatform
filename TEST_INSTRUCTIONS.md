# Hướng Dẫn Chạy Tests - Test Instructions

## Tổng Quan / Overview

Dự án này bao gồm 3 loại test theo yêu cầu:
This project includes 3 types of tests as requested:

1. **Unit Tests** - Test API service với mocked HTTP client
2. **Widget Tests** - Test giao diện với mock data
3. **Integration Tests** - Test toàn bộ flow người dùng

---

## 1. Unit Test - Test API Service

### Mục đích / Purpose
- Test `TodoApiService` với JSONPlaceholder API
- Sử dụng Mockito để mock `http.Client`
- Kiểm tra xử lý dữ liệu trả về từ API giả lập

### Chạy test / Run tests
```bash
flutter test test/unit/todo_api_service_test.dart
```

### Kết quả mong đợi / Expected result
```
00:00 +5: All tests passed!
```

### Các test case
- ✅ Lấy danh sách todos thành công
- ✅ Xử lý lỗi khi API trả về 404
- ✅ Xử lý lỗi khi JSON không hợp lệ
- ✅ Tạo todo mới thành công
- ✅ Xử lý lỗi khi tạo todo thất bại

---

## 2. Widget Test - Test Giao Diện

### Mục đích / Purpose
- Test màn hình danh sách To-do
- Kiểm tra ListView hiển thị đúng số lượng items
- Test các hành động như nhấn nút "Thêm mới"

### Chạy test / Run tests
```bash
flutter test test/widget/todo_list_page_test.dart
```

### Kết quả mong đợi / Expected result
```
00:02 +10: All tests passed!
```

### Các test case
- ✅ Hiển thị loading indicator khi đang tải
- ✅ Hiển thị empty state khi không có todo
- ✅ Hiển thị đúng số lượng todos trong ListView (3 items)
- ✅ Hiển thị thông báo lỗi khi API thất bại
- ✅ Mở dialog khi nhấn nút thêm mới
- ✅ Thêm todo mới qua dialog
- ✅ Toggle trạng thái hoàn thành của todo
- ✅ Xóa todo
- ✅ Retry khi có lỗi
- ✅ Validate input rỗng

---

## 3. Integration Test - Test Toàn Bộ Flow

### Mục đích / Purpose
- Test kịch bản hoàn chỉnh: Mở app → Nhấn nút thêm → Nhập text → Lưu → Kiểm tra item mới
- Test các flow phức tạp với nhiều bước

### Chạy test / Run tests

**Lưu ý:** Integration tests cần device hoặc emulator để chạy
**Note:** Integration tests require a device or emulator to run

```bash
# Chạy trên Windows
flutter test integration_test/app_test.dart -d windows

# Chạy trên Chrome
flutter test integration_test/app_test.dart -d chrome

# Hoặc chọn device
flutter test integration_test/app_test.dart
```

### Các test case
- ✅ **Flow hoàn chỉnh:** Mở app → Thêm todo → Xem trong danh sách
- ✅ **Flow tương tác:** Load todos → Toggle completion → Delete todo
- ✅ **Flow xử lý lỗi:** API error → Retry → Success
- ✅ **Flow nhiều todos:** Thêm nhiều todo → Kiểm tra tất cả
- ✅ **Flow cancel:** Mở dialog → Cancel → Không có thay đổi
- ✅ **Flow validation:** Mở dialog → Submit rỗng → Hiển thị lỗi

---

## Chạy Tất Cả Tests / Run All Tests

### Chạy tất cả unit + widget tests
```bash
flutter test
```

### Kết quả mong đợi
```
00:04 +18: All tests passed!
```

### Chi tiết
- 5 unit tests ✓
- 10 widget tests ✓
- 3 existing tests ✓

---

## Tạo Lại Mock Files / Regenerate Mocks

Nếu bạn thay đổi code và cần tạo lại mock files:
If you change the code and need to regenerate mocks:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Cấu Trúc Project / Project Structure

```
test/
├── unit/
│   ├── todo_api_service_test.dart      # Unit tests cho API service
│   └── todo_api_service_test.mocks.dart # Auto-generated mocks
├── widget/
│   ├── todo_list_page_test.dart        # Widget tests cho UI
│   └── todo_list_page_test.mocks.dart  # Auto-generated mocks
└── widget_test.dart                     # Existing tests

integration_test/
└── app_test.dart                        # Integration tests
    └── app_test.mocks.dart              # Auto-generated mocks

lib/
├── data/
│   ├── models/
│   │   └── todo_model.dart              # Model cho Todo
│   └── services/
│       └── todo_api_service.dart        # Service gọi API
└── presentation/
    ├── pages/
    │   └── todo_list_page.dart          # Màn hình danh sách
    ├── providers/
    │   └── todo_provider.dart           # Provider quản lý state
    └── widgets/
        ├── add_todo_dialog.dart         # Dialog thêm todo
        └── todo_item_widget.dart        # Widget item todo
```

---

## Dependencies

Các package cần thiết đã được thêm vào `pubspec.yaml`:
Required packages are already in `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  mockito: ^5.4.4
  build_runner: ^2.4.9
```

---

## Troubleshooting

### Lỗi: Mock files không tìm thấy
**Error:** Mock files not found

**Giải pháp / Solution:**
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Lỗi: Integration tests không chạy được
**Error:** Integration tests won't run

**Nguyên nhân / Cause:** Cần device hoặc emulator

**Giải pháp / Solution:**
1. Cài đặt Chrome browser để test trên web
2. Hoặc cài đặt Windows desktop development cho Flutter
3. Hoặc sử dụng Android/iOS emulator

```bash
# Kiểm tra devices có sẵn
flutter devices

# Chạy trên Chrome
flutter test integration_test/app_test.dart -d chrome
```

---

## Test Coverage

Để xem test coverage:
To view test coverage:

```bash
flutter test --coverage
```

---

## CI/CD Integration

Tests đã được tích hợp vào CI/CD pipeline trong `.github/workflows/ci-cd.yml`
Tests are integrated into the CI/CD pipeline in `.github/workflows/ci-cd.yml`

```yaml
- name: Run tests
  run: flutter test
```

---

## Kết Luận / Conclusion

✅ **Unit Tests:** Test API service với mock HTTP client - 5 tests pass
✅ **Widget Tests:** Test UI với mock data - 10 tests pass  
✅ **Integration Tests:** Test toàn bộ user flow - 6 tests pass

**Tổng cộng / Total:** 21 tests covering API, UI, and user flows

Tất cả tests đều sử dụng mock data, không gọi API thật, đảm bảo tests chạy nhanh và ổn định.
All tests use mocked data, don't call real APIs, ensuring fast and stable test execution.

