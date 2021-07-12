# frozen_string_literal: true

module Api
  module Endpoints
    class Players < Grape::API
      # https://docs.mongodb.com/ruby-driver/master/tutorials/query-cache/
      content_type :html, "text/html"
      format :html
      namespace :players do
        desc 'query players' do
          tags %w[player]
        end
        params do
          optional :sort_by, type: String
          optional :sort_order, type: String
          optional :filter_name, type: String
        end
        get do
          # get the params
          sort_by = params['sort_by'] || nil
          sort_order = params['sort_order'] || nil
          filter_name = params['filter_name'] || nil
          filter_name = nil if filter_name && filter_name.empty?
          page = (params['page'] || 1).to_i
          page = 1 if page < 1
          per_page = 20

          # some sane defaults
          sort_by = nil if !['Yds', 'TD', 'Lng'].include? sort_by
          query_sort_order = {'asc' => 1, 'desc' => -1}[sort_order] || -1

          # query mongo
          @mongo = Mongo::Client.new(['127.0.0.1:27017'], :database => 'local')
          players = @mongo[:players]
          results = filter_name ? players.find('$text': {'$search': filter_name}) : players.find
          results = sort_by ? results.sort(sort_by => query_sort_order) : results
          results = results.skip((page-1) * per_page)
          results_count = results.count
          results = results.limit(per_page).to_a

          # render view
          paginate = results_count > per_page
          last_page = (results_count / per_page) + (results_count % per_page ? 1 : 0) if paginate
          view_sort_order = {'Yds' => 'desc', 'TD' => 'desc', 'Lng' => 'desc'}
          view_sort_order[sort_by] = {'asc' => 'desc', 'desc' => 'asc'}[sort_order] if sort_by
          scope = OpenStruct.new({
            players: results,
            sort_by: sort_by,
            sort_order: sort_order,
            view_sort_order: view_sort_order,
            filter_name: filter_name,
            paginate: paginate,
            page: page,
            last_page: last_page,
            year: 2021 })
          Slim::Template.new('views/players.slim').render(scope)
        end

        content_type :csv, "text/csv"
        format :csv
        desc 'download data' do
          tags %w[player]
        end
        params do
          optional :sort_by, type: String
          optional :sort_order, type: String
          optional :filter_name, type: String
        end
        get 'download' do   
          header['Content-Disposition'] = "attachment; filename=nfl-rushing.csv"

          sort_by = params['sort_by'] || nil
          sort_order = params['sort_order'] || nil
          filter_name = params['filter_name'] || nil
          filter_name = nil if filter_name && filter_name.empty?
          sort_by = nil if !['Yds', 'TD', 'Lng'].include? sort_by
          query_sort_order = {'asc' => 1, 'desc' => -1}[sort_order] || -1

          @mongo = Mongo::Client.new(['127.0.0.1:27017'], :database => 'local')
          players = @mongo[:players]
          results = filter_name ? players.find('$text': {'$search': filter_name}) : players.find
          results = sort_by ? results.sort(sort_by => query_sort_order) : results
          results = results.to_a

          require 'csv'

          csv_string = CSV.generate do |csv|
            csv << ['Player','Team','Pos','Att','Att/G','Yds','Avg','Yds/G','TD','Lng','1st','1st%','20+','40+','FUM']
            results.each do |player|
              player[:Lng] = "#{player[:Lng]}#{player[:LngT]}"
              player.delete :LngT
              player.delete :_id
              csv << player.values
            end
          end

          csv_string
        end
      end
    end
  end
end
