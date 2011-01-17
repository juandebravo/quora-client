
# Introduction

Quora client enables the communication with Quora API via REST
interface.

Actually there's no API security mechanism so interaction with API is based on authentication cookie.
You can provide either a valid cookie or a valid pair user - password.

If you want to get the cookie value, you can use a local proxy, sniffer, etc to get the correct value, that
should be something similar to: 

  "m-b=<m-b-value>; m-f=<m-f-value>; m-s=<m-s-value>; ..."

# Install

Just install the gem:

> gem install quora-client

# How to use Quora Client

> require 'rubygems'
>
> require 'quora-client'
>
> cookie ="<valid_value>"
>
> client = Quora::Client.new(cookie)
>
> # or...
>
> client = Quora::Client.new({:user => "<user>", :password => "<password>"})
>
> user_data = client.get_all

# Support methods

Currently Quora supported fields include inbox, followers, following and notifs. Each field has an associated method in the client:

> client.get_inbox
>
> client.get_followers
>
> client.get_following
>
> client.get_notifs
>

