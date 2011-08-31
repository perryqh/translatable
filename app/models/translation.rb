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

    def locales
      store.keys('i18n:*').collect{|key| /i18n\:([A-Za-z-]+)\./.match(key)[1]}.uniq.sort
    end

    def available_keys(locale)
      keys  = store.keys("#{key_prefix(locale)}.*")
      range = Range.new(key_prefix(locale).size + 1, -1)
      keys.collect { |k| k.slice(range) }.sort!
    end

    def locale_value(locale, key)
      store[formatted_key(locale, key)]
    end

    private
    def formatted_key(locale, key)
      "#{key_prefix(locale)}.#{key}"
    end

    def key_prefix(locale)
      "i18n:#{locale}"
    end
  end
end
