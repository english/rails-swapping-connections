ENV['RAILS_ENV'] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

RSpec.configure do |c|
  c.use_transactional_examples = false
  c.use_transactional_fixtures = false
end

require 'rack/handler/webrick'

def boot_server
  port = 3001
  host = 'localhost'

  thread = Thread.new do
    # ActiveRecord::Base.connection_pool.with_connection do
      Rack::Handler::WEBrick.run(Bug::Application, :Host => host, :Port => port, :AccessLog => [], :Logger => WEBrick::Log::new(nil, 0))
    # end
  end

  Timeout.timeout(2) do
    loop do
      thread.join(0.1)
      res = Net::HTTP.start(host, port) { |http| http.get('/') }
      puts res.body
      break if res.is_a?(Net::HTTPOK)
    end
  end
end

RSpec.describe "foo" do
  example do
    boot_server
  end
end

RSpec.describe "bar" do
  before(:context) do
    ActiveRecord::Base.connection.begin_transaction
    Thing.create
  end

  after(:context) do
    ActiveRecord::Base.connection.rollback_transaction
  end

  # def after_teardown
  # end

  example do
    puts "object_id: #{ActiveRecord::Base.connection.object_id}, connection_id: #{ActiveRecord::Base.connection_id}"
    expect(Thing.count).to eq(1) # pass
  end

  example do
    puts "object_id: #{ActiveRecord::Base.connection.object_id}, connection_id: #{ActiveRecord::Base.connection_id}"
    expect(Thing.count).to eq(1) # fail
  end

  example do
    puts "object_id: #{ActiveRecord::Base.connection.object_id}, connection_id: #{ActiveRecord::Base.connection_id}"
    expect(Thing.count).to eq(1) # pass
  end

  example do
    puts "object_id: #{ActiveRecord::Base.connection.object_id}, connection_id: #{ActiveRecord::Base.connection_id}"
    expect(Thing.count).to eq(1) # fail
  end

  example do
    puts "object_id: #{ActiveRecord::Base.connection.object_id}, connection_id: #{ActiveRecord::Base.connection_id}"
    expect(Thing.count).to eq(1) # pass
  end

  example do
    puts "object_id: #{ActiveRecord::Base.connection.object_id}, connection_id: #{ActiveRecord::Base.connection_id}"
    expect(Thing.count).to eq(1) # fail
  end
end
