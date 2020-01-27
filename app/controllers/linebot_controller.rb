class LinebotController < ApplicationController
  before_action :desired_mail,   only: [:push]

  # pushアクションのCSRFトークン認証を無効
  protect_from_forgery :except => [:push]

  # LINEプッシュ処理
  def push
    if params[:commit] == "スケジュール決定送信"
      require 'line/bot'  # gem 'line-bot-api'
      @teacher = Teacher.find(current_teacher.id)
      @teacher.meeting_confirm_update

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
        "altText": "面談スケジュールが決まりました。サイトからご自身の面談日時をご確認ください。",
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
                "text": "面談日確定のお知らせ",
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
                  "uri": "https://school-app-pta.herokuapp.com?openExternalBrowser=1"
                }
              }
            ]
          }
       }
      }

      @users.each do |user|
        Meeting1Mailer.meeting1_mail(user).deliver_later  #メーラに作成したメソッドを呼び出す。
      end

      group_id = ENV["LINE_CHANNEL_GROUP_ID"]
      response = client.push_message(group_id, message)
      flash[:success] = "送信完了"
      redirect_to teacher_path(current_teacher)

    end

    if params[:commit] == "日時決定送信"
      require 'line/bot'
      @teacher.meeting_decision_update

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
        "altText": "面談の日時が決まりました。サイトから希望日の登録をお願いいたします。",
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
                        "text": "下記からサイトにアクセスして、\n希望日の登録をお願いいたします。",
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
                  "uri": "https://school-app-pta.herokuapp.com?openExternalBrowser=1"
                }
              }
            ]
          }
        }
      }

      @users.each do |user|
        Meeting2Mailer.meeting2_mail(user).deliver_later  #メーラに作成したメソッドを呼び出す。
      end

      group_id = ENV["LINE_CHANNEL_GROUP_ID"]
      response = client.push_message(group_id, message)

      flash[:success] = "送信完了"
      redirect_to teacher_path(current_teacher)

    end

    if params[:commit] == "通知する"
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
        "altText": "書類を送信しました。確認ください。",
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
                  "uri": "https://school-app-pta.herokuapp.com?openExternalBrowser=1"
                }
              }
            ]
          }
        }
      }

      user = User.find 1
      documents = user.documents.all
      documents.each do |dc|
        @documents = Document.where(memo: dc.memo, randam: dc.randam)
        @documents.each do |document|
          document.public =true
          document.save
        end
      end



      group_id = ENV["LINE_CHANNEL_GROUP_ID"]
      response = client.push_message(group_id, message)

      flash[:success] = "送信完了"
      redirect_to documents_path(params:{teacher_id: current_teacher.id})
    end
  end

  private
    # before_action

    # メール希望者のアドレス取得
    def desired_mail
      @teacher = Teacher.find(current_teacher.id)
      @users = User.where(send_select: false)
    end
end
