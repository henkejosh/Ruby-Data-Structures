require_relative 'p05_hash_map'
require_relative 'p04_linked_list'

class LRUCache
  attr_reader :count

  def initialize(max, prc)
    @map = HashMap.new
    @store = LinkedList.new
    @max = max
    @prc = prc
  end

  def count
    @map.count
  end

  def get(key)
    if @map.include?(key)
      link = @map.get(key)
      update_link!(link)
      return link.val
    else
      link_val = @prc.call(key)
      new_link = Link.new(key, link_val)
      update_link!(new_link)
      return link_val
    end
  end

  def to_s
    "Map: " + @map.to_s + "\n" + "Store: " + @store.to_s
  end

  private

  def update_link!(link)
    old_last = @store.last

    @map.set(link.key, link)
    old_last.next.prev = link
    link.next = old_last.next
    link.prev = old_last
    old_last.next = link
    eject! if count > @max
  end

  def eject!
    delete_key = @store.first.key
    @store.remove(@store.first.key)
    @map.delete(delete_key)
  end
end
