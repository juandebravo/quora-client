require 'rubygems'
require 'net/http'
require 'uri'
require 'cgi'


module Quora
  module Auth

    QUORA_URI = "http://www.quora.com"

    def login(user, password)
      endpoint = URI.parse(QUORA_URI)

      http = Net::HTTP.new(endpoint.host, endpoint.port)
      resp = http.get('/login/')
      cookie = resp["set-cookie"]

      # TODO: improve this rubbish
      # get formkey value
      start = resp.body.index("Q.formkey")
      formkey = resp.body[start..start+200].split("\"")[1]

      # get window value
      start = resp.body.index("webnode2.windowId")
      window = resp.body[start..start+200].split("\"")[1]

      # get __vcon_json value
      start = resp.body.index("InlineLogin")
      vcon_json = resp.body[start..start+200]
      start = vcon_json.index("live")
      vcon_json = vcon_json[start..-1]
      vcon_json = vcon_json.split("\"")[0]
      vcon_json = vcon_json.split(":")
      vcon_json.map! { |value| "\"#{value}\"" }

      vcon_json = "[#{vcon_json.join(",")}]"
      vcon_json = CGI::escape(vcon_json)

      user = CGI::escape(user)
      password = CGI::escape(password)

      body = "json=%7B%22args%22%3A%5B%22#{user}%22%2C%22#{password}%22%2Ctrue%5D%2C%22kwargs%22%3A%7B%7D%7D&formkey=#{formkey}&window_id=#{window}&__vcon_json=#{vcon_json}&__vcon_method=do_login"

      headers = {
        "Content-Type"     => "application/x-www-form-urlencoded",
        "X-Requested-With" => "XMLHttpRequest",
        "Accept"           => "application/json, text/javascript, */*",
        "Cookie"           => cookie,
        "User-Agent"       => "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_5; en-US) AppleWebKit/534.10 (KHTML, like Gecko) Chrome/8.0.552.237 Safari/534.10",
        "Content-Length"   => body.length.to_s,
        "Accept-Charset"   => "ISO-8859-1,utf-8;q=0.7,*;q=0.3",
        "Accept-Language"  => "es-ES,es;q=0.8",
        "Accept-Encoding"  => "gzip,deflate,sdch",
        "Origin"           => "http://www.quora.com",
        "Host"             => "www.quora.com",
        "Referer"          => "http://www.quora.com/login/"
      }

      resp = http.post("/webnode2/server_call_POST", body, headers)

      if resp.code == "200"
        cookie
      else
        ""
      end
    end
  end
end
