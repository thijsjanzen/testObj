predict_val <- function(gam, pars) {
  testit::assert(is.data.frame(pars))
 # cat(pars$x0, " ", pars$x1, " ", pars$x2, " ", pars$x3, "\n")
  out <- mgcv::predict.gam(gam, pars)
  return(as.vector(out))
}