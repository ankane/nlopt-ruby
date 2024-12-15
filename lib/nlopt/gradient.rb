module NLopt
  class Gradient
    def initialize(ptr, n)
      @ptr = ptr
      @n = n
    end

    def [](index)
      index = check_index(index)
      @ptr[index * Fiddle::SIZEOF_DOUBLE, Fiddle::SIZEOF_DOUBLE].unpack1("d")
    end

    def []=(index, value)
      index = check_index(index)
      @ptr[index * Fiddle::SIZEOF_DOUBLE, Fiddle::SIZEOF_DOUBLE] = [value].pack("d")
    end

    def size
      @n
    end

    def inspect
      "#<#{self.class.name} #{@n.times.map { |i| self[i] }.inspect}>"
    end
    alias_method :to_s, :inspect

    private

    def check_index(original_index)
      index = original_index
      index += @n if index < 0
      if index < 0 || index >= @n
        raise IndexError, "index #{original_index} outside of array bounds"
      end
      index
    end
  end
end
