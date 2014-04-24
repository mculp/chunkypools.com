module Concerns
  module Rethink
    extend ActiveSupport::Concern

    include RethinkDB::Shortcuts


    module ClassMethods
      include RethinkDB::Shortcuts

      def rethink
        @rethink_connection ||= r.connect(host: Settings::RETHINK, port: 28015)
      end
    end
  end
end
