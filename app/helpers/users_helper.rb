
module UsersHelper

  # 先生からのお便り保護者絞り込み
  def t_message_content(t_message, user)
    t_message_user = t_message.select_user.split(',').map{|m| m.delete('[]" \\')}

    case user.name + user.name2
      when *t_message_user
        content = t_message.content
      else
        content = ""
    end
    return content
  end