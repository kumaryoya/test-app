# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]

  def index
    @posts = current_user.posts.order(id: :desc)
  end

  def show; end

  def new
    @post = current_user.posts.new
  end

  def edit; end

  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      redirect_to root_path, notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  def update
    if @post.update(post_params)
      redirect_to root_path, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to root_path, notice: 'Post was successfully destroyed.'
  end

  def export_to_spreadsheet
    spreadsheet_service = SpreadsheetService.new
    spreadsheet_service.create_spreadsheet(current_user) if current_user.spreadsheet_id.blank?
    spreadsheet_service.export_posts(current_user)
    redirect_to root_path, notice: 'Post was successfully exported to Spreadsheet.'
  end

  private

  def post_params
    params.require(:post).permit(:title, :content)
  end

  def set_post
    @post = current_user.posts.find(params[:id])
  end
end
