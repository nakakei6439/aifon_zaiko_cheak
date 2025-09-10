#!/usr/bin/env python3
"""
エラーハンドリングのテストスクリプト
"""

import sys
import os
from error_handler import log_error, check_environment, create_error_report

def test_error_handling():
    """エラーハンドリングのテスト"""
    print("🧪 エラーハンドリングテストを開始...")
    
    # 環境チェックテスト
    print("\n1. 環境チェックテスト")
    if check_environment():
        print("✅ 環境チェック: 成功")
    else:
        print("❌ 環境チェック: 失敗")
    
    # エラーログテスト
    print("\n2. エラーログテスト")
    try:
        raise ValueError("テスト用のエラーです")
    except Exception as e:
        log_error(e, "テスト実行")
        print("✅ エラーログ: 記録完了")
    
    # エラーレポートテスト
    print("\n3. エラーレポートテスト")
    try:
        raise ConnectionError("テスト用の接続エラーです")
    except Exception as e:
        report = create_error_report(e, "テスト実行")
        print("✅ エラーレポート: 生成完了")
        print("📋 レポート内容:")
        print(report[:200] + "..." if len(report) > 200 else report)
    
    # ファイル存在チェックテスト
    print("\n4. ファイル存在チェックテスト")
    test_files = ["apple_iphone_checker.py", "requirements.txt", "error_handler.py"]
    for file in test_files:
        if os.path.exists(file):
            print(f"✅ {file}: 存在")
        else:
            print(f"❌ {file}: 不存在")
    
    print("\n🎉 エラーハンドリングテスト完了")

if __name__ == "__main__":
    test_error_handling()
