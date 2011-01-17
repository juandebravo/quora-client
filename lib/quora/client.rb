require 'rubygems'
require 'net/http'
require 'uri'
require 'json'
require 'quora/auth'

#
# Quora client enables the communication with Quora API via REST interface
#
# (c) Juan de Bravo <juandebravo@gmail.com>
#

module Quora
  #
  # This is the main class to interact with Quora API.
  # 
  # Actually there's no API security mechanism so interaction with API is
  # based on authentication cookie or web authentication (providing user and password).
  # If you don't want to expose user credentials You should get all the 
  # Quora cookies value from you browser and use it as argument while 
  # creating the Quora client:
  #
  # cookie = "m-b=<m-b-value>; m-f=<m-f-value>; m-s=<m-s-value>; ..."
  #
  # client = Quora::Client.new(cookie)
  #
  # Or using user credentials:
  #
  # client = Quora::Client.new({:user => valid_user, :password => valid_password})
  #
  # values = client.get_all
  #

  class Client
    include Quora::Auth

    QUORA_URI = "http://api.quora.com"

    RESP_PREFIX = "while(1);"

    BASEPATH = "/api/logged_in_user"

    SUPPORTED_FIELDS = %W{inbox followers following notifs}

    #
    # Initialize the client.
    # @param [required, string|Hash] User identification. Can be either a valid cookie
    #               previously authenticated or an Hash with :user and :password
    #
    # client = Client.new(valid_cookie)
    # client = Client.new({:user => valid_user, :password => valid_password})
    #
    def initialize(params)
      if params.nil?
        raise ArgumentError, "Cookie value must be provided"
      else
        if params.instance_of?(String)
          cookie = params
        elsif params.instance_of?(Hash)
          user = params[:user]
          password = params[:password]
          user.nil? or password.nil? and raise ArgumentError, "user and password must be provided"
          cookie = login(user, password)
        end
      end
      @cookie = cookie
    end

    #
    # Get all the user information available
    #
    def get_all
      fields = SUPPORTED_FIELDS.join(",")
      get(fields)
    end

    #
    # Base method to send a request to Quora API.
    # @param [required, string] supported field (or multiple fields CSV) to retrieve
    # @param [optional, bool] filter if field is a key in result hash, only this
    #       value is returned
    #
    def get(field, filter = true)
      if field.nil? or !field.instance_of?(String)
        raise ArgumentError, "Field value must be a string"
      end
      resp = http.get("#{BASEPATH}?fields=#{field}", headers)
      data = resp.body[RESP_PREFIX.length..-1]
      data = JSON.parse(data)
      if filter && data.has_key?(field)
        data[field]
      else
        data
      end
    end

    #
    # Define a method for each of the supported fields
    #
    SUPPORTED_FIELDS.each{|field|
      define_method("get_#{field}"){
        get(field)
      }
    }

    #
    # Any method that starts with "get_" will be defined so if new fields
    # are supported there's no need to fix the client
    #
    def respond_to?(method_id, include_private = false)
      if method_id.to_s =~ /^get_[\w]+/
        true
      else
        super
      end
    end

    #
    # Override method_missing so any method that starts with "get_" will be
    # defined.
    #
    # i.e.
    # client.get_profile
    #
    # will generate =>
    #
    # def get_profile
    #   get("profile")
    # end
    #
    def method_missing(method_id, *arguments, &block)
      if method_id.to_s =~ /^get_[\w]+/
        self.class.send :define_method, method_id do
          field = method_id.to_s[4..-1]
          get(field)
        end
        self.send(method_id)
      else
        super
      end
    end

    private

    #
    # Create (if not done before) and return the instance HTTP client
    #
    def http
      @http ||= Net::HTTP.new(endpoint.host, endpoint.port)
    end

    #
    # Create (if not done before) and return the Quora API endpoint
    #
    def endpoint
      @@endpoint ||= URI.parse(QUORA_URI)
    end

    #
    # Set headers
    #
    def headers
      @cookie.nil? and raise ArgumentError, "cookie must be provided"
      {
        "Cookie" => @cookie
      }
    end

  end
end
