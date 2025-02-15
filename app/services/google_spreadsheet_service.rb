# frozen_string_literal: true

require 'google/apis/sheets_v4'
require 'googleauth'

class GoogleSpreadsheetService
  SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS

  def initialize
    @service = Google::Apis::SheetsV4::SheetsService.new
    @service.client_options.application_name = 'template_rails'
    @service.authorization = authorize
  end

  def export_posts
    spreadsheet_id = ENV.fetch('GOOGLE_SPREADSHEET_ID', nil)
    sheet_name = 'シート1'

    values = [['ID', 'Title', 'Content', 'Created At']]
    Post.find_each do |post|
      values << [post.id, post.title, post.content, post.created_at.strftime('%Y-%m-%d %H:%M:%S')]
    end

    value_range_object = Google::Apis::SheetsV4::ValueRange.new(values: values)
    @service.append_spreadsheet_value(
      spreadsheet_id,
      "#{sheet_name}!A1:D",
      value_range_object,
      value_input_option: 'RAW'
    )
  end

  private

  def authorize
    Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: StringIO.new(service_account_json),
      scope: [SCOPE]
    )
  end

  def service_account_json
    {
      type: 'service_account',
      project_id: ENV.fetch('GOOGLE_SPREADSHEET_PROJECT_ID', nil),
      private_key_id: ENV.fetch('GOOGLE_SPREADSHEET_PRIVATE_KEY_ID', nil),
      private_key: ENV['GOOGLE_SPREADSHEET_PRIVATE_KEY'].gsub('\\n', "\n"),
      client_email: ENV.fetch('GOOGLE_SPREADSHEET_CLIENT_EMAIL', nil),
      client_id: '',
      auth_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_uri: 'https://oauth2.googleapis.com/token',
      auth_provider_x509_cert_url: 'https://www.googleapis.com/oauth2/v1/certs',
      client_x509_cert_url: ''
    }.to_json
  end
end
