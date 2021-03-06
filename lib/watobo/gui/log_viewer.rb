# @private 
module Watobo #:nodoc: all
  module Gui
    class LogViewer < FXVerticalFrame

      include Watobo::Constants

      def purge_logs
        begin
          @log_text_lock.synchronize do
            @textbox.setText('')
            # @textbox.makePositionVisible 0
          end
        rescue => bang
          puts "! Could not purge logs"
          puts bang
          puts bang.backtrace if $DEBUG
        end
      end

      # LOG_INFO
      def log(log_level, msg)

        t = Time.now
        now = t.strftime("%m/%d/%Y @ %H:%M:%S")

        begin
          log_text = case log_level
                       when LOG_INFO
                         "INFO - #{now}: #{msg}\n"
                       else
                         "UNDEF - #{now}: #{msg}\n"
                     end
          #@log_queue << log_text
          Watobo.save_thread do
            if @mode == :insert
              @log_text_lock.synchronize do
                @textbox.insertText(0, log_text)
              end
            else
              @log_text_lock.synchronize do
                @textbox.appendText(log_text)
              end
            end
            @textbox.handle(self, FXSEL(SEL_UPDATE, 0), nil)
          end

        rescue => bang
          puts bang
          puts bang.backtrace if $DEBUG
        end
      end

      def initialize(parent, mode = nil, opts)
        opts[:padding]=0

        @mode = mode.nil? ? :inster : mode

        super(parent, opts)

        @log_queue = Queue.new

        @log_text_lock = Mutex.new

        @textbox = FXText.new(self, nil, 0, :opts => LAYOUT_FILL_X|LAYOUT_FILL_Y)
        @textbox.editable = false

      end

    end

  end
end