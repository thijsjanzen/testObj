# generate some testing data (this is copied from the predict.gam example
# in the gam documentation)
n <- 200
sig <- 2
dat <- mgcv::gamSim(1,n = n, scale = sig)
b <- mgcv::gam(y~s(x0) + s(I(x1^2)) + s(x2) + offset(x3),
               data = dat)

# create some fake dataframe that might look like our future data:
newd <- data.frame(x0 = 0.5,
                   x1 = 0.5,
                   x2 = 0.5,
                   x3 = 0.5)


# use the mgcv prediction function
pred <- mgcv::predict.gam(b, newd)


# use the R function in this package (full R based)
predict_val(b, newd)

# use the walkaround via Rcpp:
predict_cpp(b, c(0.5, 0.5, 0.5, 0.5))


# note that predict_cpp only accepts an unnamed vector
# as.vector(newd) does not work (and crashes R).
# this does work:
predict_cpp(b, as.numeric(as.vector(newd)))

# all values should be the same:
all.equal(mgcv::predict.gam(b, newd)[[1]],
          predict_cpp(b, c(0.5, 0.5, 0.5, 0.5)))

# how is the speed? the walkaround via cpp is slightly slower (but not much):
a <- microbenchmark::microbenchmark(predict_val(b, newd),
                                    predict_cpp(b, c(0.5, 0.5, 0.5, 0.5)))

ggplot2::autoplot(a)
