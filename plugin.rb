module Plugins
    module LoomioUserImport
        class Plugin < Plugins::Base
            setup! :loomio_user_import do |plugin|
                plugin.enabled = true
                plugin.use_class 'admin/user_imports'
                plugin.use_view_path :views
            end
        end
    end
end
