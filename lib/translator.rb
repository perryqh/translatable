module Translator
  def self.store
    @store ||= Redis.new(:host => Settings.redis_host, :port => Settings.redis_port, :db => Settings.redis_db, :namespace => Settings.redis_namespace)
  end

  def self.reload!
    Translator.store.flushdb
    I18n.backend.load_translations
  end

  class Backend < I18n::Backend::KeyValue 
    include I18n::Backend::Memoize

    def initialize
      super(Translator.store)
    end
  end
end