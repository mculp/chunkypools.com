require 'test_helper'

class HashieTest < ActiveSupport::TestCase
  test "will instantiate an array of hashies" do
    array = [{ hello: 'one' }, { hello: 'two' }]
  end

  test "will instantiate a hash normally" do
    hash = { hello: 'one' }
  end
end
