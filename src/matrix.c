#include "alloc.h"
#include "matrix.h"
#include "matrix_utils.h"

void cec_matrix_set(struct cec_matrix * m, double val)
{
    array_fill(m->data, val, m->m * m->n);
}

void cec_matrix_mul(struct cec_matrix * m, double val)
{
    array_mul(m->data, val, m->m * m->n);
}

void cec_matrix_add(struct cec_matrix * m1, const struct cec_matrix * m2)
{
    array_add(m1->data, m2->data, m1->m * m1->n);
}

void cec_matrix_sub(struct cec_matrix * m1, const struct cec_matrix * m2)
{
    array_sub(m1->data, m2->data, m1->m * m1->n);
}

void cec_matrix_sum_multiplied(const struct cec_matrix * m1,
	const struct cec_matrix * m2, struct cec_matrix * dest, double a1,
	double a2)
{
    array_sum_multiplied(dest->data, m1->data, a1, m2->data, a2, m1->m * m1->n);
}

void cec_matrix_copy_data(const struct cec_matrix * from,
	struct cec_matrix * to)
{
    array_copy(from->data, to->data, from->m * from->n);
}

struct cec_matrix * cec_matrix_create(int m, int n)
{
    struct cec_matrix * mat = (struct cec_matrix *) m_alloc(
	    sizeof (struct cec_matrix) + sizeof (double) * m * n);
    if (mat == NULL)
	return NULL;
    mat->data = (double *) (mat + 1);
    mat->m = m;
    mat->n = n;
    return mat;
}

void cec_matrix_destroy(struct cec_matrix * m)
{
    m_free(m);
}
