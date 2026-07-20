# --- nballvolume() -----------------------------------------------------------
# Closed-form n-ball volume, checked against known formulas.

test_that("nballvolume.matches.known.closed.form.values", {
    r <- 2.5
    expect_equal(CEC:::nballvolume(r, 1), 2 * r)                       # 1D: length 2r
    expect_equal(CEC:::nballvolume(r, 2), pi * r^2)                    # 2D: disc area
    expect_equal(CEC:::nballvolume(r, 3), (4 / 3) * pi * r^3)          # 3D: sphere volume
    expect_equal(CEC:::nballvolume(r, 4), (pi^2 / 2) * r^4)            # 4D
})

# --- mouseset() ---------------------------------------------------------------

test_that("mouseset.output.shape.matches.n.and.dim", {
    set.seed(1)
    M <- mouseset(n = 300)
    expect_equal(dim(M), c(300, 2))
})

test_that("mouseset.errors.on.dim.below.two", {
    expect_error(mouseset(dim = 1), "'dim' must be strictly greater than 1")
})

test_that("mouseset.points.fall.within.one.of.the.three.lobes", {
    set.seed(2)
    r.head <- 2
    r.left.ear <- 1.1
    r.right.ear <- 1.1
    left.ear.dist <- 2.5
    right.ear.dist <- 2.5
    M <- mouseset(n = 500, r.head = r.head, r.left.ear = r.left.ear,
                  r.right.ear = r.right.ear, left.ear.dist = left.ear.dist,
                  right.ear.dist = right.ear.dist)

    offset <- left.ear.dist / sqrt(2)
    pos.h <- c(0, 0)
    pos.l <- c(-offset, offset)
    pos.r <- c(offset, offset)

    d.h <- sqrt(rowSums(sweep(M, 2, pos.h)^2))
    d.l <- sqrt(rowSums(sweep(M, 2, pos.l)^2))
    d.r <- sqrt(rowSums(sweep(M, 2, pos.r)^2))

    in.some.lobe <- (d.h <= r.head + 1e-8) | (d.l <= r.left.ear + 1e-8) | (d.r <= r.right.ear + 1e-8)
    expect_true(all(in.some.lobe))
})
