class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include DocumentsHelper
  include DocumentItemsHelper
  include DocumentSelectsHelper
  include MeetingsHelper 
end
