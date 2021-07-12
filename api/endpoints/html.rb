# frozen_string_literal: true

module Api
  module Endpoints
    class Html < Grape::API
      content_type :html, "text/html"
      get do
        scope = OpenStruct.new({})
        Slim::Template.new('views/players.slim').render(scope)
      end
    end
  end
end