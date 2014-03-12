require 'rake'

namespace :translatable do
  # SRC_RDB=/usr/local/var/db/redis/dump.rdb
  # SRC_DB=6
  desc 'restore Redis from rdb file'
  task restore: :environment do
    redis_restore = RedisRestore.new(src_rdb: ENV['SRC_RDB'], src_db: ENV['SRC_DB'])

    puts "restoring with #{redis_restore.reloader_options}"
    redis_restore.restore

    puts "finished!"
  end
end