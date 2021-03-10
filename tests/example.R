n <- 200
sig <- 2
dat <- mgcv::gamSim(1,n = n, scale = sig)
b <- mgcv::gam(y~s(x0) + s(I(x1^2)) + s(x2) + offset(x3),
               data = dat)
newd <- data.frame(x0 = 0.5,
                   x1 = 0.5,
                   x2 = 0.5,
                   x3 = 0.5)
pred <- mgcv::predict.gam(b, newd)

predict_val(b, newd)

# note that predict_cpp only accepts an unnamed vector
# as.vector(newd) does not work (and crashes R).
predict_cpp(b, c(0.5, 0.5, 0.5, 0.5))

# this does work:
predict_cpp(b, as.numeric(as.vector(newd)))

all.equal(mgcv::predict.gam(b, newd)[[1]],
          predict_cpp(b, c(0.5, 0.5, 0.5, 0.5)))

a <- microbenchmark::microbenchmark(predict_val(b, newd),
                                    predict_cpp(b, c(0.5, 0.5, 0.5, 0.5)))

ggplot2::autoplot(a)
