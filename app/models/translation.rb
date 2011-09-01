class Translation
  attr_accessor :locale, :key, :value

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  class << self
    def save(locale, key, value)
      store[formatted_key(locale, key)] = value
    end

    def find(filter)
      locale = filter[:locale]

      Translation.available_keys(locale).sort.collect{|key|
        val = Translation.locale_value(locale, key)
        Translation.new(:locale => locale, :key => key, :value => val) if val
      }.compact
    end

    def locales
      store.keys.collect{|key| /([A-Za-z-]+)\./.match(key)[1]}.uniq.sort
    end

    def available_keys(locale)
      keys  = store.keys("#{locale}.*")
      range = Range.new(locale.size + 1, -1)
      keys.collect { |k| k.slice(range) }.sort!
    end

    def locale_value(locale, key)
      store[formatted_key(locale, key)]
    end

    private
    def store
      Translator.store
    end
    
    def formatted_key(locale, key)
      "#{locale}.#{key}"
    end
  end
end
