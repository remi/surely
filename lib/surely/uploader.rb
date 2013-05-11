module Surely
  class Uploader
    def initialize(env, settings, directory)
      @access_token  = settings['access_token']
      @refresh_token = settings['refresh_token']
      @imgur_client_id  = settings['imgur_client_id']
      @imgur_client_secret = settings['imgur_client_secret']

      @imgur = Faraday.new(url: 'https://api.imgur.com') do |c|
        c.request :multipart
        c.request :url_encoded
        c.adapter :net_http
      end

      @env = env
      @settings = settings
      @directory = directory
    end

    def upload_file(file)
      file = Faraday::UploadIO.new(file, "image/#{file.split(/\./).last}")

      response = @imgur.post '/3/image' do |r|
        r.headers['Authorization'] = "Bearer #{@access_token}"
        r.body = { image: file }
      end

      if response.success?
        MultiJson.load(response.body)['data']
      else
        nil
      end
    end

    def update_tokens(token_data)
      @access_token = token_data['access_token']
      @refresh_token = token_data['refresh_token']
      save_settings
    end

    def save_settings
      @settings = @settings.merge({
        'imgur_client_id' => @imgur_client_id,
        'imgur_client_secret' => @imgur_client_secret,
        'access_token' => @access_token,
        'refresh_token' => @refresh_token,
      })

      File.open("#{@env['HOME']}/.surely.yml", 'w') { |f| f << @settings.to_yaml }
    end

    def add_client!
      return true if @imgur_client_id && @imgur_client_secret

      puts 'Create an imgur application here: https://api.imgur.com/oauth2/addclient'
      print 'Enter your application client_id: '
      @imgur_client_id = STDIN.gets.chomp
      print 'Enter your application client_secret: '
      @imgur_client_secret = STDIN.gets.chomp

      save_settings
    end

    def authorize!
      return true if @access_token && @refresh_token

      system "open 'https://api.imgur.com/oauth2/authorize?client_id=#{@imgur_client_id}&response_type=token'"
      print 'Enter your access_token: '
      access_token = STDIN.gets.chomp
      print 'Enter your refresh_token: '
      refresh_token = STDIN.gets.chomp
      update_tokens('access_token' => access_token, 'refresh_token' => refresh_token)
    end

    def refresh_token!
      response = @imgur.post '/oauth2/token' do |r|
        r.body = {
          refresh_token: @refresh_token,
          client_id: @imgur_client_id,
          client_secret: @imgur_client_secret,
          grant_type: 'refresh_token'
        }
      end

      if response.success?
        token_data = MultiJson.load(response.body)
        update_tokens(token_data)
      end

      response
    end

    def callback
      @callback ||= lambda do |modified, added, removed|
        if added.any?
          Raad::Logger.info 'Uploading... '
          refresh_token!

          if uploaded_file = upload_file(File.join(@directory, added.first))
            Raad::Logger.info "Done! Uploaded #{uploaded_file['link']}"
            system "say -v 'Fred' 'Uploaded'"
            system "echo #{uploaded_file['link']} | pbcopy"
          end
        end
      end
    end
  end
end
