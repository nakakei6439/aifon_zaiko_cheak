# iPhone 16 Pro Max 512GB - ブラックチタニウム在庫チェッカー実行スクリプト

# エラー時の動作設定
$ErrorActionPreference = "Stop"

# ログファイルのパス
$logFile = Join-Path $PSScriptRoot "checker_log.txt"

# ログ関数
function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] $Message"
    Write-Host $logMessage
    try {
        Add-Content -Path $logFile -Value $logMessage -ErrorAction SilentlyContinue
    }
    catch {
        # ログファイル書き込みに失敗した場合は無視
    }
}

try {
    Write-Log "=== iPhone 16 Pro Max 512GB - ブラックチタニウム在庫チェッカー開始 ==="

    # 作業ディレクトリをスクリプトの場所へ
    Set-Location -Path $PSScriptRoot
    Write-Log "作業ディレクトリ: $PWD"

    # Python の存在確認
    Write-Log "Python確認中..."
    try {
        # py コマンドを試す（Windows Python Launcher）
        $pythonVersion = & py --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Log "Python確認: $pythonVersion (py コマンド)"
            $pythonCmd = "py"
        } else {
            # python コマンドを試す
            $pythonVersion = & python --version 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Log "Python確認: $pythonVersion (python コマンド)"
                $pythonCmd = "python"
            } else {
                throw "Pythonが見つかりません。Pythonをインストールしてください。"
            }
        }
    }
    catch {
        Write-Log "Python確認エラー: $($_.Exception.Message)"
        throw "Pythonが見つかりません。Pythonをインストールしてください。"
    }

    # 依存関係の確認
    Write-Log "依存関係を確認中..."
    try {
        & $pythonCmd -c "import requests, bs4; print('OK')" 2>&1 | Out-Null
        if ($LASTEXITCODE -ne 0) {
            Write-Log "必要なライブラリをインストール中..."
            & $pythonCmd -m pip install -r requirements.txt
            if ($LASTEXITCODE -ne 0) {
                throw "依存関係のインストールに失敗しました。"
            }
            Write-Log "依存関係のインストール完了"
        } else {
            Write-Log "依存関係の確認完了"
        }
    }
    catch {
        Write-Log "依存関係確認エラー: $($_.Exception.Message)"
        throw "依存関係の確認に失敗しました。"
    }

    # メインスクリプトの実行
    Write-Log "在庫チェッカーを実行中..."
    try {
        & $pythonCmd "apple_iphone_checker.py"
        if ($LASTEXITCODE -ne 0) {
            throw "在庫チェッカー実行中にエラーが発生しました。終了コード: $LASTEXITCODE"
        }
        Write-Log "在庫チェッカーの実行が正常に完了しました。"
    }
    catch {
        Write-Log "メインスクリプト実行エラー: $($_.Exception.Message)"
        throw "在庫チェッカーの実行に失敗しました。"
    }
}
catch {
    Write-Log "エラーが発生しました: $($_.Exception.Message)"
    Write-Log "エラーの詳細: $($_.Exception.ToString())"
    exit 1
}
finally {
    Write-Log "=== iPhone 16 Pro Max 512GB - ブラックチタニウム在庫チェッカー終了 ==="
    Write-Log ""
}