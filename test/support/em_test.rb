module EmTest
  def self.included( spec )
    spec.around do |&block|
      # implicit argument passing of super from method defined by define_method() is not supported. Specify all arguments explicitly.
      super() do
        EventMachine::run do
          block.call
          EventMachine::stop
        end
      end
    end
  end
end
