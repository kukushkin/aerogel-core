# Aerogel::Cache implements LRU cache storage for partials (or other data?) caching.
#

require 'lru_redux'

module Aerogel
module Cache

  # Calculates a cache key for a single object,
  # or a compound cache key for a list of objects.
  #
  def self.cache_key( args )
    if Array === args
      args.flatten.map{|o| object_to_cache_key o }.join("/")
    else
      object_to_cache_key args
    end
  end

  # Retrieves cache entry by calculated cache key of +args+,
  # or runs given +block+, stores its result in the cache and returns its value.
  #
  def self.cacheable( *args, &block )
    key = cache_key args
    cache.getset key do
      yield key
    end
  end

  # Returns cache structure.
  #
  def self.cache
    @cache ||= initialize_cache
  end

  # Returns list of stored keys.
  #
  def self.keys
    cache.to_a.map(&:first)
  end

  # Clears cache completely.
  #
  def self.clear!
    @cache.clear
  end

private

  # Creates LRU cache with maximum objects count
  # specified by config value 'aerogel.cache.max_size'.
  #
  def self.initialize_cache
    max_size = Aerogel.config.aerogel.cache.max_size! rescue 1000
    LruRedux::Cache.new( max_size )
  end

  # Calculates a cache key for given +object+.
  #
  # If the object responds to :cache_key, its result is returned,
  # otherwise cache key is the object converted to String.
  #
  def self.object_to_cache_key( object )
    if object.respond_to? :cache_key
      object.cache_key
    else
      object.to_s
    end
  end

end # module Cache
end # module Aerogel
