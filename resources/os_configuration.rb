

actions :write

attribute :description,   :kind_of => String,                     :name_attribute => true
attribute :domain,        :kind_of => String,                     :default => nil
attribute :key,           :kind_of => [ String, Symbol],                     :default => nil
attribute :value

attribute :integer,       :kind_of => Integer,                    :default => nil
attribute :string,        :kind_of => String,                     :default => nil
attribute :boolean,       :kind_of => [ TrueClass, FalseClass ],  :default => nil
attribute :float,         :kind_of => [Float, Integer],           :default => nil
attribute :array,         :kind_of => [Array, String, Integer],   :defaults => nil

def initialize(name, run_context=nil)
  super
  @action = :write
end
