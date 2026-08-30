#include "cec_starter.h"
#include "exceptions.h"

namespace cec {
    unique_ptr<clustering_results> cec_starter::start(const clustering_input &ip) {
        const mat &x = ip.x;
        const vector<unique_ptr<model>> &models = ip.models;
        const vector<double> &weights = ip.weights;
        int k = models.size();
        best.reset();
        for (int i = 0; i < starts; i++) {
            try {
                best(cec.start(x, closest.init(x, init->init(x, k)), models, weights));
            } catch (clustering_exception &ce) {
                // One unlucky start finding no valid clustering is non-fatal;
                // other starts still contribute.
            }
        }
        return best();
    }
}
