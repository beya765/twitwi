require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @base_title = "Twitwi"
  end 

  test "should get home" do
    get root_path
    assert_response :success
    assert_select "title", "#{@base_title} | home"
  end
  
  test "should get about" do
    get about_path
    assert_response :success
    assert_select "title", "#{@base_title} | about"
  end
  
  test "should get contact" do
    get contact_path
    assert_response :success
    assert_select "title", "#{@base_title} | Contact"
  end

end
