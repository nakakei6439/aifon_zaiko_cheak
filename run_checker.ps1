# iPhone 16 Pro Max 512GB - ブラックチタニウム在庫チェッカー実行スクリプト

# エラー時の動作設定
$ErrorActionPreference = "Continue"

# ログファイルのパス
$logFile = Join-Path $PSScriptRoot "checker_log.txt"

# ログ関数
function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] $Message"
    Write-Host $logMessage
    Add-Content -Path $logFile -Value $logMessage
}

# メイン処理
try {
    Write-Log "=== iPhone 16 Pro Max 512GB - ブラックチタニウム在庫チェッカー開始 ==="
    
    # 現在のディレクトリをスクリプトのディレクトリに変更
    Set-Location $PSScriptRoot
    Write-Log "作業ディレクトリ: $PWD"
    
    # Pythonの存在確認
    try {
        $pythonVersion = python --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Log "Python確認: $pythonVersion"
        }
        else {
            throw "Pythonコマンドの実行に失敗しました"
        }
    }
    catch {
        Write-Log "エラー: Pythonが見つかりません。Pythonをインストールしてください。"
        exit 1
    }
    
    # 必要なライブラリのインストール確認
    Write-Log "依存関係を確認中..."
    try {
        python -c "import requests, bs4" 2>$null
        if ($LASTEXITCODE -ne 0) {
            Write-Log "必要なライブラリをインストール中..."
            pip install -r requirements.txt
        }
        Write-Log "依存関係の確認完了"
    }
    catch {
        Write-Log "エラー: 依存関係のインストールに失敗しました。"
        exit 1
    }
    
    # メインスクリプトの実行
    Write-Log "在庫チェッカーを実行中..."
    python apple_iphone_checker.py
    
    if ($LASTEXITCODE -eq 0) {
        Write-Log "在庫チェッカーの実行が正常に完了しました。"
    }
    else {
        Write-Log "エラー: 在庫チェッカーの実行中にエラーが発生しました。終了コード: $LASTEXITCODE"
    }
}
catch {
    Write-Log "予期しないエラーが発生しました: $($_.Exception.Message)"
    exit 1
}
finally {
    Write-Log "=== iPhone 16 Pro Max 512GB - ブラックチタニウム在庫チェッカー終了 ==="
    Write-Log ""
}
