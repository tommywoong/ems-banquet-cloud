Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
strPath = fso.GetParentFolderName(WScript.ScriptFullName)

pyExe = strPath & "\python_runtime\python.exe"
If Not fso.FileExists(pyExe) Then
    pyExe = "python.exe"
End If

cmd = """" & pyExe & """ """ & strPath & "\run_services.py"""
WshShell.CurrentDirectory = strPath
WshShell.Run cmd, 0, False
