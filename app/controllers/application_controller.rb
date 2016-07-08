class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :prepare_meta_tags, if: "request.get?"

  def prepare_meta_tags(options={})
    site_name   = 'MTB Trail Status'
    title       = 'Charlotte mountain bike trail statuses'
    description = 'Use MTB Trail Status to set up text message alerts when your favorite Charlottte, NC mountain bike trails open or close. Be the first to know when it\'s time to hit the trail or when to cancel your group ride.'
    image       = options[:image] || view_context.asset_url('og.jpg')
    current_url = request.url

    defaults = {
      site:        'MTB Trail Status',
      title:       title,
      image:       image,
      description: description,
      keywords:    %w[charlotte mountain bike trails status],
      og: {
        url:         current_url,
        site_name:   site_name,
        title:       title,
        image:       image,
        description: description,
        type:        'website'
      }
    }

    options.reverse_merge!(defaults)

    set_meta_tags options
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
end
