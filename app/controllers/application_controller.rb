class ApplicationController < ActionController::Base
  def hello
    render html: "Hello Protest Planner!"
  end
end
