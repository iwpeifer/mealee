class ConnectionAdapter
  attr_reader :adapter, :database

  def initialize(database, adapter="s")
    @adapter = adapter
    @database = database
  end

  def connect!
    ActiveRecord::Base.establish_connection(
      :adapter => self.adapter,
      :database => self.database
    )
  end
end