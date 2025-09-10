#!/usr/bin/env python3
"""
エラーハンドリング用Pythonモジュール
"""

import sys
import traceback
import logging
from datetime import datetime
import os

def setup_logging():
    """ログ設定を初期化"""
    log_dir = os.path.dirname(os.path.abspath(__file__))
    log_file = os.path.join(log_dir, "python_error_log.txt")
    
    logging.basicConfig(
        level=logging.ERROR,
        format='%(asctime)s [%(levelname)s] %(message)s',
        handlers=[
            logging.FileHandler(log_file, encoding='utf-8'),
            logging.StreamHandler(sys.stderr)
        ]
    )
    return logging.getLogger(__name__)

def log_error(error, context=""):
    """エラーをログに記録"""
    logger = setup_logging()
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    error_msg = f"[{timestamp}] [ERROR] {context}: {str(error)}"
    logger.error(error_msg)
    
    # 詳細なエラー情報も記録
    traceback_msg = f"[{timestamp}] [TRACEBACK] {traceback.format_exc()}"
    logger.error(traceback_msg)
    
    return error_msg

def handle_network_error(func):
    """ネットワークエラーのデコレータ"""
    def wrapper(*args, **kwargs):
        try:
            return func(*args, **kwargs)
        except ConnectionError as e:
            log_error(e, f"ネットワーク接続エラー in {func.__name__}")
            return None
        except TimeoutError as e:
            log_error(e, f"タイムアウトエラー in {func.__name__}")
            return None
        except Exception as e:
            log_error(e, f"予期しないエラー in {func.__name__}")
            return None
    return wrapper

def handle_file_error(func):
    """ファイル操作エラーのデコレータ"""
    def wrapper(*args, **kwargs):
        try:
            return func(*args, **kwargs)
        except FileNotFoundError as e:
            log_error(e, f"ファイルが見つかりません in {func.__name__}")
            return None
        except PermissionError as e:
            log_error(e, f"ファイルアクセス権限エラー in {func.__name__}")
            return None
        except Exception as e:
            log_error(e, f"ファイル操作エラー in {func.__name__}")
            return None
    return wrapper

def safe_execute(func, *args, **kwargs):
    """安全な関数実行"""
    try:
        return func(*args, **kwargs)
    except Exception as e:
        log_error(e, f"関数実行エラー: {func.__name__}")
        return None

def check_environment():
    """環境チェック"""
    logger = setup_logging()
    
    # Python バージョンチェック
    python_version = sys.version_info
    if python_version.major < 3 or (python_version.major == 3 and python_version.minor < 7):
        logger.error(f"Python 3.7以上が必要です。現在のバージョン: {python_version.major}.{python_version.minor}")
        return False
    
    # 必要なモジュールのチェック
    required_modules = ['requests', 'bs4', 'json', 'os', 're']
    missing_modules = []
    
    for module in required_modules:
        try:
            __import__(module)
        except ImportError:
            missing_modules.append(module)
    
    if missing_modules:
        logger.error(f"必要なモジュールが見つかりません: {', '.join(missing_modules)}")
        return False
    
    logger.info("環境チェック完了")
    return True

def create_error_report(error, context=""):
    """エラーレポートを作成"""
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    report = f"""
=== エラーレポート ===
時刻: {timestamp}
コンテキスト: {context}
エラー: {str(error)}
詳細: {traceback.format_exc()}
システム情報:
- Python バージョン: {sys.version}
- プラットフォーム: {sys.platform}
- 作業ディレクトリ: {os.getcwd()}
========================
"""
    
    return report

if __name__ == "__main__":
    # テスト実行
    print("エラーハンドリングモジュールのテスト")
    
    # 環境チェック
    if check_environment():
        print("✅ 環境チェック完了")
    else:
        print("❌ 環境チェック失敗")
    
    # エラーログのテスト
    try:
        raise ValueError("テストエラー")
    except Exception as e:
        log_error(e, "テスト実行")
