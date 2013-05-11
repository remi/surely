module Surely
  class Daemon
    def initialize(env)
      @env = env
    end

    def start
      directory = @env['SURELY_DIRECTORY']
      directory ||= `defaults read com.apple.screencapture location 2> /dev/null`.chomp
      directory = "#{@env['HOME']}/Desktop" if directory.empty?

      @uploader = Uploader.new(@env, directory)
      @uploader.authorize!

      Raad::Logger.info "Listening to changes on #{directory}..."

      listener = Listen.to(directory)
      listener.filter(/\.(png|jpg|jpeg|gif)$/)
      listener.change(&@uploader.callback)
      listener.start

      sleep(1) while !Raad.stopped?
    end
  end
end
