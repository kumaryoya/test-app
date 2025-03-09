# frozen_string_literal: true

require 'google/apis/drive_v3'
require 'google/apis/sheets_v4'
require 'googleauth'

class SpreadsheetService
  SCOPE = [
    Google::Apis::DriveV3::AUTH_DRIVE,
    Google::Apis::SheetsV4::AUTH_SPREADSHEETS
  ].freeze

  def initialize
    @sheets_service = Google::Apis::SheetsV4::SheetsService.new
    @drive_service = Google::Apis::DriveV3::DriveService.new

    @sheets_service.client_options.application_name = 'test-app'
    @drive_service.client_options.application_name = 'test-app'

    credentials = authorize
    @sheets_service.authorization = credentials
    @drive_service.authorization = credentials
  end

  def create_spreadsheet(user)
    google_drive_folder_id = ENV.fetch('GOOGLE_DRIVE_FOLDER_ID', nil)
    spreadsheet_name = "Post - #{user.name}"
    request = Google::Apis::DriveV3::File.new(
      name: spreadsheet_name,
      parents: [google_drive_folder_id],
      mime_type: 'application/vnd.google-apps.spreadsheet'
    )
    spreadsheet = @drive_service.create_file(request)
    user.update!(spreadsheet_id: spreadsheet.id)
  end

  def export_posts(user)
    spreadsheet_id = user.spreadsheet_id
    sheet_name = 'Sheet1'
    range = "#{sheet_name}!A1:E"
    @sheets_service.clear_values(spreadsheet_id, range)
    values = [['ID', 'Title', 'Content', 'Created At', 'Updated At']]
    user.posts.order(id: :desc).each do |post|
      values << [post.id, post.title, post.content, post.created_at.strftime('%Y-%m-%d %H:%M:%S'),
                 post.updated_at.strftime('%Y-%m-%d %H:%M:%S')]
    end
    value_range_object = Google::Apis::SheetsV4::ValueRange.new(values: values)
    @sheets_service.update_spreadsheet_value(
      spreadsheet_id,
      range,
      value_range_object,
      value_input_option: 'RAW'
    )
  end

  private

  def authorize
    Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: StringIO.new(service_account_json),
      scope: SCOPE
    )
  end

  def service_account_json
    {
      type: 'service_account',
      project_id: ENV.fetch('GOOGLE_PROJECT_ID', nil),
      private_key_id: '',
      private_key: ENV.fetch('GOOGLE_PRIVATE_KEY', nil).gsub('\\n', "\n"),
      client_email: ENV.fetch('GOOGLE_CLIENT_EMAIL', nil),
      client_id: '',
      auth_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_uri: 'https://oauth2.googleapis.com/token',
      auth_provider_x509_cert_url: 'https://www.googleapis.com/oauth2/v1/certs',
      client_x509_cert_url: ''
    }.to_json
  end
end
