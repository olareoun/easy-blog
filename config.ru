require 'sass/plugin/rack'

Sass::Plugin.options[:style] = :compressed
Sass::Plugin.options[:template_location] = 'web/public/css/sass'
Sass::Plugin.options[:css_location] = 'web/public/css'

use Sass::Plugin::Rack

require File.join(File.dirname(__FILE__), 'web/app.rb')

map "/" do
   run Web
end

