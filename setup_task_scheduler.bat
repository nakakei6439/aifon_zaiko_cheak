@echo off
echo ========================================
echo iPhone 16 Pro Max 512GB - ブラックチタニウム在庫チェッカー
echo タスクスケジューラー設定
echo ========================================
echo.

REM 管理者権限の確認
net session >nul 2>&1
if %errorLevel% == 0 (
    echo 管理者権限で実行中...
) else (
    echo エラー: 管理者権限で実行してください。
    echo このファイルを右クリックして「管理者として実行」を選択してください。
    pause
    exit /b 1
)

echo.
echo 現在のディレクトリ: %CD%
echo.

REM 既存のタスクを削除（存在する場合）
echo 既存のタスクを削除中...
schtasks /delete /tn "iPhone16ProMaxChecker" /f >nul 2>&1

REM 新しいタスクを作成（30分ごとに実行）
echo 新しいタスクを作成中...
schtasks /create /tn "iPhone16ProMaxChecker" /tr "powershell.exe -ExecutionPolicy Bypass -File \"%CD%\run_checker.ps1\"" /sc minute /mo 30 /f

if %errorLevel% == 0 (
    echo.
    echo ✅ タスクスケジューラーの設定が完了しました！
    echo.
    echo 設定内容:
    echo - タスク名: iPhone16ProMaxChecker
    echo - 実行頻度: 30分ごと
    echo - 実行ファイル: %CD%\run_checker.ps1
    echo.
    echo タスクの確認:
    schtasks /query /tn "iPhone16ProMaxChecker"
    echo.
    echo ログファイル: %CD%\checker_log.txt
) else (
    echo.
    echo ❌ タスクスケジューラーの設定に失敗しました。
    echo エラーコード: %errorLevel%
)

echo.
echo 設定完了。Enterキーを押して終了してください。
pause >nul
