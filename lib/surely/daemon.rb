module Surely
  class Daemon
    def initialize(argv, env)
      @uploader = Uploader.new(env)
      @uploader.authorize!

      callback = Proc.new do |modified, added, removed|
        if added.any?
          puts "Uploading..."
          @uploader.refresh_token!

          if uploaded_file = @uploader.upload_file(File.join(env['DIRECTORY'], added.first))
            puts "Done uploading #{uploaded_file['link']}"
            system "say -v 'Fred' 'Uploaded'"
            system "echo #{uploaded_file['link']} | pbcopy"
          end
        end
      end

      listener = Listen.to(env["DIRECTORY"])
      listener.filter(/\.png$/)
      listener.change(&callback)

      begin
        puts "Listening to changes on #{env["DIRECTORY"]}..."
        listener.start!
      ensure
        exit
      end
    end
  end
end
