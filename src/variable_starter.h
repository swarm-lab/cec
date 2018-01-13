#ifndef CEC_VARIABLE_STARTER_H
#define CEC_VARIABLE_STARTER_H

#include "multi_starter.h"

namespace cec {

    struct variable_starter_params {
        multi_starter_params ms_params;
        vector<int> centers_number;

        variable_starter_params(const multi_starter_params &msp, vector<int> centers_number)
                : ms_params(msp),
                  centers_number(std::move(centers_number)) {}
    };

    class variable_starter {
    public:
        unique_ptr<clustering_results>
        start(const mat &x, model_specs m_specs, initializer_spec init_spec,
              const variable_starter_params &params);

    private:
        multi_starter ms;
    };
}

#endif //CEC_VARIABLE_STARTER_H