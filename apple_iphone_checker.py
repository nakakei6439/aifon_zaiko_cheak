import requests
from bs4 import BeautifulSoup
import re
import json
import os
from datetime import datetime

def send_discord_notification(webhook_url, message):
    """
    Discordに通知を送信
    """
    try:
        data = {
            "content": message,
            "username": "iPhone Checker Bot"
        }
        
        response = requests.post(webhook_url, json=data)
        response.raise_for_status()
        print("Discord通知を送信しました")
        return True
    except Exception as e:
        print(f"Discord通知の送信に失敗しました: {e}")
        return False

def check_iphone_16_pro_max_black_titanium():
    """
    Apple整備済みiPhoneサイトからiPhone 16 Pro Max 512GB - ブラックチタニウムのキーワードを検索
    """
    url = "https://www.apple.com/jp/shop/refurbished/iphone"
    
    try:
        # ヘッダーを設定してリクエストを送信
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
        }
        
        print(f"サイトにアクセス中: {url}")
        response = requests.get(url, headers=headers, timeout=10)
        response.raise_for_status()
        
        # HTMLをパース
        soup = BeautifulSoup(response.content, 'html.parser')
        
        # ページのテキスト全体を取得
        page_text = soup.get_text()
        
        # iPhone 16 Pro Max 512GB - ブラックチタニウムのキーワードを検索
        keywords = [
            "iPhone 16 Pro Max 512GB - ブラックチタニウム",
            "iPhone 16 Pro Max 256GB - ブラックチタニウム",
            "iPhone 16 Pro Max 512GB",
            "iPhone 16 Pro Max 256GB",
            "iPhone 16 Pro Max"
        ]
        
        print("\n=== 検索結果 ===")
        found_keywords = []
        
        for keyword in keywords:
            if keyword in page_text:
                found_keywords.append(keyword)
                print(f"✓ 見つかりました: '{keyword}'")
            else:
                print(f"✗ 見つかりませんでした: '{keyword}'")
        
        # より詳細な検索 - 正規表現を使用
        print("\n=== 詳細検索 ===")
        iphone_16_pattern = r'iPhone\s*16[^0-9]*Pro\s*Max[^0-9]*512GB[^0-9]*ブラックチタニウム'
        matches = re.findall(iphone_16_pattern, page_text, re.IGNORECASE)
        
        if matches:
            print(f"正規表現で見つかったマッチ: {matches}")
        else:
            print("正規表現では見つかりませんでした")
        
        # ページ内のiPhoneモデルを抽出
        print("\n=== ページ内のiPhoneモデル一覧 ===")
        iphone_models = re.findall(r'iPhone\s+[0-9]+[^0-9]*Pro\s*Max[^0-9]*[0-9]+GB', page_text, re.IGNORECASE)
        if iphone_models:
            for model in set(iphone_models):
                print(f"- {model}")
        else:
            print("iPhone Pro Maxモデルが見つかりませんでした")
        
        # Discordに通知を送信
        discord_webhook = "https://discord.com/api/webhooks/1415299648041779353/oht5AUpV0hHq1H8cIKBnouTpblq2T1NdAihNnQH1soVQMXTpXnMJi1s7em-25LT7OGLU"
        if discord_webhook:
            # iPhoneモデル一覧をDiscordメッセージとして作成
            current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            discord_message = f"🔍 **Apple整備済みiPhoneサイト検索結果** ({current_time})\n\n"
            
            if iphone_models:
                discord_message += "📱 **利用可能なiPhone Pro Maxモデル:**\n"
                for model in set(iphone_models):
                    discord_message += f"• {model}\n"
            else:
                discord_message += "❌ iPhone Pro Maxモデルは見つかりませんでした\n"
            
            # iPhone 16 Pro Max 512GB - ブラックチタニウムの検索結果を追加
            if found_keywords:
                discord_message += f"\n✅ **iPhone 16 Pro Max 512GB - ブラックチタニウム関連キーワード発見:**\n"
                for keyword in found_keywords:
                    discord_message += f"• {keyword}\n"
            else:
                discord_message += f"\n❌ **iPhone 16 Pro Max 512GB - ブラックチタニウムは見つかりませんでした**\n"
            
            discord_message += f"\n🔗 サイト: {url}"
            
            send_discord_notification(discord_webhook, discord_message)
        else:
            print("Discord Webhook URLが設定されていません。環境変数 DISCORD_WEBHOOK_URL を設定してください。")
        
        # 結果の要約
        print(f"\n=== 要約 ===")
        if found_keywords:
            print(f"iPhone 16 Pro Max 512GB - ブラックチタニウムに関連するキーワードが {len(found_keywords)} 個見つかりました")
        else:
            print("iPhone 16 Pro Max 512GB - ブラックチタニウムに関連するキーワードは見つかりませんでした")
            
        return found_keywords, iphone_models
        
    except requests.exceptions.RequestException as e:
        print(f"リクエストエラー: {e}")
        return [], []
    except Exception as e:
        print(f"エラーが発生しました: {e}")
        return [], []

if __name__ == "__main__":
    print("Apple整備済みiPhoneサイトでiPhone 16 Pro Max 512GB - ブラックチタニウムを検索中...")
    results, models = check_iphone_16_pro_max_black_titanium()
    
    if results:
        print(f"\n検索完了: {len(results)}個のキーワードが見つかりました")
    else:
        print("\n検索完了: iPhone 16 Pro Max 512GB - ブラックチタニウムは見つかりませんでした")
    
    if models:
        print(f"利用可能なiPhone Pro Maxモデル: {len(set(models))}種類")

