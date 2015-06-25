class FakeException < StandardError
  attr_reader :message, :backtrace

  def initialize(message, backtrace=[])
    if backtrace.empty?
      backtrace << "from /blah_blah_blah.rb:18:in `block (5 levels) in <top (required)>"
    end

    @message = message
    @backtrace = backtrace

    super message
  end
end

class AliasedException < FakeException
end