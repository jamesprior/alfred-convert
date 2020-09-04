#!/usr/bin/env ruby

require 'json'
require 'cgi'
require 'base64'

query = "{query}".force_encoding(Encoding::UTF_8)

def uri_escape(query)
  enc = CGI::escape(query)
  {
    uid: 'uri-escape',
    title: enc,
    subtitle: 'uri escaped',
    arg: enc,
  }
end

def uri_unescape(query)
  plain = CGI::unescape(query)
  {
    uid: 'uri-unescape',
    title: plain,
    subtitle: 'uri unescaped',
    arg: plain,
  }
end

def base64_encode(query)
  enc = Base64.encode64(query)
  {
    uid: 'base64-encoded',
    title: enc,
    subtitle: 'base64 encoded',
    arg: enc,
  }
end

def base64_decode(query)
  plain = Base64.decode64(query)
  {
    uid: 'base64-decoded',
    title: plain,
    subtitle: 'base64 decoded',
    arg: plain,
  }
end

def base64_urlsafe_encode(query)
  enc = Base64.urlsafe_encode64(query)
  {
    uid: 'base64-urlsafe_encoded',
    title: enc,
    subtitle: 'base64 url safe encoded',
    arg: enc,
  }
end

def base64_urlsafe_decode(query)
  begin
    plain = Base64.urlsafe_decode64(query)
    {
      uid: 'base64-urlsafe_decoded',
      title: plain,
      subtitle: 'base64 url safe decoded',
      arg: plain,
    }
  rescue StandardError => e
    $stderr.puts "Error base64_urlsafe_decode #{query}: #{e.inspect}"
    nil
  end
end

def html_escape(query)
  enc = CGI::escapeHTML(query)
  {
    uid: 'html-escape',
    title: enc,
    subtitle: 'html escaped',
    arg: enc,
  }
end

def html_unescape(query)
  plain = CGI::unescapeHTML(query)
  {
    uid: 'html-unescape',
    title: plain,
    subtitle: 'html unescaped',
    arg: plain,
  }
end


options = []
options << uri_escape(query)
options << uri_unescape(query)
options << base64_encode(query)
options << base64_decode(query)
options << base64_urlsafe_encode(query)
options << base64_urlsafe_decode(query)
options << html_escape(query)
options << html_unescape(query)

options.reject! do |opt|
  opt.nil? ||
  opt[:title] == query
end

json_options = options.map do |opt|
  begin
    opt[:arg].strip!
    opt.to_json
  rescue StandardError => e
    $stderr.puts "Error converting #{opt}: #{e.inspect}"
  end
end.compact


print("{\"items\":[#{json_options.join(',')}]}")
