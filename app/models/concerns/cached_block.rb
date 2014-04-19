module Concerns
  module CachedBlock
    extend ActiveSupport::Concern
    include SharedMethods

    module ClassMethods
      include SharedMethods
    end

    module SharedMethods
      def cached(key)
        if cached_results = Rails.cache.read(key)
          return cached_results
        end

        results = yield

        Rails.cache.write(key, results)

        results
      end
    end
  end
end
