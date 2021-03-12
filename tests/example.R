# generate some testing data (this is copied from the predict.gam example
# in the gam documentation)
library(testObj)
n <- 20000
sig <- 2
dat <- mgcv::gamSim(1, n = n, scale = sig)
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

pars <- as.numeric(as.vector(newd))

# use the walkaround via Rcpp:
predict_cpp_with_gam_obj(b, pars)

predict_no_gam <- predict_val_2(b) # closure implementation
predict_cpp_external_closure(pars)[[1]] # this relies on the function "predict_no_gam" existing.
predict_cpp_with_closure(pars, predict_no_gam)[[1]] # this actually passes the function name

predict_local <- function(pars) {
  return(mgcv::predict.gam(b, pars))
}

predict_cpp_with_closure(pars, predict_local)[[1]] # passing the function, using the local (?) existence of the gam object

assign("global_gam", b, envir = globalenv())
predict_global <- function(pars) {
  return(mgcv::predict.gam(global_gam, pars))
}

predict_cpp_with_closure(pars, predict_global)[[1]]







# all values should be the same (nice tidbit, I did not know you
# could compare more than 2 values):
all.equal(mgcv::predict.gam(b, newd)[[1]],
          predict_cpp_with_gam_obj(b, pars),
          predict_cpp_external_closure(pars)[[1]],
          predict_cpp_with_closure(pars, predict_no_gam)[[1]],
          predict_cpp_with_closure(pars, predict_global)[[1]])


# how is the speed? They are all equally slow/fast:
# with only the native R implementation (predict_val) being slightly faster.
a <- microbenchmark::microbenchmark(predict_val(b, newd),
                                    predict_cpp_with_gam_obj(b, pars),
                                    predict_cpp_external_closure(pars),
                                    predict_cpp_with_closure(pars, predict_no_gam),
                                    predict_cpp_with_closure(pars, predict_local)[[1]],
                                    predict_cpp_with_closure(pars, predict_global)[[1]],
                                    times = 100)

a

ggplot2::autoplot(a)

