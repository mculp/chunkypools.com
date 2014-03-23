require_relative 'mpos/api'

class Alert
  def self.get
    api = MPOS::API.new('posts')

    api.get_wrapped(:alert).alert
  end
end
