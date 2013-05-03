module Surely
  class Daemon
    def initialize(env)
      @env = env
    end

    def start
      directory = @env['SURELY_DIRECTORY'] || `defaults read com.apple.screencapture location`.chomp
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
