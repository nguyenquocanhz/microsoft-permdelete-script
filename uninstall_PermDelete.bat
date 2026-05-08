@echo off
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Chay lai voi quyen Administrator
    pause & exit /b 1
)

echo [..] Dang go bo PermDelete...

reg delete "HKEY_CLASSES_ROOT\*\shell\PermanentDelete"              /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\shell\PermanentDelete"      /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\PermanentDelete" /f >nul 2>&1

del /f /q "C:\Windows\System32\PermDelete.exe" >nul 2>&1

echo [OK] Da go bo hoan toan.
pause
