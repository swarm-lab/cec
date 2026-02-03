# Plot CEC Objects

`plot.cec` presents the results from the
[`cec`](https://swarm-lab.github.io/cec/reference/cec.md) function in
the form of a plot. The colors of the data points represent the cluster
they belong to. Ellipses are drawn to represent the covariance (of
either the model or the sample) of each cluster.

## Usage

``` r
# S3 method for class 'cec'
plot(
  x,
  col,
  cex = 0.5,
  pch = 19,
  cex.centers = 1,
  pch.centers = 8,
  ellipses = TRUE,
  ellipses.lwd = 4,
  ellipses.lty = 2,
  model = TRUE,
  xlab,
  ylab,
  ...
)
```

## Arguments

- x:

  A [`cec`](https://swarm-lab.github.io/cec/reference/cec.md) object
  resulting from the
  [`cec`](https://swarm-lab.github.io/cec/reference/cec.md) function.

- col:

  A specification for the default plotting color of the points in the
  clusters. See [`par`](https://rdrr.io/r/graphics/par.html) for more
  details.

- cex:

  A numerical value giving the amount by which plotting text and symbols
  should be magnified relative to the default. See
  [`par`](https://rdrr.io/r/graphics/par.html) for more details.

- pch:

  Either an integer specifying a symbol or a single character to be used
  as the default in plotting points. See
  [`par`](https://rdrr.io/r/graphics/par.html) for more details.

- cex.centers:

  The same as `cex`, except that it applies only to the centers' means.

- pch.centers:

  The same as `pch`, except that it applies only to the centers' means.

- ellipses:

  If this parameter is TRUE, covariance ellipses will be drawn.

- ellipses.lwd:

  The line width of the covariance ellipses. See `lwd` in
  [`par`](https://rdrr.io/r/graphics/par.html) for more details.

- ellipses.lty:

  The line type of the covariance ellipses. See `lty` in
  [`par`](https://rdrr.io/r/graphics/par.html) for more details.

- model:

  If this parameter is TRUE, the model (expected) covariance will be
  used for each cluster instead of the sample covariance (MLE) of the
  points in the cluster, when drawing the covariance ellipses.

- xlab:

  A label for the x axis. See
  [plot](https://rdrr.io/r/graphics/plot.default.html) for more details.

- ylab:

  A label for the y axis. See
  [plot](https://rdrr.io/r/graphics/plot.default.html) for more details.

- ...:

  Additional arguments passed to `plot` when drawing data points.

## Value

This function returns nothing.

## See also

[`cec`](https://swarm-lab.github.io/cec/reference/cec.md),
[`print.cec`](https://swarm-lab.github.io/cec/reference/print.cec.md)

## Examples

``` r
## See the examples provided with the cec() function.
```
