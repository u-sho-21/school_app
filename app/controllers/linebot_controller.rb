class LinebotController < ApplicationController

  # pushアクションのCSRFトークン認証を無効
  protect_from_forgery :except => [:push]

  # LINEプッシュ処理
  def push
    if params[:commit] == "スケジュール決定送信"
      require 'line/bot'  # gem 'line-bot-api'

      client = Line::Bot::Client.new { |config|
        config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
        config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
      }

      # message={
      # type: 'text',
      # text: 'テスト'
      # }

      # "url": "https://push-test-pta.herokuapp.com/ファイル名(拡張子も)"   publicの場合
      # "url": "https://drive.google.com/uc?id=ファイルID"                googledriveの場合
      # "url": "埋め込みurl"                                              onedriveの場合
      image_url = "https://school-app-pta.herokuapp.com/image01.jpg"

      message={
        "type": "flex",
        "altText": "this is a flex message",
        "contents": {
          "type": "bubble",
          "hero": {
            "type": "image",
            "url": image_url,
            "size": "full",
            "aspectRatio": "20:13",
            "aspectMode": "cover"
          },
          "body": {
            "type": "box",
            "layout": "vertical",
            "spacing": "md",
            "contents": [
              {
                "type": "text",
                "text": "面談のお知らせ",
                "size": "xl",
                "weight": "bold"
              },
              {
                "type": "box",
                "layout": "vertical",
                "spacing": "sm",
                "contents": [
                  {
                    "type": "box",
                    "layout": "baseline",
                    "contents": [
                      {
                        "type": "text",
                        "text": "下記からサイトにアクセスして、\n希望日等の登録をお願いします。",
                        "weight": "bold",
                        "margin": "sm",
                        "wrap": true,
                        "flex": 0
                      }
                    ]
                  }
                ]
              }
            ]
          },
          "footer": {
            "type": "box",
            "layout": "vertical",
            "contents": [
              {
                "type": "spacer",
                "size": "xxl"
              },
              {
                "type": "button",
                "style": "primary",
                "color": "#FF9933",
                "action": {
                  "type": "uri",
                  "label": "サイトへ",
                  "uri": "https://school-app-pta.herokuapp.com"
                }
              }
            ]
          }
        }
      }

      group_id = ENV["LINE_CHANNEL_GROUP_ID"]
      response = client.push_message(group_id, message)
      flash[:success] = "送信完了"
      redirect_to teacher_path(current_teacher)
    end

    if params[:commit] == "日時確定送信"
      require 'line/bot'
      debugger

      client = Line::Bot::Client.new { |config|
        config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
        config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
      }

      # "url": "https://push-test-pta.herokuapp.com/ファイル名(拡張子も)"   publicの場合
      # "url": "https://drive.google.com/uc?id=ファイルID"                googledriveの場合
      # "url": "埋め込みurl"                                              onedriveの場合
      image_url = "https://school-app-pta.herokuapp.com/image01.jpg"

      message={
        "type": "flex",
        "altText": "this is a flex message",
        "contents": {
          "type": "bubble",
          "hero": {
            "type": "image",
            "url": image_url,
            "size": "full",
            "aspectRatio": "20:13",
            "aspectMode": "cover"
          },
          "body": {
            "type": "box",
            "layout": "vertical",
            "spacing": "md",
            "contents": [
              {
                "type": "text",
                "text": "面談日時確定のお知らせ",
                "size": "xl",
                "weight": "bold"
              },
              {
                "type": "box",
                "layout": "vertical",
                "spacing": "sm",
                "contents": [
                  {
                    "type": "box",
                    "layout": "baseline",
                    "contents": [
                      {
                        "type": "text",
                        "text": "下記からサイトにアクセスして、\nご自身の面談日時をご確認ください。",
                        "weight": "bold",
                        "margin": "sm",
                        "wrap": true,
                        "flex": 0
                      }
                    ]
                  }
                ]
              }
            ]
          },
          "footer": {
            "type": "box",
            "layout": "vertical",
            "contents": [
              {
                "type": "spacer",
                "size": "xxl"
              },
              {
                "type": "button",
                "style": "primary",
                "color": "#FF9933",
                "action": {
                  "type": "uri",
                  "label": "サイトへ",
                  "uri": "https://school-app-pta.herokuapp.com"
                }
              }
            ]
          }
        }
      }

      group_id = ENV["LINE_CHANNEL_GROUP_ID"]
      response = client.push_message(group_id, message)

      redirect_to teacher_path(@teacher)
    end

    if params[:commit] == "提出を通知する。"
      require 'line/bot'  # gem 'line-bot-api'

      client = Line::Bot::Client.new { |config|
        config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
        config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
      }

      # message={
      # type: 'text',
      # text: 'テスト'
      # }

      # "url": "https://push-test-pta.herokuapp.com/ファイル名(拡張子も)"   publicの場合
      # "url": "https://drive.google.com/uc?id=ファイルID"                googledriveの場合
      # "url": "埋め込みurl"                                              onedriveの場合
      image_url = "https://school-app-pta.herokuapp.com/image01.jpg"

      message={
        "type": "flex",
        "altText": "this is a flex message",
        "contents": {
          "type": "bubble",
          "hero": {
            "type": "image",
            "url": image_url,
            "size": "full",
            "aspectRatio": "20:13",
            "aspectMode": "cover"
          },
          "body": {
            "type": "box",
            "layout": "vertical",
            "spacing": "md",
            "contents": [
              {
                "type": "text",
                "text": "書類提出のお願いします。",
                "size": "xl",
                "weight": "bold"
              },
              {
                "type": "box",
                "layout": "vertical",
                "spacing": "sm",
                "contents": [
                  {
                    "type": "box",
                    "layout": "baseline",
                    "contents": [
                      {
                        "type": "text",
                        "text": "下記からサイトにアクセスして、\n確認をお願いします。",
                        "weight": "bold",
                        "margin": "sm",
                        "wrap": true,
                        "flex": 0
                      }
                    ]
                  }
                ]
              }
            ]
          },
          "footer": {
            "type": "box",
            "layout": "vertical",
            "contents": [
              {
                "type": "spacer",
                "size": "xxl"
              },
              {
                "type": "button",
                "style": "primary",
                "color": "#FF9933",
                "action": {
                  "type": "uri",
                  "label": "サイトへ",
                  "uri": "https://school-app-pta.herokuapp.com"
                }
              }
            ]
          }
        }
      }

      group_id = ENV["LINE_CHANNEL_GROUP_ID"]
      response = client.push_message(group_id, message)
      flash[:success] = "送信完了"
      redirect_to teacher_path(current_teacher)
    end 
  end
end
