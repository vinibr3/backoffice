class BackofficeError < StandardError
  attr_accessor :pointer, :parameter, :message, :title

  def initialize(args)
    @title = args[:title] || 'Invalid'
    @message = args[:message]
    @pointer = args[:pointer]
    @parameter = args[:parameter]
  end
end
