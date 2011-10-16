# from refinerycms/core/config/initializers/will_paginate_monkeypath.rb
module WillPaginate
  module ActionView
    class LinkRenderer < ViewHelpers::LinkRenderer
      def url(page)
        @base_url_params ||= begin
          url_params = merge_get_params(default_url_params)
          merge_optional_params(url_params)
        end

        url_params = @base_url_params.dup

        add_current_page_param(url_params, page)
        url_params.delete(:page) if url_params[:page] == 1

        begin
          @template.main_app.url_for(url_params)
        rescue ActionView::Template::Error => e
          if e.message =~ /route/
            @template.url_for(url_params)
          else
            raise e
          end
        end
      end
    end
  end
end