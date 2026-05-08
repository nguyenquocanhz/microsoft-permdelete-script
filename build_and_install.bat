@echo off
setlocal EnableDelayedExpansion

:: ============================================================
::  BUILD + INSTALL PermDelete
::  Yeu cau: Run as Administrator
:: ============================================================

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Chay lai voi quyen Administrator
    pause & exit /b 1
)

:: --- Tim csc.exe (.NET Framework co san tren moi Windows) ---
set CSC=
for %%v in (v4.0.30319 v3.5 v2.0.50727) do (
    if exist "C:\Windows\Microsoft.NET\Framework64\%%v\csc.exe" (
        set CSC=C:\Windows\Microsoft.NET\Framework64\%%v\csc.exe
        goto :found
    )
    if exist "C:\Windows\Microsoft.NET\Framework\%%v\csc.exe" (
        set CSC=C:\Windows\Microsoft.NET\Framework\%%v\csc.exe
        goto :found
    )
)

:found
if "%CSC%"=="" (
    echo [!] Khong tim thay csc.exe. Can cai .NET Framework.
    pause & exit /b 1
)
echo [OK] Compiler: %CSC%

:: --- Lay duong dan thu muc bat dang chay ---
set SRC_DIR=%~dp0
set SRC=%SRC_DIR%PermDelete.cs
set OUT=C:\Windows\System32\PermDelete.exe

:: --- Compile ---
echo [..] Dang compile...
"%CSC%" /nologo /target:winexe /out:"%OUT%" /platform:anycpu "%SRC%"

if not exist "%OUT%" (
    echo [!] Compile that bai.
    pause & exit /b 1
)
echo [OK] Da compile: %OUT%

:: --- Import Registry ---
set REG_PATH=%TEMP%\perm_delete.reg

(
echo Windows Registry Editor Version 5.00
echo.
echo ; File ^(*.* ^)
echo [HKEY_CLASSES_ROOT\*\shell\PermanentDelete]
echo @="Xoa vinh vien"
echo "Icon"="shell32.dll,-240"
echo "SeparatorBefore"=""
echo "Position"="Bottom"
echo.
echo [HKEY_CLASSES_ROOT\*\shell\PermanentDelete\command]
echo @="\"C:\\Windows\\System32\\PermDelete.exe\" \"%%1\""
echo.
echo ; Thu muc
echo [HKEY_CLASSES_ROOT\Directory\shell\PermanentDelete]
echo @="Xoa vinh vien"
echo "Icon"="shell32.dll,-240"
echo "SeparatorBefore"=""
echo "Position"="Bottom"
echo.
echo [HKEY_CLASSES_ROOT\Directory\shell\PermanentDelete\command]
echo @="\"C:\\Windows\\System32\\PermDelete.exe\" \"%%1\""
echo.
echo ; Desktop / folder background
echo [HKEY_CLASSES_ROOT\Directory\Background\shell\PermanentDelete]
echo @="Xoa vinh vien"
echo "Icon"="shell32.dll,-240"
echo "Position"="Bottom"
echo.
echo [HKEY_CLASSES_ROOT\Directory\Background\shell\PermanentDelete\command]
echo @="\"C:\\Windows\\System32\\PermDelete.exe\" \"%%V\""
) > "%REG_PATH%"

regedit /s "%REG_PATH%"
del "%REG_PATH%"

echo [OK] Registry da cap nhat.
echo.
echo Hoan tat! Chuot phai vao file/folder se thay "Xoa vinh vien"
echo - Hien hop thoai xac nhan giong Shift+Delete
echo - Khong qua Recycle Bin
echo - Co separator phan cach voi cac muc khac
echo.
pause
