module Forem
  module Formatters
    class HTML
      def self.format(text)
        text.html_safe
      end
    end
  end
end

  # module Forem
  #   module FormattingHelper
  #     def as_formatted_html(text)
  #       cleaned = Sanitize.clean(text, Sanitize::Config::RELAXED)

  #       ("<br/>" + cleaned).html_safe
  #     end
  #   end