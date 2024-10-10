# CEC v0.11.2

## New features

* N/A. 

## Minor improvements and fixes

* Fixing CRAN NO_REMAP error with R > 4.5.0. 

---

# CEC v0.11.1

## New features

* N/A. 

## Minor improvements and fixes

* Fixing new CRAN check errors. 

---

# CEC v0.11.0

## New features

* New maintainer. 
* New logo. 

## Minor improvements and fixes

* Refactoring/reorganizing R code for easier maintenance. 
* Improving of documentation. 
* Moving to GitHub actions for CI instead of Travis. 

---

# CEC v0.10.3

## New features

* N/A.

## Minor improvements and fixes

* Fixing gcc-11 issues.
* Fixing other CRAN issues.

---

# CEC v0.10.2

## New features

* Adding fixed mean model.
* Adding data set: threeGaussians.

## Minor improvements and fixes

* Fixing compilation issues on some platforms.

---

# CEC v0.10.1

## New features

* Rewriting all C the code in C++11.
* Adding split method.
* Adding threads.

## Minor improvements and fixes

* N/A.

---

# CEC v0.9.4

## New features

* N/A.

## Minor improvements and fixes

* Adding README.md.
* Lots of refactoring.
* Small fixes.

---

# CEC v0.9.3

## New features

* Changing the way initial centers vector is handled: for each start, length(centers) clusterings are performed.
* Adding two datasets: fourGaussians and mixShapes.

## Minor improvements and fixes

* Giving up support of -1 iterations (fixing memcheck problems).

---

# CEC v0.9.2

## New features

* N/A

## Minor improvements and fixes

* Checking input data for NA values (session crushing).
* Changing 'ZERO_EPSILON' to '1.0e-32'.
* Lots of refactoring.

# CEC v0.9.1

Initial Release.
