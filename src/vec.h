#ifndef VEC_H
#define VEC_H

#include <algorithm>
#include <iostream>
#include <memory>

namespace cec {
    class mat;

    class vec {
    public:
        const int n;

        explicit vec(int n) : n(n), data_(new double[n]), data_wrapper_(data_) {};

        vec(vec &&v) noexcept = default;

        vec(const vec &v) : vec(v.n) {
            this->set(v);
        }

        vec(std::initializer_list<double> vals) : vec(vals.size()) {
            double *ptr = data_;
            auto it = vals.begin();
            auto end = vals.end();
            while (it != end)
                *ptr++ = *it++;
        }

        double &operator[](int idx) {
            return data_[idx];
        }

        const double &operator[](int idx) const {
            return data_[idx];
        }

        void fill(double value) {
            std::fill(data_, data_ + n, value);
        }

        void set(const vec &v) {
            this->operator=(v);
        }

        vec &operator=(const vec &v) {
            std::copy(v.data_, v.data_ + v.n, data_);
            return *this;
        }

        void operator*=(double value) {
            for (int i = 0; i < n; i++)
                data_[i] *= value;
        }

        void operator/=(double value) {
            for (int i = 0; i < n; i++)
                data_[i] /= value;
        }

        void operator+=(const vec &v) {
            for (int i = 0; i < n; i++)
                data_[i] += v[i];
        }

        void operator-=(const vec &v) {
            for (int i = 0; i < n; i++)
                data_[i] -= v[i];
        }

        double *data() {
            return data_;
        }

        const double *data() const {
            return data_;
        }

        friend std::ostream &operator<<(std::ostream &os, const vec &v) {
            os << "{";
            for (int i = 0; i < v.n; i++)
                os << v[i] << (i == v.n - 1 ? "}" : ", ");
            return os;
        }

        static double dist(const vec& a, const vec& b) {
            double acc = 0;
            for (int i = 0; i < a.n; i++) {
                double diff = b[i] - a[i];
                acc += diff * diff;
            }
            return acc;
        }

    private:
        friend class mat;

        vec(double *ptr, int n) : n(n), data_(ptr) {}

        double *data_;
        std::unique_ptr<double> data_wrapper_;
    };

    class mat : public vec {
    public:
        const int m, n;

        mat(int m, int n) : vec(m * n), m(m), n(n) {}

        mat(const mat &ma) = default;

        mat(mat &&ma) noexcept = default;

        inline const vec operator[](int idx) const {
            return const_cast<mat *>(this)->operator[](idx);
        }

        inline mat &operator=(const mat &ma) {
            vec::operator=(ma);
            return *this;
        }

        inline mat &operator=(mat &&ma) noexcept {
            vec::operator=(ma);
            return *this;
        }

        vec operator[](int idx) {
            return vec(data_ + idx * n, n);
        }

        friend std::ostream &operator<<(std::ostream &os, const mat &m) {
            for (int j = 0; j < m.m; j++) {
                os << (j == 0 ? '(' : ' ');
                for (int k = 0; k < m.n; k++)
                    os << m[j][k] << (k < m.n - 1 ? ", " : "");
                os << (j == m.m - 1 ? ')' : '\n');
            }
            return os;
        }

        template <class M>
        class rows_iterator {
            friend class mat;
        public:
            inline typename std::conditional<std::is_const<M>::value, const vec, vec>::type
            operator*() {
                return ref[row];
            }

            inline void operator++() {
                row++;
            }

            inline bool operator==(const rows_iterator &ri) {
                return row == ri.row;
            }

            inline bool operator!=(const rows_iterator &ri) {
                return !operator==(ri);
            }
        private:
            rows_iterator(M &ref, int row)
                    : ref(ref),
                      row(row) {}
            const mat &ref;
            int row;
        };

        rows_iterator<mat> begin() {
            return {*this, 0};
        }

        rows_iterator<mat> end() {
            return {*this, m};
        }

        rows_iterator<const mat> begin() const {
            return {*this, 0};
        }

        rows_iterator<const mat> end() const {
            return {*this, m};
        }

        static mat outer_product(vec &v) {
            int n = v.n;
            mat ma(n, n);
            for (int j = 0; j < n; j++)
                for (int k = 0; k < n; k++)
                    ma[j][k] = v[j] * v[k];
            return ma;
        }
    };

}

#endif /* VEC_H */
