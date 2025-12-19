# frozen_string_literal: true

module ApplicationHelper
  def render_markdown(file_path)
    markdown_content = File.read(file_path)
    renderer = Redcarpet::Render::HTML.new
    markdown = Redcarpet::Markdown.new(renderer, fenced_code_blocks: true, autolink: true)
    markdown.render(markdown_content).html_safe
  end
end
