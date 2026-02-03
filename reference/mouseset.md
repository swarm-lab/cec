# Mouse

`mouseset` generates a cluster of points uniformly distributed inside a
"mouse head" shape.

## Usage

``` r
mouseset(
  n = 4000,
  r.head = 2,
  r.left.ear = 1.1,
  r.right.ear = 1.1,
  left.ear.dist = 2.5,
  right.ear.dist = 2.5,
  dim = 2
)
```

## Arguments

- n:

  The number of points (default: 4000).

- r.head:

  The radius of the mouse's head (default: 2).

- r.left.ear, r.right.ear:

  The radii of the left and right ear of the mouse's head (default:
  1.1).

- left.ear.dist, right.ear.dist:

  The distance between the center of the mouse's head and the center of
  the left and right ear (default: 2.5).

- dim:

  The dimensionality of the mouse's head (default: 2).

## Value

A matrix with `n` rows and `dim` columns.

## Examples

``` r
plot(mouseset())

```
