# PermDelete — Xóa Vĩnh Viễn cho Windows

> Thêm **"Xóa vĩnh viễn"** vào menu chuột phải — xài đúng Windows Shell API, không flash cửa sổ, không qua Recycle Bin.

![License](https://img.shields.io/badge/license-MIT-blue)
![Platform](https://img.shields.io/badge/platform-Windows%2010%2F11-0078d4)
![.NET](https://img.shields.io/badge/.NET%20Framework-4.0+-purple)

---

## Tại sao cần tool này?

Nút **Delete** mặc định trong Windows chỉ chuyển file vào Recycle Bin.  
Muốn xóa thẳng phải nhấn **Shift + Delete** — nhưng nếu phím Delete bị liệt thì không làm được.

Tool này thêm option **"Xóa vĩnh viễn"** vào context menu, hoạt động y hệt Shift+Delete.

---

## Tính năng

- Dùng `SHFileOperation` — Windows Shell API chính thống, không phải workaround
- Hiện hộp thoại xác nhận trước khi xóa (giống Shift+Delete)
- Không qua Recycle Bin (`FOF_ALLOWUNDO` không được set)
- Không flash cửa sổ cmd hay PowerShell
- Hỗ trợ cả file lẫn folder
- Tự compile bằng `csc.exe` có sẵn trên Windows, không cần cài thêm gì

---

## Cài đặt

**Yêu cầu:** Windows 10/11 · .NET Framework 4.0+ (mặc định có sẵn)

1. Clone hoặc download repo
2. Chuột phải `build_and_install.bat` → **Run as administrator**
3. Xong — chuột phải vào bất kỳ file/folder nào sẽ thấy **"Xóa vĩnh viễn"**

```
build_and_install.bat sẽ tự động:
  ✓ Tìm csc.exe trong .NET Framework
  ✓ Compile PermDelete.cs → C:\Windows\System32\PermDelete.exe
  ✓ Import registry key cho File, Folder, Folder Background
```

---

## Gỡ cài đặt

Chuột phải `uninstall_PermDelete.bat` → **Run as administrator**

Sẽ xóa toàn bộ registry key và `PermDelete.exe` khỏi System32.

---

## Cấu trúc repo

```
perm-delete/
├── PermDelete.cs            # Source C# — gọi SHFileOperation
├── build_and_install.bat    # Build + import registry
├── uninstall_PermDelete.bat # Gỡ bỏ hoàn toàn
├── index.html               # Trang giới thiệu
└── LICENSE
```

---

## Chi tiết kỹ thuật

```csharp
// Flags sử dụng
FOF_NOERRORUI      = 0x0400  // Không popup lỗi
FOF_WANTNUKEWARNING = 0x4000 // Hiện cảnh báo "permanently delete"

// Flags KHÔNG dùng (quan trọng)
FOF_ALLOWUNDO      = 0x0040  // Nếu có → vào Recycle Bin
FOF_NOCONFIRMATION = 0x0010  // Nếu có → xóa không hỏi
```

Registry key được đăng ký tại:
- `HKEY_CLASSES_ROOT\*\shell\PermanentDelete` — cho mọi file
- `HKEY_CLASSES_ROOT\Directory\shell\PermanentDelete` — cho folder
- `HKEY_CLASSES_ROOT\Directory\Background\shell\PermanentDelete` — cho background folder

---

## License

MIT © [Nguyễn Quốc Anh](https://nguyenquocanh.io.vn)
