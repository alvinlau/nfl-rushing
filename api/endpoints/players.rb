# frozen_string_literal: true

module Api
  module Endpoints
    class Players < Grape::API
      # https://docs.mongodb.com/ruby-driver/master/tutorials/query-cache/
      content_type :html, "text/html"
      format :html
      namespace :players do
        desc 'query players' do
          is_array true
          tags %w[player]
        end
        params do
          optional :sort_by, type: String
          optional :sort_order, type: String
          optional :filter_name, type: String
        end
        get do
          @mongo = Mongo::Client.new(['127.0.0.1:27017'], :database => 'local')
          p params
          # get the params
          sort_by = params['sort_by'] || nil
          sort_order = params['sort_order'] || 'desc'
          filter_name = params['filter_name'] || nil
          filter_name = nil if filter_name && filter_name.empty?
          page = (params['page'] || 1).to_i
          page = 1 if page < 1
          per_page = 20
          # some sane defaults
          sort_by = nil if !['Yds', 'TD', 'Lng'].include? sort_by
          sort_order = {'asc' => 1, 'desc' => -1}[sort_order]
          sort_order ||= -1
          # query mongo
          players = @mongo[:players]
          results = filter_name ? players.find({'Player' => filter_name}) : players.find
          results = sort_by ? results.sort(sort_by => sort_order) : results
          results = results.skip((page-1) * per_page)
          results = results.limit(per_page).to_a
          # render view
          view_sort_order = {'Yds' => 'desc', 'TD' => 'desc', 'Lng' => 'desc'}
          view_sort_order[sort_by] = {1 => 'desc', -1 => 'asc'}[sort_order] if sort_by
          scope = OpenStruct.new({
            players: results,
            sort_by: sort_by,
            sort_order: view_sort_order,
            filter_name: filter_name,
            page: page,
            year: 2021 })
          Slim::Template.new('views/players.slim').render(scope)
        end

        desc 'download data' do
          is_array true
          tags %w[player]
        end
        params do
          optional :sort_by, type: String
          optional :sort_order, type: String
          optional :filter_name, type: String
        end
        get 'download' do
          @mongo = Mongo::Client.new(['127.0.0.1:27017'], :database => 'local')
          @mongo[:players].find()

          # require 'csv'
          # require 'json'

          # csv_string = CSV.generate do |csv|
          #   JSON.parse(File.open("foo.json").read).each do |hash|
          #     csv << hash.values
          #   end
          # end

          # puts csv_string
        end

        desc 'get specific player' do
          tags %w[player]
        end
        params do
          requires :id
        end
        get ':id' do
          # your code goes here
        end
      end
    end
  end
end
