module NLopt
  class Opt
    def initialize(algorithm, n)
      algorithm = FFI.nlopt_algorithm_from_string(algorithm)
      if algorithm < 0
        raise ArgumentError, "Invalid algorithm"
      end

      if n <= 0
        raise ArgumentError, "Invalid dimension"
      end

      @opt = FFI.nlopt_create(algorithm, n)
      @opt.free = FFI["nlopt_destroy"]
    end

    def set_min_objective(f)
      # keep reference
      @f = objective_callback(f)
      check_res FFI.nlopt_set_min_objective(@opt, @f, nil)
    end

    def set_max_objective(f)
      # keep reference
      @f = objective_callback(f)
      check_res FFI.nlopt_set_max_objective(@opt, @f, nil)
    end

    def set_lower_bounds(lb)
      if lb.is_a?(Array)
        check_res FFI.nlopt_set_lower_bounds(@opt, Fiddle::Pointer[lb.pack("d*")])
      elsif lb.is_a?(Numeric)
        check_res FFI.nlopt_set_lower_bounds1(@opt, lb)
      else
        raise TypeError, "expected array or numeric"
      end
    end

    def set_upper_bounds(ub)
      if ub.is_a?(Array)
        check_res FFI.nlopt_set_upper_bounds(@opt, Fiddle::Pointer[ub.pack("d*")])
      elsif ub.is_a?(Numeric)
        check_res FFI.nlopt_set_upper_bounds1(@opt, ub)
      else
        raise TypeError, "expected array or numeric"
      end
    end

    def set_maxeval(maxeval)
      check_res FFI.nlopt_set_maxeval(@opt, maxeval)
    end

    def optimize(init)
      if init.size != dimension
        raise ArgumentError, "size does not match dimension"
      end

      x = Fiddle::Pointer[init.pack("d*")]
      opt_f = Fiddle::Pointer.malloc(Fiddle::SIZEOF_DOUBLE)
      res = FFI.nlopt_optimize(@opt, x, opt_f)

      if res < 0 && res != -4
        errmsg = FFI.nlopt_get_errmsg(@opt)
        msg = !errmsg.null? ? errmsg.to_s : "Bad result: #{FFI.nlopt_result_to_string(res).to_s}"
        raise Error, msg
      end

      x.to_s(x.size).unpack("d*")
    end

    def algorithm_name
      FFI.nlopt_algorithm_name(FFI.nlopt_get_algorithm(@opt)).to_s
    end

    def dimension
      FFI.nlopt_get_dimension(@opt)
    end

    def numevals
      FFI.nlopt_get_numevals(@opt)
    end

    private

    def check_res(res)
      if res != 1
        raise Error, "Bad result: #{FFI.nlopt_result_to_string(res).to_s}"
      end
    end

    def objective_callback(f)
     Fiddle::Closure::BlockCaller.new(Fiddle::TYPE_DOUBLE, [Fiddle::TYPE_UINT, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP]) do |n, x, gradient, func_data|
        x = x.to_s(n * Fiddle::SIZEOF_DOUBLE).unpack("d*")
        grad = !gradient.null? ? Gradient.new(gradient, n) : nil
        f.call(x, grad)
      end
    end
  end
end
