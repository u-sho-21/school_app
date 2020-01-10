module ApplicationHelper

  def full_title(page_name = "")
    base_title = "ページ"
    if page_name.empty?
      base_title
    else
      base_title + " | " + page_name
    end
  end
end