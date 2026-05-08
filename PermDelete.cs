using System;
using System.Runtime.InteropServices;

/// <summary>
/// PermDelete.exe - Xoa vinh vien qua Windows Shell API
/// Giong het Shift+Delete: hien hop thoai xac nhan, khong qua Recycle Bin
/// Usage: PermDelete.exe "C:\path\to\file or folder"
/// </summary>
class PermDelete
{
    [DllImport("shell32.dll", CharSet = CharSet.Unicode)]
    static extern int SHFileOperation(ref SHFILEOPSTRUCT lpFileOp);

    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
    struct SHFILEOPSTRUCT
    {
        public IntPtr  hwnd;
        public uint    wFunc;
        [MarshalAs(UnmanagedType.LPWStr)]
        public string  pFrom;
        [MarshalAs(UnmanagedType.LPWStr)]
        public string  pTo;
        public ushort  fFlags;
        public bool    fAnyOperationsAborted;
        public IntPtr  hNameMappings;
        [MarshalAs(UnmanagedType.LPWStr)]
        public string  lpszProgressTitle;
    }

    const uint   FO_DELETE       = 0x0003;
    // Flags KHONG dung:
    //   FOF_ALLOWUNDO    = 0x0040  -> neu co flag nay se vao Recycle Bin
    //   FOF_NOCONFIRMATION = 0x0010 -> neu co flag nay se xoa im lang ko hoi
    // Flag dung:
    const ushort FOF_NOERRORUI   = 0x0400; // khong popup loi khi fail
    const ushort FOF_WANTNUKEWARNING = 0x4000; // hien canh bao "xoa vinh vien" ro rang

    static void Main(string[] args)
    {
        if (args.Length == 0) return;

        string path = args[0].TrimEnd('\\');

        // pFrom phai ket thuc bang double null
        string pFrom = path + "\0\0";

        var op = new SHFILEOPSTRUCT
        {
            hwnd               = IntPtr.Zero,
            wFunc              = FO_DELETE,
            pFrom              = pFrom,
            pTo                = null,
            fFlags             = (ushort)(FOF_NOERRORUI | FOF_WANTNUKEWARNING),
            lpszProgressTitle  = "Xoa vinh vien"
        };

        SHFileOperation(ref op);
    }
}
