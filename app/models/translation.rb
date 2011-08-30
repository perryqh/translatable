class Translation
  attr_accessor :locale, :key, :value

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  class << self
    def store
      @store ||= Redis.new(:url => Settings.redis_url)
    end

    def create(locale, key, value)
      store[formatted_key(locale, key)] = value
    end

    def reload!
      store.flushdb
      I18n.backend.load_translations
    end

    def find(filter)
      locale = filter[:locale]

      Translation.available_keys(locale).sort.collect{|key|
        val = Translation.locale_value(locale, key)
        Translation.new(:locale => locale, :key => key, :value => val) if val
      }.compact
    end

    # Get all keys for a given locale removing the locale from
    # the key and sorting them alphabetically. If a key is named
    # "en.foo.bar", this method will return it as "foo.bar".
    def available_keys(locale)
      keys  = store.keys("#{locale}.*")
      range = Range.new(locale.size + 1, -1)
      keys.collect { |k| k.slice(range) }.sort!
    end

    # Get the stored value in the translator store for a given
    # locale. This method needs to decode values and check if they
    # are a hash, because we don't want subtrees available for
    # translation since they are managed automatically by I18n.
    def locale_value(locale, key)
      store[formatted_key(locale, key)]
    end

    private 
    def formatted_key(locale, key)
      "#{locale}.#{key}"
    end
  end
end
