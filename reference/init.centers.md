# Cluster Center Initialization

`init.centers` automatically initializes the centers of the clusters
before running the Cross-Entropy Clustering algorithm.

## Usage

``` r
init.centers(x, k, method = c("kmeans++", "random"))
```

## Arguments

- x:

  A numeric matrix of data. Each row corresponds to a distinct
  observation; each column corresponds to a distinct variable/dimension.
  It must not contain `NA` values.

- k:

  An integer indicating the number of cluster centers to initialize.

- method:

  A character string indicating the initialization method to use. It can
  take the following values:

  "kmeans++":

  :   the centers are selected using the k-means++ algorithm.

  "random":

  :   the centers are randomly selected among the values in `x`

## Value

A matrix with `k` rows and `ncol(x)` columns.

## References

Arthur, D., & Vassilvitskii, S. (2007). k-means++: the advantages of
careful seeding. Proceedings of the Eighteenth Annual ACM-SIAM Symposium
on Discrete Algorithms, 1027–1035.

## Examples

``` r
## See the examples provided with the cec() function.
```
