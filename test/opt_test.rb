require_relative "test_helper"

class OptTest < Minitest::Test
  def test_lib_version
    assert_match(/\A\d+\.\d+\.\d+\z/, NLopt.lib_version)
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

    opt.set_upper_bounds(4)
    assert_equal [4, 4], opt.upper_bounds
    assert_elements_in_delta [4, 4], opt.optimize([2, 3])

    opt.set_upper_bounds([3, 4])
    assert_equal [3, 4], opt.upper_bounds
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
