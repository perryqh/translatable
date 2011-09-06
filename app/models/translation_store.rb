module TranslationStore
  def find(filter)
    locale = filter[:locale]

    if filter[:key]
      return Translation.new(:locale => locale, :key => filter[:key], :value => locale_value(locale, filter[:key])) if store.exists(formatted_key(locale, filter[:key]))

    else
      translations = Translation.available_keys(locale).sort.collect{|key|
        val = Translation.locale_value(locale, key)
        Translation.new(:locale => locale, :key => key, :value => val) if val
      }.compact

      translations = translations.select { |tran| tran.key.include?(filter[:filter_by]) } if filter[:filter_by]

      translations
    end
  end

  def destroy(locale, key)
    store.del(locale, formatted_key(locale, key))
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

  def reload!
    store.flushdb
    I18n.backend.load_translations
  end

  private
  def store
    @store ||= Redis.new(:host => Settings.redis_host, :password => Settings.redis_pw, :port => Settings.redis_port, :db => Settings.redis_db, :namespace => Settings.redis_namespace)
  end

  def formatted_key(locale, key)
    "#{locale}.#{key}"
  end

  def save(locale, key, value)
    store[formatted_key(locale, key)] = value
  end
end
