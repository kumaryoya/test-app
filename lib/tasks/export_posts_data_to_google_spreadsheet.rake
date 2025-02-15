# frozen_string_literal: true

namespace :export do
  desc 'ポストデータをGoogleスプレッドシートにエクスポート'
  task export_posts_data_to_google_spreadsheet: :environment do
    GoogleSpreadsheetService.new.export_posts
  end
end
