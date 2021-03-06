require "minitest/autorun"
require_relative "../test_helper"

class TestAutoDiscovery < Minitest::Test
  def test_auto_discovery
    # When no certificates are stored
    system({ "TEST_DOMAIN" => TEST_DOMAIN, "FORCE_RENEW" => "true" }, "cd ./compositions/auto-discovery/ && docker-compose up -d")

    page = read_https_content
    assert page.include?("WordPress")

    # When certificates are stored in a data volume
    system({ "TEST_DOMAIN" => TEST_DOMAIN }, "cd ./compositions/auto-discovery/ && docker-compose stop && docker-compose up -d")

    page = read_https_content
    assert page.include?("WordPress")
  end

  def teardown
    system({ "TEST_DOMAIN" => TEST_DOMAIN }, "cd ./compositions/auto-discovery/ && docker-compose stop")
  end
end
