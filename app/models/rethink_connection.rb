module RethinkConnection
  def rethink
    @rethink_connection ||= r.connect(host: Settings::RETHINK, port: 28015)
  end
end