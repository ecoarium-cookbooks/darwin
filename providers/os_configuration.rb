action :write do
  guess unless new_resource.value.nil?

  execute "#{new_resource.description} - #{new_resource.domain} - #{new_resource.key}"  do
    command "defaults write #{new_resource.domain} #{new_resource.key} #{type_flag} #{value}"
    user ENV['USER']
    not_if "defaults read #{new_resource.domain} #{new_resource.key} | grep ^#{grep_value}$"
  end
end

def guess
  @grep_value = new_resource.value
  if new_resource.value.is_a? Integer
    new_resource.integer = new_resource.value
  elsif new_resource.value.is_a? TrueClass
    @grep_value = 1
    new_resource.boolean = new_resource.value
  elsif new_resource.value.is_a? FalseClass
    @grep_value = 0
    new_resource.boolean = new_resource.value
  elsif new_resource.value.is_a? Float
    new_resource.float = new_resource.value
  elsif new_resource.value.is_a? Array
    new_resource.array = new_resource.value
  else
    new_resource.string = new_resource.value
  end
end

def type_flag
  return '-int' if new_resource.integer
  return '-string' if new_resource.string
  return '-float' if new_resource.float
  return '-boolean' unless new_resource.boolean.nil?
  ''
end

def value
  new_resource.integer ||
    new_resource.string ||
    (new_resource.float && new_resource.float.to_f) ||
    new_resource.boolean
end

def grep_value
  @grep_value
end
