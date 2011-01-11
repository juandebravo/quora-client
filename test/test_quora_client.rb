#!/opt/local/bin/ruby

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'quora'


#
# Quora client enables the communication with Quora API via REST interface
#
# (c) Juan de Bravo <juandebravo@gmail.com>
# 
# Methods to test Quora client
#
class TestQuoraClient < Test::Unit::TestCase

  def setup
    if ARGV.length == 0
      @cookie = "invalid value"
    else
      @cookie = ARGV[0]
    end
    
  end

  def test_get_all    
    p client.get_all
  end


  def test_get_client_methods
    Quora::Client::SUPPORTED_FIELDS.each{|field|
      assert_equal client.class.instance_methods.index("get_#{field}") > 0, true
    }
    
  end

  def test_respond_to?
    client.class.instance_methods(false).each{|method|
      assert_equal client.respond_to?(method), true
    }
  end

  private

  def client
    client = Quora::Client.new(@cookie)
  end
end

#
# Define a test helper to retrieve per each supported field
# test_get_inbox
# test_get_notifs
# test_get_followers
# test_get_following
#
Quora::Client::SUPPORTED_FIELDS.each{|field|
  TestQuoraClient.send :define_method, "test_get_#{field}" do
    p client.send "get_#{field}".to_s
  end
}



