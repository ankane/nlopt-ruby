module NLopt
  class Opt
    attr_reader :last_optimum_value

    def initialize(algorithm, n)
      algorithm = FFI.nlopt_algorithm_from_string(+algorithm)
      if algorithm < 0
        raise ArgumentError, "Invalid algorithm"
      end

      if n <= 0
        raise ArgumentError, "Invalid dimension"
      end

      @opt = FFI.nlopt_create(algorithm, n)
      @opt.free = FFI["nlopt_destroy"]

      @inequality_constraints = []
      @equality_constraints = []
    end

    def dimension
      FFI.nlopt_get_dimension(@opt)
    end

    def algorithm_name
      FFI.nlopt_algorithm_name(FFI.nlopt_get_algorithm(@opt)).to_s
    end

    def set_min_objective(f)
      cb = objective_callback(f)
      check_res FFI.nlopt_set_min_objective(@opt, cb, nil)
      @cb = cb # keep reference
    end

    def set_max_objective(f)
      cb = objective_callback(f)
      check_res FFI.nlopt_set_max_objective(@opt, cb, nil)
      @cb = cb # keep reference
    end

    def set_lower_bounds(lb)
      if lb.is_a?(Array)
        check_res FFI.nlopt_set_lower_bounds(@opt, alloc_dptr(lb))
      elsif lb.is_a?(Numeric)
        check_res FFI.nlopt_set_lower_bounds1(@opt, lb)
      else
        raise TypeError, "expected array or numeric"
      end
    end

    def set_upper_bounds(ub)
      if ub.is_a?(Array)
        check_res FFI.nlopt_set_upper_bounds(@opt, alloc_dptr(ub))
      elsif ub.is_a?(Numeric)
        check_res FFI.nlopt_set_upper_bounds1(@opt, ub)
      else
        raise TypeError, "expected array or numeric"
      end
    end

    def lower_bounds
      out_dptr { |ptr| FFI.nlopt_get_lower_bounds(@opt, ptr) }
    end

    def upper_bounds
      out_dptr { |ptr| FFI.nlopt_get_upper_bounds(@opt, ptr) }
    end

    def add_inequality_constraint(fc, tol: 0)
      cb = objective_callback(fc)
      check_res FFI.nlopt_add_inequality_constraint(@opt, cb, nil, tol)
      @inequality_constraints << cb # keep reference
    end

    def add_equality_constraint(h, tol: 0)
      cb = objective_callback(h)
      check_res FFI.nlopt_add_equality_constraint(@opt, cb, nil, tol)
      @equality_constraints << cb # keep reference
    end

    def remove_inequality_constraints
      check_res FFI.nlopt_remove_inequality_constraints(@opt)
      @inequality_constraints.clear
    end

    def remove_equality_constraints
      check_res FFI.nlopt_remove_equality_constraints(@opt)
      @equality_constraints.clear
    end

    def set_stopval(stopval)
      check_res FFI.nlopt_set_stopval(@opt, stopval)
    end

    def stopval
      FFI.nlopt_get_stopval(@opt)
    end

    def set_ftol_rel(tol)
      check_res FFI.nlopt_set_ftol_rel(@opt, tol)
    end

    def ftol_rel
      FFI.nlopt_get_ftol_rel(@opt)
    end

    def set_ftol_abs(tol)
      check_res FFI.nlopt_set_ftol_abs(@opt, tol)
    end

    def ftol_abs
      FFI.nlopt_get_ftol_abs(@opt)
    end

    def set_xtol_rel(tol)
      check_res FFI.nlopt_set_xtol_rel(@opt, tol)
    end

    def xtol_rel
      FFI.nlopt_get_xtol_rel(@opt)
    end

    def set_xtol_abs(tol)
      if tol.is_a?(Array)
        check_res FFI.nlopt_set_xtol_abs(@opt, alloc_dptr(tol))
      elsif tol.is_a?(Numeric)
        check_res FFI.nlopt_set_xtol_abs1(@opt, tol)
      else
        raise TypeError, "expected array or numeric"
      end
    end

    def xtol_abs
      out_dptr { |ptr| FFI.nlopt_get_xtol_abs(@opt, ptr) }
    end

    def set_x_weights(w)
      if w.is_a?(Array)
        check_res FFI.nlopt_set_x_weights(@opt, alloc_dptr(w))
      elsif w.is_a?(Numeric)
        check_res FFI.nlopt_set_x_weights1(@opt, w)
      else
        raise TypeError, "expected array or numeric"
      end
    end

    def x_weights
      out_dptr { |ptr| FFI.nlopt_get_x_weights(@opt, ptr) }
    end

    def set_maxeval(maxeval)
      check_res FFI.nlopt_set_maxeval(@opt, maxeval)
    end

    def maxeval
      FFI.nlopt_get_maxeval(@opt)
    end

    def set_maxtime(maxtime)
      check_res FFI.nlopt_set_maxtime(@opt, maxtime)
    end

    def maxtime
      FFI.nlopt_get_maxtime(@opt)
    end

    def numevals
      FFI.nlopt_get_numevals(@opt)
    end

    def set_param(name, val)
      check_res FFI.nlopt_set_param(@opt, +name, val)
    end

    def param(name, defaultval)
      FFI.nlopt_get_param(@opt, +name, defaultval)
    end

    def has_param?(name)
      FFI.nlopt_has_param(@opt, +name) == 1
    end

    def num_params
      FFI.nlopt_num_params(@opt)
    end

    def nth_param(n)
      ptr = FFI.nlopt_nth_param(@opt, n)
      !ptr.null? ? ptr.to_s : nil
    end

    def optimize(init)
      x = alloc_dptr(init)
      opt_f = Fiddle::Pointer.malloc(Fiddle::SIZEOF_DOUBLE, Fiddle::RUBY_FREE)
      res = FFI.nlopt_optimize(@opt, x, opt_f)

      if res < 0 && res != -4
        errmsg = FFI.nlopt_get_errmsg(@opt)
        msg = !errmsg.null? ? errmsg.to_s : "Bad result: #{FFI.nlopt_result_to_string(res)}"
        raise Error, msg
      end

      @last_optimum_value = read_dptr(opt_f)[0]

      read_dptr(x)
    end

    def force_stop
      check_res FFI.nlopt_force_stop(@opt)
    end

    def set_local_optimizer(local_opt)
      check_res FFI.nlopt_set_local_optimizer(@opt, local_opt)
    end

    def set_initial_step(dx)
      if dx.is_a?(Array)
        check_res FFI.nlopt_set_initial_step(@opt, alloc_dptr(dx))
      elsif dx.is_a?(Numeric)
        check_res FFI.nlopt_set_initial_step1(@opt, dx)
      else
        raise TypeError, "expected array or numeric"
      end
    end

    def initial_step(x)
      out_dptr { |ptr| FFI.nlopt_get_initial_step(@opt, alloc_dptr(x), ptr) }
    end

    def set_population(pop)
      check_res FFI.nlopt_set_population(@opt, pop)
    end

    def population
      FFI.nlopt_get_population(@opt)
    end

    def set_vector_storage(dim)
      check_res FFI.nlopt_set_vector_storage(@opt, dim)
    end

    def vector_storage
      FFI.nlopt_get_vector_storage(@opt)
    end

    def to_ptr
      @opt
    end

    private

    def check_res(res)
      if res != 1
        raise Error, "Bad result: #{FFI.nlopt_result_to_string(res)}"
      end
    end

    def alloc_dptr(arr)
      n = dimension
      if arr.size != n
        raise ArgumentError, "size does not match dimension"
      end
      Fiddle::Pointer[arr.pack("d#{n}")]
    end

    def read_dptr(ptr, size = nil)
      size ||= ptr.size
      ptr.to_str(size).unpack("d*")
    end

    def out_dptr
      ptr = Fiddle::Pointer.malloc(dimension * Fiddle::SIZEOF_DOUBLE, Fiddle::RUBY_FREE)
      res = yield ptr
      check_res res
      read_dptr(ptr)
    end

    def objective_callback(f)
     Fiddle::Closure::BlockCaller.new(Fiddle::TYPE_DOUBLE, [Fiddle::TYPE_UINT, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP]) do |n, x, gradient, func_data|
        x = read_dptr(x, n * Fiddle::SIZEOF_DOUBLE)
        grad = !gradient.null? ? Gradient.new(gradient, n) : nil
        f.call(x, grad)
      end
    end
  end
end
