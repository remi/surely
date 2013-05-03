module Surely
  class Daemon
    def initialize(argv, env)
      directory = env['SURELY_DIRECTORY'] || `defaults read com.apple.screencapture location`.chomp
      @uploader = Uploader.new(env, directory)
      @uploader.authorize!

      begin
        puts "Listening to changes on #{directory}..."

        listener = Listen.to(directory)
        listener.filter(/\.(png|jpg|jpeg|gif)$/)
        listener.change(&@uploader.callback)
        listener.start!
      ensure
        exit
      end
    end
  end
end
