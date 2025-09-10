@echo off
echo ========================================
echo iPhone 16 Pro Max 512GB - ブラックチタニウム在庫チェッカー
echo 手動実行
echo ========================================
echo.

echo 在庫チェッカーを実行中...
echo ログファイル: checker_log.txt
echo.

REM PowerShellスクリプトを実行
powershell.exe -ExecutionPolicy Bypass -File "run_checker.ps1"

echo.
echo 実行完了。Enterキーを押して終了してください。
pause >nul
