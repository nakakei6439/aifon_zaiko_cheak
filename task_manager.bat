@echo off
echo ========================================
echo iPhone 16 Pro Max 512GB - ブラックチタニウム在庫チェッカー
echo タスク管理ツール
echo ========================================
echo.

:menu
echo 選択してください:
echo 1. タスクの状態確認
echo 2. タスクの実行（手動）
echo 3. タスクの一時停止
echo 4. タスクの有効化
echo 5. タスクの削除
echo 6. 実行頻度の変更
echo 7. ログファイルを開く
echo 8. 終了
echo.

set /p choice="選択 (1-8): "

if "%choice%"=="1" goto check_status
if "%choice%"=="2" goto run_manual
if "%choice%"=="3" goto disable_task
if "%choice%"=="4" goto enable_task
if "%choice%"=="5" goto delete_task
if "%choice%"=="6" goto change_frequency
if "%choice%"=="7" goto open_log
if "%choice%"=="8" goto exit
goto menu

:check_status
echo.
echo タスクの状態を確認中...
schtasks /query /tn "iPhone16ProMaxChecker"
echo.
pause
goto menu

:run_manual
echo.
echo 手動実行中...
call run_checker.bat
goto menu

:disable_task
echo.
echo タスクを一時停止中...
schtasks /change /tn "iPhone16ProMaxChecker" /disable
echo タスクが一時停止されました。
echo.
pause
goto menu

:enable_task
echo.
echo タスクを有効化中...
schtasks /change /tn "iPhone16ProMaxChecker" /enable
echo タスクが有効化されました。
echo.
pause
goto menu

:delete_task
echo.
echo タスクを削除中...
schtasks /delete /tn "iPhone16ProMaxChecker" /f
echo タスクが削除されました。
echo.
pause
goto menu

:change_frequency
echo.
echo 実行頻度を選択してください:
echo 1. 15分ごと
echo 2. 30分ごと
echo 3. 1時間ごと
echo 4. 2時間ごと
echo 5. 6時間ごと
echo 6. 12時間ごと
echo 7. 1日ごと
echo.

set /p freq_choice="選択 (1-7): "

if "%freq_choice%"=="1" set freq=15
if "%freq_choice%"=="2" set freq=30
if "%freq_choice%"=="3" set freq=60
if "%freq_choice%"=="4" set freq=120
if "%freq_choice%"=="5" set freq=360
if "%freq_choice%"=="6" set freq=720
if "%freq_choice%"=="7" goto daily_task

echo.
echo 既存のタスクを削除中...
schtasks /delete /tn "iPhone16ProMaxChecker" /f >nul 2>&1

echo 新しいタスクを作成中（%freq%分ごと）...
schtasks /create /tn "iPhone16ProMaxChecker" /tr "powershell.exe -ExecutionPolicy Bypass -File \"%CD%\run_checker.ps1\"" /sc minute /mo %freq% /f

if %errorLevel% == 0 (
    echo ✅ 実行頻度が%freq%分ごとに変更されました。
) else (
    echo ❌ 実行頻度の変更に失敗しました。
)
echo.
pause
goto menu

:daily_task
echo.
echo 既存のタスクを削除中...
schtasks /delete /tn "iPhone16ProMaxChecker" /f >nul 2>&1

echo 新しいタスクを作成中（1日ごと）...
schtasks /create /tn "iPhone16ProMaxChecker" /tr "powershell.exe -ExecutionPolicy Bypass -File \"%CD%\run_checker.ps1\"" /sc daily /st 09:00 /f

if %errorLevel% == 0 (
    echo ✅ 実行頻度が1日ごと（9:00）に変更されました。
) else (
    echo ❌ 実行頻度の変更に失敗しました。
)
echo.
pause
goto menu

:open_log
echo.
echo ログファイルを開いています...
if exist "checker_log.txt" (
    notepad checker_log.txt
) else (
    echo ログファイルが見つかりません。
)
echo.
pause
goto menu

:exit
echo.
echo 終了します。
exit /b 0
