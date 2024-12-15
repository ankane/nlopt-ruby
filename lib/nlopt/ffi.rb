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
    typealias "nlopt_mfunc", "void *"
    typealias "nlopt_opt", "void *"
    typealias "nlopt_precond", "void *"
    typealias "nlopt_result", "int"
    typealias "unsigned", "unsigned int"

    extern "const char * nlopt_algorithm_name(nlopt_algorithm a)"
    extern "const char * nlopt_algorithm_to_string(nlopt_algorithm algorithm)"
    extern "nlopt_algorithm nlopt_algorithm_from_string(const char *name)"

    extern "const char * nlopt_result_to_string(nlopt_result algorithm)"

    extern "void nlopt_srand(unsigned long seed)"
    extern "void nlopt_srand_time(void)"

    extern "void nlopt_version(int *major, int *minor, int *bugfix)"

    # object-oriented api

    extern "nlopt_opt nlopt_create(nlopt_algorithm algorithm, unsigned n)"
    extern "void nlopt_destroy(nlopt_opt opt)"
    extern "nlopt_opt nlopt_copy(const nlopt_opt opt)"

    extern "nlopt_result nlopt_optimize(nlopt_opt opt, double *x, double *opt_f)"

    extern "nlopt_result nlopt_set_min_objective(nlopt_opt opt, nlopt_func f, void *f_data)"
    extern "nlopt_result nlopt_set_max_objective(nlopt_opt opt, nlopt_func f, void *f_data)"

    extern "nlopt_algorithm nlopt_get_algorithm(const nlopt_opt opt)"
    extern "unsigned nlopt_get_dimension(const nlopt_opt opt)"
    extern "const char * nlopt_get_errmsg(nlopt_opt opt)"

    # generic algorithm parameters

    extern "nlopt_result nlopt_set_param(nlopt_opt opt, const char *name, double val)"
    extern "double nlopt_get_param(const nlopt_opt opt, const char *name, double defaultval)"
    extern "int nlopt_has_param(const nlopt_opt opt, const char *name)"
    extern "unsigned nlopt_num_params(const nlopt_opt opt)"
    extern "const char * nlopt_nth_param(const nlopt_opt opt, unsigned n)"

    # constraints

    extern "nlopt_result nlopt_set_lower_bounds(nlopt_opt opt, const double *lb)"
    extern "nlopt_result nlopt_set_lower_bounds1(nlopt_opt opt, double lb)"
    extern "nlopt_result nlopt_set_lower_bound(nlopt_opt opt, int i, double lb)"
    extern "nlopt_result nlopt_get_lower_bounds(const nlopt_opt opt, double *lb)"
    extern "nlopt_result nlopt_set_upper_bounds(nlopt_opt opt, const double *ub)"
    extern "nlopt_result nlopt_set_upper_bounds1(nlopt_opt opt, double ub)"
    extern "nlopt_result nlopt_set_upper_bound(nlopt_opt opt, int i, double ub)"
    extern "nlopt_result nlopt_get_upper_bounds(const nlopt_opt opt, double *ub)"

    extern "nlopt_result nlopt_remove_inequality_constraints(nlopt_opt opt)"
    extern "nlopt_result nlopt_add_inequality_constraint(nlopt_opt opt, nlopt_func fc, void *fc_data, double tol)"
    extern "nlopt_result nlopt_add_precond_inequality_constraint(nlopt_opt opt, nlopt_func fc, nlopt_precond pre, void *fc_data, double tol)"
    extern "nlopt_result nlopt_add_inequality_mconstraint(nlopt_opt opt, unsigned m, nlopt_mfunc fc, void *fc_data, const double *tol)"

    extern "nlopt_result nlopt_remove_equality_constraints(nlopt_opt opt)"
    extern "nlopt_result nlopt_add_equality_constraint(nlopt_opt opt, nlopt_func h, void *h_data, double tol)"
    extern "nlopt_result nlopt_add_precond_equality_constraint(nlopt_opt opt, nlopt_func h, nlopt_precond pre, void *h_data, double tol)"
    extern "nlopt_result nlopt_add_equality_mconstraint(nlopt_opt opt, unsigned m, nlopt_mfunc h, void *h_data, const double *tol)"

    # stopping criteria

    extern "nlopt_result nlopt_set_stopval(nlopt_opt opt, double stopval)"
    extern "double nlopt_get_stopval(const nlopt_opt opt)"

    extern "nlopt_result nlopt_set_ftol_rel(nlopt_opt opt, double tol)"
    extern "double nlopt_get_ftol_rel(const nlopt_opt opt)"
    extern "nlopt_result nlopt_set_ftol_abs(nlopt_opt opt, double tol)"
    extern "double nlopt_get_ftol_abs(const nlopt_opt opt)"

    extern "nlopt_result nlopt_set_xtol_rel(nlopt_opt opt, double tol)"
    extern "double nlopt_get_xtol_rel(const nlopt_opt opt)"
    extern "nlopt_result nlopt_set_xtol_abs1(nlopt_opt opt, double tol)"
    extern "nlopt_result nlopt_set_xtol_abs(nlopt_opt opt, const double *tol)"
    extern "nlopt_result nlopt_get_xtol_abs(const nlopt_opt opt, double *tol)"
    extern "nlopt_result nlopt_set_x_weights1(nlopt_opt opt, double w)"
    extern "nlopt_result nlopt_set_x_weights(nlopt_opt opt, const double *w)"
    extern "nlopt_result nlopt_get_x_weights(const nlopt_opt opt, double *w)"

    extern "nlopt_result nlopt_set_maxeval(nlopt_opt opt, int maxeval)"
    extern "int nlopt_get_maxeval(const nlopt_opt opt)"

    extern "int nlopt_get_numevals(const nlopt_opt opt)"

    extern "nlopt_result nlopt_set_maxtime(nlopt_opt opt, double maxtime)"
    extern "double nlopt_get_maxtime(const nlopt_opt opt)"

    extern "nlopt_result nlopt_force_stop(nlopt_opt opt)"
    extern "nlopt_result nlopt_set_force_stop(nlopt_opt opt, int val)"
    extern "int nlopt_get_force_stop(const nlopt_opt opt)"

    # more algorithm-specific parameters

    extern "nlopt_result nlopt_set_local_optimizer(nlopt_opt opt, const nlopt_opt local_opt)"

    extern "nlopt_result nlopt_set_population(nlopt_opt opt, unsigned pop)"
    extern "unsigned nlopt_get_population(const nlopt_opt opt)"

    extern "nlopt_result nlopt_set_vector_storage(nlopt_opt opt, unsigned dim)"
    extern "unsigned nlopt_get_vector_storage(const nlopt_opt opt)"

    extern "nlopt_result nlopt_set_default_initial_step(nlopt_opt opt, const double *x)"
    extern "nlopt_result nlopt_set_initial_step(nlopt_opt opt, const double *dx)"
    extern "nlopt_result nlopt_set_initial_step1(nlopt_opt opt, double dx)"
    extern "nlopt_result nlopt_get_initial_step(const nlopt_opt opt, const double *x, double *dx)"
  end
end
