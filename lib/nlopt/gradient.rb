module NLopt
  class Gradient
    def initialize(ptr, n)
      @ptr = ptr
      @n = n
    end

    def [](index)
      check_index(index)
      @ptr[index * Fiddle::SIZEOF_DOUBLE, Fiddle::SIZEOF_DOUBLE].unpack1("d")
    end

    def []=(index, value)
      check_index(index)
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

    def check_index(index)
      if index >= @n
        raise IndexError, "index #{index} outside of array bounds"
      end
    end
  end
end
