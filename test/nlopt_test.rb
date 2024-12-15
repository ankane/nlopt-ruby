require_relative "test_helper"

class NLoptTest < Minitest::Test
  def test_lib_version
    assert_match(/\A\d+\.\d+\.\d+\z/, NLopt.lib_version)
    assert_kind_of Integer, NLopt.version_major
    assert_kind_of Integer, NLopt.version_minor
    assert_kind_of Integer, NLopt.version_bugfix
  end

  def test_srand
    NLopt.srand(42)
    NLopt.srand_time
  end
end
