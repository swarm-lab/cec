#ifndef CEC_PARAMS_H
#define CEC_PARAMS_H

#include "vec.h"
#include "models/model.h"
#include "models/all.h"

namespace cec {
    enum class init_method {
        NONE,
        KMEANSPP,
        RANDOM
    };

    enum class model_type {
        ALL, COVARIANCE, DIAGONAL, EIGENVALUES, FIXED_R, SPHERICAL
    };

    init_method parse_init_method(const std::string &method);

    model_type parse_model_type(const std::string &name);

    struct centers_param {
        init_method init_m;
        mat centers_mat;
        std::vector<int> var_centers;

        centers_param(init_method init_m, mat centers_mat, std::vector<int> var_centers)
                : init_m(init_m),
                  centers_mat(std::move(centers_mat)),
                  var_centers(std::move(var_centers)) {}
    };

    struct control_param {
        int starts;
        int max_iterations;
        int min_card;
        int threads;

        control_param(int starts, int max_iter, int min_card, int threads) :
                starts(starts),
                max_iterations(max_iter),
                min_card(min_card),
                threads(threads) {}
    };

    class model_spec {
    public:
        const model_type type;

        virtual const model &create_model() = 0;

        explicit model_spec(const model_type type)
                : type(type) {}
    };

    class model_all_spec : public model_spec {
    public:
        const int n;

        explicit model_all_spec(int n)
                : model_spec(model_type::ALL),
                  n(n) {}

        const model &create_model() override {
            return all(n);
        }
    };

    class models_param {
        const std::vector<std::shared_ptr<model_spec>> specs;
    public:
        explicit models_param(std::vector<std::shared_ptr<model_spec>> specs)
                : specs(std::move(specs)) {}
    };
}
#endif //CEC_PARAMS_H
