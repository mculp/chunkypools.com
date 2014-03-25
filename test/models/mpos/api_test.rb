require 'test_helper'

class ApiTest < ActiveSupport::TestCase
  def setup
    @api = MPOS::API.new('doge', 'bad1dea')
  end

  test "api key will be defaulted" do
    api = MPOS::API.new('hi')

    assert_equal api.api_key, MPOS::API.api_key
  end

  test "api key can be overridden" do
    api = MPOS::API.new('anything', 'bad1dea')

    assert_equal api.api_key, 'bad1dea'
  end

  test "url properly interpolated" do
    url = @api.url('action')

    assert_equal url, 'https://chunkypools.com/doge/index.php?page=api&api_key=bad1dea&action=action'
  end

  test "seconds_to_minutes_and_hours with a negative number should return 0" do
    ret = @api.seconds_to_minutes_and_hours(-5)
    assert_equal ret, [0, 1]
  end

  test "seconds_to_minutes_and_hours with 0 should return 0" do
    ret = @api.seconds_to_minutes_and_hours(0)
    assert_equal ret, [0, 1]
  end

  test "seconds_to_minutes_and_hours with a number less than 60 should be handled correctly" do
    ret = @api.seconds_to_minutes_and_hours(5)
    assert_equal ret, [0, 1]
  end

  test "seconds_to_minutes_and_hours with a number less than 3600 should be handled correctly" do
    ret = @api.seconds_to_minutes_and_hours(1805)
    assert_equal ret, [0, 30]
  end

  test "seconds_to_minutes_and_hours with a number greater than 3600 should be handled correctly" do
    ret = @api.seconds_to_minutes_and_hours(3605)
    assert_equal ret, [1, 0]
  end
end
