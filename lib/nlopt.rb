# stdlib
require "fiddle/import"

# modules
require_relative "nlopt/gradient"
require_relative "nlopt/opt"
require_relative "nlopt/version"

module NLopt
  class Error < StandardError; end

  class << self
    attr_accessor :ffi_lib
  end
  lib_name =
    if Gem.win_platform?
      # TODO test
      ["nlopt.dll"]
    elsif RbConfig::CONFIG["host_os"] =~ /darwin/i
      if RbConfig::CONFIG["host_cpu"] =~ /arm|aarch64/i
        ["libnlopt.dylib", "/opt/homebrew/lib/libnlopt.dylib"]
      else
        ["libnlopt.dylib"]
      end
    else
      # libnlopt-dev has libnlopt.so
      # libnlopt0 has libnlopt.so.0
      ["libnlopt.so", "libnlopt.so.0"]
    end
  self.ffi_lib = lib_name

  # friendlier error message
  autoload :FFI, "nlopt/ffi"

  def self.lib_version
    major, minor, bugfix = 3.times.map { Fiddle::Pointer.malloc(Fiddle::SIZEOF_INT, Fiddle::RUBY_FREE) }
    FFI.nlopt_version(major, minor, bugfix)
    [major, minor, bugfix].map { |v| v.to_s(v.size).unpack1("i") }.join(".")
  end

  def self.srand(seed)
    FFI.nlopt_srand(seed)
  end

  def self.srand_time
    FFI.nlopt_srand_time
  end

  def self.version_major
    lib_version.split(".")[0].to_i
  end

  def self.version_minor
    lib_version.split(".")[1].to_i
  end

  def self.version_bugfix
    lib_version.split(".")[2].to_i
  end
end
