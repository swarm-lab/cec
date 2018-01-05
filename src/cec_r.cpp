#include "cec_r.h"
#include "r_utils.h"
#include "cec_params.h"
#include "cec_params_r.h"
#include "single_start_input.h"
#include "init.h"
#include "cec_starter.h"
#include "result_r.h"

using namespace cec;
using namespace cec::r;

extern "C"
SEXP cec_r(SEXP x, SEXP centers_param_r, SEXP control_param_r, SEXP models_param_r) {

    r_ext_ptr<single_start_results> start_results;
    try {
        mat x_mat = get<mat>(x);
        int n = x_mat.n;

        centers_param centers_par = get_centers_param(centers_param_r);
        control_param control_par = get_control_param(control_param_r);
        models_param models_par = get_models_param(models_param_r, n);

        int k = centers_par.var_centers[0];
        mat c_mat = centers_par.init_m == init_method::NONE
                    ? centers_par.centers_mat
                    : random_init().init(x_mat, k);

        const std::vector<int> &asgn = closest_assignment().init(x_mat, c_mat);
        std::vector<std::unique_ptr<model>> models(k);

        std::transform(models_par.specs.begin(), models_par.specs.end(), models.begin(),
                       [&](const std::shared_ptr<cec::model_spec> &spec) {
                           return spec->create_model();
                       });

        single_start_input in(x_mat, c_mat, asgn, models, control_par.max_iterations, control_par.min_card);
        cec_starter starter(n);

        const single_start_results &results = starter.start(in);
        start_results.reset(new single_start_results(results));

    } catch (std::exception &ex) {
        error(ex.what());
    }

    try {
        SEXP r_res;
        PROTECT(r_res = create_R_result(*start_results));
        UNPROTECT(1);
        return r_res;
    } catch (std::exception &ex) {
        error(ex.what());
    }
}

extern "C"
SEXP cec_init_centers_r(SEXP x_r, SEXP k_r, SEXP method_r) {
    return put(random_init().init(get<mat>(x_r), get<int>(k_r)));
}