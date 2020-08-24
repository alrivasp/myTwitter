class TweetsController < ApplicationController
  before_action :set_tweet, only: [:show, :edit, :update, :destroy]
  before_action :set_current_tweet, only: [:likes, :retweet]

  def likes
    if @tweet.is_liked?(current_user)
      @tweet.remove_like(current_user)
    else
      @tweet.add_like(current_user)
    end

    if current_user.present?
      redirect_to root_path
    else
      redirect_to new_user_session_path
    end
  end

  def retweet
    if current_user.present?
      if @tweet.is_rt?(current_user, @tweet.id)
        Tweet.create(content: @tweet.content, user: current_user, rt_ref: @tweet.id)
      else
        rm = Tweet.find_by(user_id: current_user, rt_ref: @tweet.id)
        rm.destroy
      end
      redirect_to root_path
    else
      redirect_to new_user_session_path
    end
  end

  # GET /tweets
  # GET /tweets.json
  def index
    @tweets = Tweet.all
  end

  # GET /tweets/1
  # GET /tweets/1.json
  def show
    @tweets = @tweet.list_of_rt
  end

  # GET /tweets/new
  def new
    @tweet = Tweet.new
  end

  # GET /tweets/1/edit
  def edit
  end

  # POST /tweets
  # POST /tweets.json
  def create
    @tweet = Tweet.new(tweet_params)
    @tweet.user_id = current_user.id
    respond_to do |format|
      if @tweet.save
        format.html { redirect_to root_path, notice: 'Whisper Posteado Correctamente' }
        format.json { render :show, status: :created, location: @tweet }
      else

        if @tweet.errors.any?
          @tweet.errors.full_messages.each do |message|
            if message.include? ".blank"
              format.html { redirect_to root_path, alert: "Post no puede ser solo espacios en blanco" }
            else
              format.html { redirect_to root_path, alert: "#{message}" }
            end
          end
        end
        #format.html { render :new }
        #format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tweets/1
  # PATCH/PUT /tweets/1.json
  def update
    respond_to do |format|
      if @tweet.update(tweet_params)
        format.html { redirect_to @tweet, notice: 'Tweet was successfully updated.' }
        format.json { render :show, status: :ok, location: @tweet }
      else
        format.html { render :edit }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tweets/1
  # DELETE /tweets/1.json
  def destroy
    @tweet.destroy
    respond_to do |format|
      format.html { redirect_to tweets_url, notice: 'Tweet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tweet
      @tweet = Tweet.find(params[:id])
    end

    def set_current_tweet
      @tweet = Tweet.find(params[:tweet_id])
    end

    # Only allow a list of trusted parameters through.
    def tweet_params
      params.require(:tweet).permit(:content,:user_id)
    end
end
