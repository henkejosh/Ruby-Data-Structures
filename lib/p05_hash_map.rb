require_relative 'p02_hashing'
require_relative 'p04_linked_list'

class HashMap
  attr_reader :count
  include Enumerable

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { LinkedList.new }
    @count = 0
  end

  def include?(key)
    @store[key.hash % num_buckets].include?(key)
  end

  def set(key, val)
    resize! if @count == num_buckets
    increment = !self.include?(key)
    @store[key.hash % num_buckets].insert(key, val)
    @count += 1 if increment
  end

  def get(key)
    if @store[key.hash % num_buckets].include?(key)
      return @store[key.hash % num_buckets].get(key)
    end
    nil
  end

  def delete(key)
    list = bucket(key)
    if list
      link = list[key]
      link.prev.next = link.next
      link.next.prev = link.prev
      @count -= 1
    end
  end

  def each
    @store.each do |bucket|
      bucket.each do |link|
        yield(link.key, link.val)
      end
    end
  end

  def to_s
    pairs = inject([]) do |strs, (k, v)|
      strs << "#{k.to_s} => #{v.to_s}"
    end
    "{\n" + pairs.join(",\n") + "\n}"
  end

  alias_method :[], :get
  alias_method :[]=, :set

  private

  def num_buckets
    @store.length
  end

  def resize!
    new_size = num_buckets * 2
    new_store = Array.new(new_size) { LinkedList.new }
    @store.each do |list|
      list.each do |link|
        new_store[link.key.hash % new_size].insert(link.key, link.val)
      end
    end
    @store = new_store
  end

  def bucket(key)
    @store[key.hash % num_buckets]
  end
end
