#ifndef CEC_COV_H
#define CEC_COV_H

#include "vec.h"
#include "common.h"

namespace cec {

    class mean: public vec {
    public:
        explicit mean(const mat &sample)
                : mean(sample.n) {
            for (auto &&p : sample) add_point(p, 1.0);
            update();
        }

        explicit mean(int n)
                : vec(n),
                  acc(n) {
            acc.fill(0);
        }

        mean(const mean &initial) = default;

        mean(mean &&initial) noexcept = default;

        mean &operator=(const mean &m) = default;

        void add_point(const row &point, double w) {
            for (int i = 0; i < size; i++)
                acc[i] += w * point[i];
            W += w;
            car++;
        }

        void rem_point(const row &point, double w) {
            for (int i = 0; i < size; i++)
                acc[i] -= w * point[i];
            W -= w;
            car--;
        }

        void update() {
            row::operator=(acc);
            if (W > 0.0)
                (*this) /= W;
        }

        int card() const {
            return car;
        }

        double weight_sum() const {
            return W;
        }

    private:
        using row::operator=;
        int car = 0;
        double W = 0.0;
        vec acc;
    };

    class covariance: public mat {
    public:
        covariance &operator=(const covariance &cov) = default;

        covariance(const covariance &) = default;

        covariance(covariance &&) noexcept = default;

        const cec::mean& mean() const {
            return mn;
        }

        int card() const {
            return mn.card();
        }

        double weight_sum() const {
            return mn.weight_sum();
        }

        static covariance estimate(const mat &sample, const vector<double> &weights) {
            cec::mean mn(sample.n);
            int idx = 0;
            for (auto &&p : sample) mn.add_point(p, weights[idx++]);
            mn.update();
            int n = sample.n;
            mat acc(n, n);
            acc.fill(0);
            vec t_vec(n);
            double W = mn.weight_sum();
            idx = 0;
            for (auto &&p : sample) {
                t_vec = p;
                t_vec -= mn;
                double w = weights[idx++];
                for (int j = 0; j < n; j++)
                    for (int k = 0; k < n; k++)
                        acc[j][k] += w * t_vec[j] * t_vec[k];
            }
            if (W > 0.0)
                acc /= W;
            return covariance(acc, mn);
        }

        void add_point(const row &point, double w) {
            double W = mn.weight_sum();
            double W_n = W + w;
            // W_n ~ 0 means both the cluster's prior weight and this point's
            // weight are ~0 (e.g. a brand-new cluster receiving a legitimate
            // zero-weight "excluded" observation first). There is no
            // meaningful covariance contribution to fold in, so leave the
            // covariance matrix as-is rather than dividing by ~0.
            if (W_n > W * 1e-9)
                cov_change(point, W / W_n, W * w / (W_n * W_n), *this);
            mn.add_point(point, w);
            mn.update();
        }

        void rem_point(const row &point, double w) {
            double W = mn.weight_sum();
            double W_n = W - w;
            // W is accumulated incrementally across many add_point/rem_point
            // calls, so a "last point in the cluster" removal can leave a
            // tiny positive residual instead of an exact zero. A relative
            // tolerance catches that residual without misclassifying a
            // genuinely small remaining weight.
            if (W_n <= W * 1e-9) {
                fill(m::QNAN);
                return;
            }
            cov_change(point, W / W_n, -W * w / (W_n * W_n), *this);
            mn.rem_point(point, w);
            mn.update();
        }

    protected:
        cec::mean mn;

        covariance(mat initial, cec::mean mn)
                : mat(std::move(initial)),
                  mn(std::move(mn)) {}

        inline void cov_change(const row &point, double cov_mul,
                               double new_cov_point_mul, mat &dst) {
            for (int j = 0; j < n; j++)
                for (int k = 0; k < n; k++)
                    dst[j][k] = (*this)[j][k] * cov_mul
                                + (mn[j] - point[j])
                                  * (mn[k] - point[k])
                                  * new_cov_point_mul;
        }
    };
}
#endif //CEC_COV_H
