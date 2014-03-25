require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  include ApplicationHelper

  test "nav item test without active condition" do
    expected = '<li><a href="/hi"><i class="fa fa-hello"></i> Hey</a></li>'
    actual = nav_item('Hey', '/hi', 'hello')

    assert_equal expected, actual
  end

  test "nav item test with active condition" do
    @view_flow = ActionView::OutputFlow.new
    content_for(:page, 'yes')

    expected = '<li class="active"><a href="/hi"><i class="fa fa-hello"></i> Hey</a></li>'
    actual = nav_item('Hey', '/hi', 'hello', 'yes')


    assert_equal expected, actual
  end
end

