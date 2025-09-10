#!/usr/bin/env python3
"""
Discord通知付きiPhoneチェッカー実行スクリプト
"""

import os
import sys
from apple_iphone_checker import check_iphone_16_pro_max_black_titanium

def main():
    print("🔍 Apple整備済みiPhoneサイトでiPhone 16 Pro Max 512GB - ブラックチタニウムを検索中...")
    print("📱 検索結果はDiscordに通知されます\n")
    
    # Discord Webhook URLの確認
    webhook_url = "https://discord.com/api/webhooks/1415299648041779353/oht5AUpV0hHq1H8cIKBnouTpblq2T1NdAihNnQH1soVQMXTpXnMJi1s7em-25LT7OGLU"
    if not webhook_url:
        print("⚠️  警告: DISCORD_WEBHOOK_URL環境変数が設定されていません")
        print("📝 config_example.txtを参照してDiscord Webhook URLを設定してください")
        print("🔧 設定例: $env:DISCORD_WEBHOOK_URL=\"your_webhook_url_here\"")
        print()
    
        # iPhone検索を実行
        try:
            results, models = check_iphone_16_pro_max_black_titanium()
        
        print("\n" + "="*50)
        print("📊 検索結果サマリー")
        print("="*50)
        
        if results:
            print(f"✅ iPhone 16 Pro Max 512GB - ブラックチタニウム関連キーワード: {len(results)}個発見")
            for keyword in results:
                print(f"   • {keyword}")
        else:
            print("❌ iPhone 16 Pro Max 512GB - ブラックチタニウム関連キーワード: 見つかりませんでした")
        
        if models:
            unique_models = list(set(models))
            print(f"📱 利用可能なiPhone Pro Maxモデル: {len(unique_models)}種類")
            for model in unique_models:
                print(f"   • {model}")
        else:
            print("📱 利用可能なiPhone Pro Maxモデル: 見つかりませんでした")
        
        if webhook_url:
            print("📨 Discord通知: 送信済み")
        else:
            print("📨 Discord通知: 未送信（Webhook URL未設定）")
            
    except Exception as e:
        print(f"❌ エラーが発生しました: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
