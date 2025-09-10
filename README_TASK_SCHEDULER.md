# iPhone 16 Pro Max 512GB - ブラックチタニウム在庫チェッカー - タスクスケジューラー設定

## 作成されたファイル

1. **`run_checker.ps1`** - メインのPowerShellスクリプト
2. **`setup_task_scheduler.bat`** - タスクスケジューラー設定用バッチファイル
3. **`run_checker.bat`** - 手動実行用バッチファイル
4. **`task_manager.bat`** - タスク管理ツール

## 使用方法

### 1. 手動実行
```
run_checker.bat
```
をダブルクリックして実行

### 2. タスクスケジューラー設定
```
setup_task_scheduler.bat
```
を**管理者として実行**してタスクスケジューラーに登録

### 3. タスク管理
```
task_manager.bat
```
をダブルクリックしてタスクの管理

### 4. ログファイル
実行結果は `checker_log.txt` に記録されます

## 実行頻度オプション

- **1分ごと** - 最高頻度監視（リアルタイム）
- **15分ごと** - 高頻度監視
- **30分ごと** - 標準監視（デフォルト）
- **1時間ごと** - 通常監視
- **2時間ごと** - 低頻度監視
- **6時間ごと** - 定期監視
- **12時間ごと** - 日2回監視
- **1日ごと** - 日次監視
- **週次** - 週次監視

## タスクスケジューラーの詳細設定

### 実行頻度の変更

**1分ごとに実行:**
```cmd
schtasks /create /tn "iPhone16ProMaxChecker" /tr "powershell.exe -ExecutionPolicy Bypass -File \"%CD%\run_checker.ps1\"" /sc minute /mo 1 /f
```

**15分ごとに実行:**
```cmd
schtasks /create /tn "iPhone16ProMaxChecker" /tr "powershell.exe -ExecutionPolicy Bypass -File \"%CD%\run_checker.ps1\"" /sc minute /mo 15 /f
```

**30分ごとに実行:**
```cmd
schtasks /create /tn "iPhone16ProMaxChecker" /tr "powershell.exe -ExecutionPolicy Bypass -File \"%CD%\run_checker.ps1\"" /sc minute /mo 30 /f
```

**1時間ごとに実行:**
```cmd
schtasks /create /tn "iPhone16ProMaxChecker" /tr "powershell.exe -ExecutionPolicy Bypass -File \"%CD%\run_checker.ps1\"" /sc minute /mo 60 /f
```

**2時間ごとに実行:**
```cmd
schtasks /create /tn "iPhone16ProMaxChecker" /tr "powershell.exe -ExecutionPolicy Bypass -File \"%CD%\run_checker.ps1\"" /sc minute /mo 120 /f
```

**6時間ごとに実行:**
```cmd
schtasks /create /tn "iPhone16ProMaxChecker" /tr "powershell.exe -ExecutionPolicy Bypass -File \"%CD%\run_checker.ps1\"" /sc minute /mo 360 /f
```

**12時間ごとに実行:**
```cmd
schtasks /create /tn "iPhone16ProMaxChecker" /tr "powershell.exe -ExecutionPolicy Bypass -File \"%CD%\run_checker.ps1\"" /sc minute /mo 720 /f
```

**特定の時間に実行（例：10:00）:**
```cmd
schtasks /create /tn "iPhone16ProMaxChecker" /tr "powershell.exe -ExecutionPolicy Bypass -File \"%CD%\run_checker.ps1\"" /sc daily /st 10:00 /f
```

**毎週月曜日の9:00に実行:**
```cmd
schtasks /create /tn "iPhone16ProMaxChecker" /tr "powershell.exe -ExecutionPolicy Bypass -File \"%CD%\run_checker.ps1\"" /sc weekly /d MON /st 09:00 /f
```

### タスクの管理

**タスクの状態確認:**
```cmd
schtasks /query /tn "iPhone16ProMaxChecker"
```

**タスクの削除:**
```cmd
schtasks /delete /tn "iPhone16ProMaxChecker" /f
```

**タスクの一時停止:**
```cmd
schtasks /change /tn "iPhone16ProMaxChecker" /disable
```

**タスクの有効化:**
```cmd
schtasks /change /tn "iPhone16ProMaxChecker" /enable
```

## 注意事項

1. **Python環境**: Pythonがインストールされている必要があります
2. **依存関係**: 初回実行時に必要なライブラリが自動インストールされます
3. **ログファイル**: 実行結果は `checker_log.txt` に記録されます
4. **Discord通知**: 設定されたWebhook URLに結果が送信されます
5. **管理者権限**: タスクスケジューラーの設定には管理者権限が必要です

## トラブルシューティング

### エラーが発生した場合

1. **ログファイルを確認**: `checker_log.txt` を確認
2. **Python環境の確認**: `python --version` でPythonが利用可能か確認
3. **依存関係の確認**: `pip list` で必要なライブラリがインストールされているか確認
4. **管理者権限の確認**: タスクスケジューラーの設定時に管理者権限で実行しているか確認

### よくある問題

- **PowerShell実行ポリシーエラー**: スクリプト内で自動設定されます
- **Pythonパスエラー**: システム環境変数にPythonが設定されているか確認
- **権限エラー**: 管理者権限で実行を試してください
- **タスクが実行されない**: タスクスケジューラーでタスクの状態を確認してください

## 簡単な設定方法

### 1分ごとに実行する場合：
```cmd
schtasks /delete /tn "iPhone16ProMaxChecker" /f
schtasks /create /tn "iPhone16ProMaxChecker" /tr "powershell.exe -ExecutionPolicy Bypass -File \"%CD%\run_checker.ps1\"" /sc minute /mo 1 /f
```

### 1時間ごとに実行する場合：
```cmd
schtasks /delete /tn "iPhone16ProMaxChecker" /f
schtasks /create /tn "iPhone16ProMaxChecker" /tr "powershell.exe -ExecutionPolicy Bypass -File \"%CD%\run_checker.ps1\"" /sc minute /mo 60 /f
```

### 30分ごとに実行する場合：
```cmd
schtasks /delete /tn "iPhone16ProMaxChecker" /f
schtasks /create /tn "iPhone16ProMaxChecker" /tr "powershell.exe -ExecutionPolicy Bypass -File \"%CD%\run_checker.ps1\"" /sc minute /mo 30 /f
```

## 機能

- ✅ 自動実行（タスクスケジューラー）
- ✅ 手動実行
- ✅ ログ記録
- ✅ エラーハンドリング
- ✅ 依存関係の自動インストール
- ✅ Discord通知
- ✅ タスク管理ツール

## ライセンス

MIT License
