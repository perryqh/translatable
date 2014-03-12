require 'spec_helper'

describe RedisRestore do
  let(:src_rdb) { 'dump.rdb' }
  let(:src_db) { 4 }

  describe :initialize do
    describe :failure do
      specify { lambda { RedisRestore.new() }.should raise_error('src_rdb is required') }
      specify { lambda { RedisRestore.new(src_db: 3) }.should raise_error('src_rdb is required') }
      specify { lambda { RedisRestore.new(src_rdb: src_rdb) }.should raise_error('src_db is required') }
    end
  end

  let(:expected_reloader_options) { {rdb_filename: src_rdb,
                                     source_db:    src_db,
                                     redis_host:   Settings.redis_host,
                                     redis_port:   Settings.redis_port,
                                     target_db:    Settings.redis_db} }

  subject { RedisRestore.new(src_rdb: src_rdb, src_db: src_db) }

  its(:reloader_options) { should eq(expected_reloader_options) }

  describe :restore do
    it 'delegates to RedisReload' do
      reload_stub = stub('reload', reload: 'yes!')
      RedisReload::Reloader.should_receive(:new).with(expected_reloader_options).and_return(reload_stub)
      subject.restore.should eq('yes!')
    end
  end
end