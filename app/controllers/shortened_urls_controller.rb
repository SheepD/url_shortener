class ShortenedUrlsController < ApplicationController
  before_filter :set_shortened_url_params, only: [:create]
  before_filter :set_shortened_url, only: [:new, :create]

  def new
  end

  def create
    url = @shortened_url_params[:original_url]
    unless url =~ /^http:\/\// || url =~ /^https:\/\//
      url = "http://#{url}"
    end

    unless ShortenedUrl.validate_url url
      flash[:error] = 'Invalid URL provided'
    else
      slug =
        if @shortened_url_params[:slug].blank?
         ShortenedUrl.generate_slug
        else
          @shortened_url_params[:slug]
        end

      shortened_url = ShortenedUrl.create(original_url: url, slug: slug)
      if shortened_url.save
        flash[:notice] = "Congratulations! We have shortened the url to: #{visit_path_url shortened_url.slug}"
      else
        flash[:error] = shortened_url.errors
      end
    end

    render 'new'
  end

  def visit
    shortened_url = ShortenedUrl.find_by_slug params[:slug]
    if shortened_url.blank?
      flash[:error] = 'The shorterned url you provided doesnt exist :('
      redirect_to :new
    else
      redirect_to shortened_url.original_url
    end
  end

  private
  def set_shortened_url_params
    @shortened_url_params =
      params.require(:shortened_url).
        permit(:original_url, :slug)
  end

  def set_shortened_url
    @shortened_url = ShortenedUrl.new
  end
end
