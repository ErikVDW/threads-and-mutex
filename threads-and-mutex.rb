# Threading is a strategy of taking most advantage of the availability of resources to complete a programming task.  Threading allows us to complete tasks in parallel as opposed to in sequence.  Tasks sufficiently small relative to resources available can be completed simultaneously as opposed to consecutively.
# Here we define a way to sum an array conventionally:
def sum_array ary
  sleep(2)
  sum = 0
  ary.each do |val|
    sum += val
  end
  sum
end

@items1 = [1,2,3,4]
@items2 = [5,6,7,8]
@items3 = [9,10,11,12]

p "items1: #{sum_array(@items1)}"
p "items2: #{sum_array(@items2)}"
p "items3: #{sum_array(@items3)}"

# Alternative using threading

threads = (1..3).map do |i|
  Thread.new(i) do |i|
    items = instance_variable_get("@items#{i}")
    puts "items#{i} = #{sum_array(items)}"
  end
end
threads.each {|t| t.join}

# Watch out for race conditions (situation arising in threading where different threads are in use of the same resource at the same time)!

# Simple, single-threaded:
class Item
  class << self; attr_accessor :price end
  @price = 0
end

(1..10).each {Item.price += 10}

puts "Item.price = #{Item.price}"

# Now make it multithreaded: (price will not update!)
class Item
  class << self; attr_accessor :price end
  @price = 0
end

threads = (1..10).map do |i|
  Thread.new(i) do |i|
    item_price = Item.price # Reading value
    sleep(rand(0..1))
    item_price += 10 # Updating value
    sleep(rand(0..1))
    Item.price = item_price # Writing value
  end
end

threads.each {|t| t.join}

puts "Item.price = #{Item.price}"

# But we can just add Mutex to create mutual exclusion that will prevent race conditions in our program:
mutex = Mutex.new

class Item
  class << self; attr_accessor :price end
  @price = 0
end

threads = (1..10).map do |i|
  Thread.new(i) do |i|
    mutex.synchronize do
      item_price = Item.price # Reading value
      sleep(rand(0..1))
      item_price += 10 # Updating value
      sleep(rand(0..1))
      Item.price = item_price # Writing value
    end
  end
end

threads.each {|t| t.join}

puts "Item.price = #{Item.price}"