#ifndef CEC_CLUSTER_H
#define CEC_CLUSTER_H

#include "vec.h"
#include "models/model.h"

namespace cec {

    class mean : public vec {
    public:
        explicit mean (const mat &sample): mean(sample.n) {
            for (auto &&p : sample) add_point(p);
            update();
         }

        mean(const mean &initial) = default;
        mean(mean && initial) noexcept = default;

        explicit mean(int n) : vec(n), acc_(n) {
            acc_.fill(0);
            fill(0);
        }

        mean &operator=(const mean &m) = default;

        void add_point(const vec &point) {
            acc_ += point;
            card_++;
        }

        void rem_point(const vec &point) {
            acc_ -= point;
            card_--;
        }

        void update() {
            set(acc_);
            *this /= card_;
        }

        int card() const {
            return card_;
        }

    private:
        int card_ = 0;
        vec acc_;
    };

    class cluster_utils {
    public:
        static void cec_cov_add_point(mat &dest_covariance, const mat &covariance,
                                      const mean &mean, const vec &point) {
            int card = mean.card();
            double card_n = card + 1;
            cec_cov_change(dest_covariance, covariance, mean, point, card / card_n, card / (card_n * card_n));
        }

        static void cec_cov_remove_point(mat &dest_covariance, const mat &covariance,
                                         const mean &mean, const vec &point) {
            int card = mean.card();
            double card_n = card - 1;
            cec_cov_change(dest_covariance, covariance, mean, point, card / card_n, -card / (card_n * card_n));
        }

    private:
        static inline void cec_cov_change(mat &dest_covariance, const mat &covariance,
                                          const vec &mean, const vec &point, double cov_mul,
                                          double new_cov_point_mul) {
            const int n = covariance.n;

            for (int j = 0; j < n; j++)
                for (int k = 0; k < n; k++)
                    dest_covariance[j][k] = covariance[j][k] * cov_mul
                                 + (mean[j] - point[j]) * (mean[k] - point[k]) * new_cov_point_mul;

        }
    };

    class covariance_mle {
    public:
        static mat estimate(const mat &sample, const mean &mean) {
            int n = sample.n;
            mat acc(n, n);
            acc.fill(0);
            vec t_vec(acc.n);
            for (auto &&p : sample) {
                t_vec = p;
                t_vec -= mean;
                acc += mat::outer_product(t_vec);
            }
            acc /= sample.m;
            return acc;
        }
    };

    class cluster {

    public:
        cluster(const model &mod, mean initial_mean, mat initial_covariance, const int m) :
                m_(m),
                model_(mod),
                mean_(std::move(initial_mean)),
                cov_(std::move(initial_covariance)),
                t_cov_(cov_),
                t_point_(initial_mean.n),
                energy_(mod.energy(cov_, mean_.card(), m))
        {}

        double add_point(const vec &point) {
            t_point_ = point;
            card_change_ = 1;
            cluster_utils::cec_cov_add_point(t_cov_, cov_, mean_, point);
            t_energy_ = t_energy();
            return t_energy_ - energy_;
        }

        double rem_point(const vec &point) {
            t_point_ = point;
            card_change_ = -1;
            cluster_utils::cec_cov_remove_point(t_cov_, cov_, mean_, point);
            t_energy_ = t_energy();
            return t_energy_ - energy_;

        }

        const vec& mean() const {
            return mean_;
        }

        int card() const {
            return mean_.card();
        }

        const mat& covariance() const {
            return cov_;
        }

        void apply_change() {
            cov_ = t_cov_;
            if (card_change_ == 1)
                mean_.add_point(t_point_);
            else
                mean_.rem_point(t_point_);
            mean_.update();
            energy_ = t_energy_;
        }

        double energy() {
            return model_.energy(cov_, mean_.card(), m_);
        }

    private:
        double t_energy() {
            return model_.energy(t_cov_, mean_.card() + card_change_, m_);
        }
        const int m_;
        const model &model_;
        cec::mean mean_;
        mat cov_;
        mat t_cov_;
        vec t_point_;
        double energy_;
        double t_energy_;
        int card_change_ = 0;
    };


}

#endif //CEC_CLUSTER_H