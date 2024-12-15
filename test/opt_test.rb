require_relative "test_helper"

class OptTest < Minitest::Test
  def test_lib_version
    assert_match(/\A\d+\.\d+\.\d+\z/, NLopt.lib_version)
    assert_kind_of Integer, NLopt.version_major
    assert_kind_of Integer, NLopt.version_minor
    assert_kind_of Integer, NLopt.version_bugfix
  end

  def test_algorithm_name
    opt = NLopt::Opt.new("LN_COBYLA", 2)
    assert_equal "COBYLA (Constrained Optimization BY Linear Approximations) (local, no-derivative)", opt.algorithm_name
  end

  def test_dimension
    opt = NLopt::Opt.new("LN_COBYLA", 2)
    assert_equal 2, opt.dimension
  end

  def test_set_min_objective
    opt = NLopt::Opt.new("LN_COBYLA", 2)
    f = lambda do |x, grad|
      x[0] + x[1]
    end
    opt.set_min_objective(f)

    opt.set_lower_bounds(1)
    assert_equal [1, 1], opt.lower_bounds
    assert_elements_in_delta [1, 1], opt.optimize([2, 3])

    opt.set_lower_bounds([1, 2])
    assert_equal [1, 2], opt.lower_bounds
    assert_elements_in_delta [1, 2], opt.optimize([2, 3])
  end

  def test_set_max_objective
    opt = NLopt::Opt.new("LN_COBYLA", 2)
    f = lambda do |x, grad|
      x[0] + x[1]
    end
    opt.set_max_objective(f)
    opt.set_maxeval(100)
    assert_equal 100, opt.maxeval

    opt.set_upper_bounds(4)
    assert_elements_in_delta [4, 4], opt.optimize([2, 3])

    opt.set_upper_bounds([3, 4])
    assert_elements_in_delta [3, 4], opt.optimize([2, 3])
  end

  def test_no_objective
    opt = NLopt::Opt.new("LN_COBYLA", 2)
    error = assert_raises(NLopt::Error) do
      opt.optimize([0, 0])
    end
    assert_equal "NULL args to nlopt_optimize", error.message
  end

  def test_gradient
    opt = NLopt::Opt.new("LD_LBFGS", 2)
    f = lambda do |x, grad|
      grad[0] = 2 * x[0]
      grad[1] = 2 * x[1]
      assert_raises(IndexError) do
        grad[2] = 1
      end

      assert_equal 2 * x[0], grad[0]
      assert_equal 2 * x[1], grad[1]
      assert_raises(IndexError) do
        grad[2]
      end

      x[0] * x[0] + x[1] * x[1]
    end
    opt.set_min_objective(f)
    assert_elements_in_delta [0, 0], opt.optimize([1, 1])
  end

  def test_lower_bounds
    opt = NLopt::Opt.new("LN_COBYLA", 2)

    opt.set_lower_bounds(1)
    assert_equal [1, 1], opt.lower_bounds

    opt.set_lower_bounds([1, 2])
    assert_equal [1, 2], opt.lower_bounds

    error = assert_raises(TypeError) do
      opt.set_lower_bounds(Object.new)
    end
    assert_equal "expected array or numeric", error.message

    error = assert_raises(ArgumentError) do
      opt.set_lower_bounds([1])
    end
    assert_equal "size does not match dimension", error.message
  end

  def test_upper_bounds
    opt = NLopt::Opt.new("LN_COBYLA", 2)

    opt.set_upper_bounds(1)
    assert_equal [1, 1], opt.upper_bounds

    opt.set_upper_bounds([1, 2])
    assert_equal [1, 2], opt.upper_bounds

    error = assert_raises(TypeError) do
      opt.set_upper_bounds(Object.new)
    end
    assert_equal "expected array or numeric", error.message

    error = assert_raises(ArgumentError) do
      opt.set_upper_bounds([1])
    end
    assert_equal "size does not match dimension", error.message
  end

  def test_numevals
    opt = NLopt::Opt.new("LN_COBYLA", 1)
    numevals = 0
    f = lambda do |x, grad|
      numevals += 1
      x[0] * x[0] + 1
    end
    opt.set_min_objective(f)
    opt.optimize([1])
    assert_equal numevals, opt.numevals
  end

  def test_remove_constraints
    opt = NLopt::Opt.new("LN_COBYLA", 2)
    opt.remove_inequality_constraints
    opt.remove_equality_constraints
  end

  def test_stopval
    opt = NLopt::Opt.new("LN_COBYLA", 2)
    opt.set_stopval(1)
    assert_equal 1, opt.stopval
  end

  def test_tol
    opt = NLopt::Opt.new("LN_COBYLA", 2)

    opt.set_ftol_rel(1)
    assert_equal 1, opt.ftol_rel

    opt.set_ftol_abs(2)
    assert_equal 2, opt.ftol_abs

    opt.set_xtol_rel(3)
    assert_equal 3, opt.xtol_rel

    opt.set_xtol_abs(4)
    assert_equal [4, 4], opt.xtol_abs

    opt.set_xtol_abs([5, 6])
    assert_equal [5, 6], opt.xtol_abs
  end

  def test_x_weights
    opt = NLopt::Opt.new("LN_COBYLA", 2)

    opt.set_x_weights(1)
    assert_equal [1, 1], opt.x_weights

    opt.set_x_weights([1, 2])
    assert_equal [1, 2], opt.x_weights
  end

  def test_maxtime
    opt = NLopt::Opt.new("LN_COBYLA", 2)
    opt.set_maxtime(1)
    assert_equal 1, opt.maxtime
  end

  def test_params
    opt = NLopt::Opt.new("LN_COBYLA", 2)
    assert_equal 0, opt.num_params
    assert_equal false, opt.has_param?("name")
    assert_equal 1, opt.param("name", 1)
    opt.set_param("name", 2)
    assert_equal true, opt.has_param?("name")
    assert_equal 2, opt.param("name", 1)
    assert_equal 1, opt.num_params
    assert_equal "name", opt.nth_param(0)
    assert_nil opt.nth_param(1)
  end

  def test_initial_step
    opt = NLopt::Opt.new("LN_COBYLA", 2)
    opt.set_initial_step(1)
    opt.set_initial_step([1, 2])
  end

  def test_population
    opt = NLopt::Opt.new("LN_COBYLA", 2)
    opt.set_population(1)
    assert_equal 1, opt.population
  end

  def test_vector_storage
    opt = NLopt::Opt.new("LN_COBYLA", 2)
    opt.set_vector_storage(1)
    assert_equal 1, opt.vector_storage
  end

  def test_srand
    NLopt.srand(42)
    NLopt.srand_time
  end

  def test_invalid_args
    opt = NLopt::Opt.new("LN_COBYLA", 2)
    f = lambda do |x, grad|
      x[0] + x[1]
    end
    opt.set_lower_bounds(1)
    opt.set_min_objective(f)
    error = assert_raises(NLopt::Error) do
      opt.optimize([0, 0])
    end
    assert_equal "bounds 0 fail 1 <= 0 <= inf", error.message
  end

  def test_invalid_algorithm
    error = assert_raises(ArgumentError) do
      NLopt::Opt.new("BAD", 1)
    end
    assert_equal "Invalid algorithm", error.message
  end

  def test_invalid_dimension
    error = assert_raises(ArgumentError) do
      NLopt::Opt.new("LN_COBYLA", -1)
    end
    assert_equal "Invalid dimension", error.message
  end
end
