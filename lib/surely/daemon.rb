module Surely
  class Daemon
    def initialize(argv, env)
      @uploader = Uploader.new(env)
      @uploader.authorize!

      begin
        puts "Listening to changes on #{env['DIRECTORY']}..."

        listener = Listen.to(env['DIRECTORY'])
        listener.filter(/\.png$/)
        listener.change(&@uploader.callback)
        listener.start!
      ensure
        exit
      end
    end
  end
end
