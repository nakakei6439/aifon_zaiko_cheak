# iPhone 16 Pro Max 512GB - ブラックチタニウム在庫チェッカー - タスクスケジューラー用PowerShellスクリプト

# エラー時の動作設定
$ErrorActionPreference = "Continue"
$VerbosePreference = "Continue"

# スクリプトの実行ポリシーを設定
try {
    Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force -ErrorAction Stop
}
catch {
    Write-Warning "実行ポリシーの設定に失敗しました: $($_.Exception.Message)"
}

# ログファイルのパス
$logFile = Join-Path $PSScriptRoot "checker_log.txt"
$errorLogFile = Join-Path $PSScriptRoot "error_log.txt"

# ログ関数
function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"
    
    # コンソールに出力（レベルに応じて色分け）
    switch ($Level) {
        "ERROR" { Write-Host $logMessage -ForegroundColor Red }
        "WARNING" { Write-Host $logMessage -ForegroundColor Yellow }
        "SUCCESS" { Write-Host $logMessage -ForegroundColor Green }
        default { Write-Host $logMessage }
    }
    
    # ログファイルに書き込み
    try {
        Add-Content -Path $logFile -Value $logMessage -ErrorAction Stop
    }
    catch {
        Write-Warning "ログファイルへの書き込みに失敗しました: $($_.Exception.Message)"
    }
}

# エラーログ関数
function Write-ErrorLog {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $errorMessage = "[$timestamp] [ERROR] $Message"
    Write-Host $errorMessage -ForegroundColor Red
    
    try {
        Add-Content -Path $errorLogFile -Value $errorMessage -ErrorAction Stop
    }
    catch {
        Write-Warning "エラーログファイルへの書き込みに失敗しました: $($_.Exception.Message)"
    }
}

# システム情報の取得
function Get-SystemInfo {
    try {
        $os = Get-WmiObject -Class Win32_OperatingSystem -ErrorAction Stop
        $computer = Get-WmiObject -Class Win32_ComputerSystem -ErrorAction Stop
        return @{
            OS = $os.Caption
            Version = $os.Version
            ComputerName = $computer.Name
            UserName = $env:USERNAME
        }
    }
    catch {
        Write-ErrorLog "システム情報の取得に失敗しました: $($_.Exception.Message)"
        return $null
    }
}

# メイン処理
try {
    Write-Log "=== iPhone 16 Pro Max 512GB - ブラックチタニウム在庫チェッカー開始 ==="
    
    # システム情報をログに記録
    $systemInfo = Get-SystemInfo
    if ($systemInfo) {
        Write-Log "システム情報: $($systemInfo.OS) $($systemInfo.Version) on $($systemInfo.ComputerName) by $($systemInfo.UserName)"
    }
    
    # 現在のディレクトリをスクリプトのディレクトリに変更
    try {
        Set-Location $PSScriptRoot -ErrorAction Stop
        Write-Log "作業ディレクトリ: $PWD" "SUCCESS"
    }
    catch {
        Write-ErrorLog "作業ディレクトリの変更に失敗しました: $($_.Exception.Message)"
        throw
    }
    
    # 必要なファイルの存在確認
    $requiredFiles = @("apple_iphone_checker.py", "requirements.txt")
    foreach ($file in $requiredFiles) {
        if (-not (Test-Path $file)) {
            Write-ErrorLog "必要なファイルが見つかりません: $file"
            throw "必要なファイルが見つかりません: $file"
        }
    }
    Write-Log "必要なファイルの確認完了" "SUCCESS"
    
    # Pythonの存在確認
    Write-Log "Python環境を確認中..."
    try {
        $pythonVersion = python --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Log "Python確認: $pythonVersion" "SUCCESS"
        }
        else {
            throw "Pythonコマンドの実行に失敗しました"
        }
    }
    catch {
        Write-ErrorLog "Pythonが見つかりません。Pythonをインストールしてください。"
        Write-ErrorLog "エラー詳細: $($_.Exception.Message)"
        throw
    }
    
    # pipの存在確認
    try {
        $pipVersion = pip --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Log "pip確認: $pipVersion" "SUCCESS"
        }
        else {
            throw "pipコマンドの実行に失敗しました"
        }
    }
    catch {
        Write-ErrorLog "pipが見つかりません。Pythonとpipをインストールしてください。"
        Write-ErrorLog "エラー詳細: $($_.Exception.Message)"
        throw
    }
    
    # 必要なライブラリのインストール確認
    Write-Log "依存関係を確認中..."
    try {
        $importTest = python -c "import requests, bs4; print('OK')" 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Log "依存関係の確認完了" "SUCCESS"
        }
        else {
            Write-Log "必要なライブラリをインストール中..." "WARNING"
            $installResult = pip install -r requirements.txt 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Log "依存関係のインストール完了" "SUCCESS"
            }
            else {
                Write-ErrorLog "依存関係のインストールに失敗しました"
                Write-ErrorLog "インストール出力: $installResult"
                throw "依存関係のインストールに失敗しました"
            }
        }
    }
    catch {
        Write-ErrorLog "依存関係の確認/インストールに失敗しました: $($_.Exception.Message)"
        throw
    }
    
    # メインスクリプトの実行
    Write-Log "在庫チェッカーを実行中..."
    $pythonOutput = python apple_iphone_checker.py 2>&1
    $exitCode = $LASTEXITCODE
    
    if ($exitCode -eq 0) {
        Write-Log "在庫チェッカーの実行が正常に完了しました。" "SUCCESS"
        if ($pythonOutput) {
            Write-Log "Python出力: $pythonOutput"
        }
    }
    else {
        Write-ErrorLog "在庫チェッカーの実行中にエラーが発生しました。終了コード: $exitCode"
        if ($pythonOutput) {
            Write-ErrorLog "Python出力: $pythonOutput"
        }
        throw "Pythonスクリプトの実行に失敗しました"
    }
}
catch {
    Write-ErrorLog "予期しないエラーが発生しました: $($_.Exception.Message)"
    Write-ErrorLog "エラーの詳細: $($_.Exception.ToString())"
    
    # エラー通知（Discordに送信する場合）
    try {
        Write-Log "エラー通知を送信中..."
        # ここでDiscordにエラー通知を送信することも可能
    }
    catch {
        Write-ErrorLog "エラー通知の送信に失敗しました: $($_.Exception.Message)"
    }
    
    exit 1
}
finally {
    Write-Log "=== iPhone 16 Pro Max 512GB - ブラックチタニウム在庫チェッカー終了 ==="
    Write-Log "ログファイル: $logFile"
    Write-Log "エラーログファイル: $errorLogFile"
    Write-Log ""
}
