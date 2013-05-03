module Surely
  class Uploader
    def initialize(env)
      @access_token  = File.read("#{env['HOME']}/.surely_access_token") rescue nil
      @refresh_token = File.read("#{env['HOME']}/.surely_refresh_token") rescue nil

      @imgur = Faraday.new(:url => 'https://api.imgur.com/3/') do |c|
        c.request :multipart
        c.request :url_encoded
        c.adapter :net_http
      end

      @env = env
    end

    def upload_file(file)
      file = Faraday::UploadIO.new(file, 'image/png')

      response = @imgur.post 'image' do |r|
        r.headers['Authorization'] = "Bearer #{@access_token}"
        r.body = { image: file }
      end

      if response.success?
        MultiJson.load(response.body)["data"]
      else
        nil
      end
    end

    def update_tokens(token_data)
      @access_token = token_data["access_token"]
      @refresh_token = token_data["refresh_token"]
      File.open("#{@env['HOME']}/.surely_access_token", 'w') { |f| f << @access_token }
      File.open("#{@env['HOME']}/.surely_refresh_token", 'w') { |f| f << @refresh_token }
    end

    def authorize!
      return true if @access_token && @refresh_token
      system "open 'https://api.imgur.com/oauth2/authorize?client_id=#{@env['IMGUR_CLIENT_ID']}&response_type=token'"
      print "Enter your access_token: "
      access_token = gets.chomp
      print "Enter your refresh_token: "
      refresh_token = gets.chomp
      update_tokens({ "access_token" => access_token, "refresh_token" => refresh_token })
    end

    def refresh_token!
      response = @imgur.post 'oauth2/token' do |r|
        r.body = {
          refresh_token: @refresh_token,
          client_id: @env['IMGUR_CLIENT_ID'],
          client_secret: @env['IMGUR_CLIENT_SECRET'],
          grant_type: 'refresh_token'
        }
      end

      if response.success?
        token_data = MultiJson.load(response.body)
        update_tokens(token_data)
      end

      response
    end
  end
end
