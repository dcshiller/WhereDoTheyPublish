class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def sift_categories(categorizable)
    @categories = categorizable.cat.map { |k, v| [categorizable.category_name[k],v] if v > 0 }.compact
    @categories.sort! { |a, b| b[-1] <=> a[-1] }
    @categories.reject! { |a, b| b < 10 }
    @categories = @categories[0...5]
  end
end
