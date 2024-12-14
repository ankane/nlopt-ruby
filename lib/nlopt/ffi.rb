module NLopt
  module FFI
    extend Fiddle::Importer

    libs = Array(NLopt.ffi_lib).dup
    begin
      dlload Fiddle.dlopen(libs.shift)
    rescue Fiddle::DLError => e
      retry if libs.any?
      raise e
    end

    # https://github.com/stevengj/nlopt/blob/master/src/api/nlopt.h

    typealias "nlopt_algorithm", "int"
    typealias "nlopt_func", "void *"
    typealias "nlopt_opt", "void *"
    typealias "nlopt_result", "int"
    typealias "unsigned", "unsigned int"

    extern "const char * nlopt_algorithm_name(nlopt_algorithm a)"
    extern "const char * nlopt_algorithm_to_string(nlopt_algorithm algorithm)"
    extern "nlopt_algorithm nlopt_algorithm_from_string(const char *name)"

    extern "const char * nlopt_result_to_string(nlopt_result algorithm)"

    extern "void nlopt_version(int *major, int *minor, int *bugfix)"

    extern "nlopt_opt nlopt_create(nlopt_algorithm algorithm, unsigned n)"
    extern "void nlopt_destroy(nlopt_opt opt)"
    extern "nlopt_opt nlopt_copy(const nlopt_opt opt)"

    extern "nlopt_result nlopt_optimize(nlopt_opt opt, double *x, double *opt_f)"

    extern "nlopt_result nlopt_set_min_objective(nlopt_opt opt, nlopt_func f, void *f_data)"
    extern "nlopt_result nlopt_set_max_objective(nlopt_opt opt, nlopt_func f, void *f_data)"

    extern "nlopt_algorithm nlopt_get_algorithm(const nlopt_opt opt)"
    extern "unsigned nlopt_get_dimension(const nlopt_opt opt)"
    extern "const char * nlopt_get_errmsg(nlopt_opt opt)"

    extern "nlopt_result nlopt_set_lower_bounds(nlopt_opt opt, const double *lb)"
    extern "nlopt_result nlopt_set_lower_bounds1(nlopt_opt opt, double lb)"
    extern "nlopt_result nlopt_set_lower_bound(nlopt_opt opt, int i, double lb)"
    extern "nlopt_result nlopt_get_lower_bounds(const nlopt_opt opt, double *lb)"
    extern "nlopt_result nlopt_set_upper_bounds(nlopt_opt opt, const double *ub)"
    extern "nlopt_result nlopt_set_upper_bounds1(nlopt_opt opt, double ub)"
    extern "nlopt_result nlopt_set_upper_bound(nlopt_opt opt, int i, double ub)"
    extern "nlopt_result nlopt_get_upper_bounds(const nlopt_opt opt, double *ub)"

    extern "nlopt_result nlopt_set_maxeval(nlopt_opt opt, int maxeval)"
    extern "int nlopt_get_maxeval(const nlopt_opt opt)"

    extern "int nlopt_get_numevals(const nlopt_opt opt)"
  end
end
