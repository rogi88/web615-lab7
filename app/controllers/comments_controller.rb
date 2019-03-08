# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  message    :text
#  visible    :boolean          default(FALSE)
#  article_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

class CommentsController < ApplicationController
  before_action :authenticate_user!,:set_comment, only: [:show, :edit, :update, :destroy]

  # GET /comments
  # GET /comments.json
  def index
    begin
    @comments = Comment.paginate(:page => params[:page], :per_page => params[:per_page] ||= 30).order(created_at: :desc)
    respond_to do |format|
      format.html{@articles}
      format.json {render :json, @articles}
      format.json {render :xml, @articles.to_xml}
    end
    rescue => e
    flash[:alert] = "Something went terribly wrong"
    respond_to do |format|
      format.html{
        redirect_to comments_path
      }
      format.json {render :json, status: 418}
    end
  end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    begin
  rescue ActiveRecord::RecordNotFound => e
    flash[:alert] = "The comment you're looking for cannot be found"
    respond_to do |format|
      format.html{
        redirect_to comments_path
      }
      format.json {render :json, status: 404}
    end
  rescue => e
    flash[:alert] = "Something else went wrong"
    respond_to do |format|
      format.html{
        redirect_to comments_path
      }
      format.json {render :json, status: 418}
    end
  end

  end

  # GET /comments/new
  def new
    begin
    @comment = Comment.new
  rescue => e
    flash[:alert] = "Something went wrong"
    respond_to do |format|
      format.html{
        redirect_to comments_path
      }
      format.json {render :json, status: 418}
    end
  end
  end

  # GET /comments/1/edit
  def edit
    begin
  rescue => e
    flash[:alert] = "Something went wrong"
    respond_to do |format|
      format.html{
        redirect_to comments_path
      }
      format.json {render :json, status: 418}
    end
  end
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    begin
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  rescue => e
    flash[:alert] = "Something went wrong"
    respond_to do |format|
      format.html{
        redirect_to comments_path
      }
      format.json {render :json, status: 418}
    end
  end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    begin
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to comments_url, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  rescue => e
    flash[:alert] = "Something went wrong"
    respond_to do |format|
      format.html{
        redirect_to comments_path
      }
      format.json {render :json, status: 418}
    end
  end
  end

  private
    # Use callbacks to share common setup or constraints between actions.

  def set_comment
    begin
      @comment = Comment.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      flash[:alert] = "The comment you're looking for cannot be found"
      respond_to do |format|
        format.html{
          redirect_to comments_path
        }
        format.json {render :json, status: 404}
      end
    rescue => e
      flash[:alert] = "Something went wrong"
      respond_to do |format|
        format.html{
          redirect_to comments_path
        }
        format.json {render :json, status: 418}
      end
    end
  end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:message, :visible, :user_id, :article_id)
      # Students, make sure to add the user_id and article ID parameter as symbols here ^^^^^^
    end
end
