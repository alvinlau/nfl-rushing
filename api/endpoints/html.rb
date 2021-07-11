# frozen_string_literal: true

module Api
  module Endpoints
    class Html < Grape::API
      content_type :html, "text/html"
      get do
        scope = OpenStruct.new({author: "Jimmy Cool", year: '2021', items: []})
        Slim::Template.new('views/players.slim').render(scope)
      end
    end
  end
end