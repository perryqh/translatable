class RedisRestore
  attr_accessor :src_rdb, :src_db

  def initialize(atts={})
    self.src_rdb = atts[:src_rdb] || raise('src_rdb is required')
    self.src_db  = atts[:src_db] || raise('src_db is required')
  end

  def restore
    RedisReload::Reloader.new(reloader_options).reload
  end

  def reloader_options
    {
        rdb_filename: self.src_rdb,
        source_db:    self.src_db,
        redis_host:   Settings.redis_host,
        redis_port:   Settings.redis_port,
        target_db:    Settings.redis_db
    }
  end
end