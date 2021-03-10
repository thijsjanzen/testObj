
#include <Rcpp.h>
using namespace Rcpp;

NumericVector predict_gam_from_r(const List& gam_obj,
                                 const std::vector<double>& pars) {
  static Function f("predict_val"); // can not be global
  Rcpp::DataFrame df = Rcpp::DataFrame::create(Named("x0") = pars[0],
                                               Named("x1") = pars[1],
                                               Named("x2") = pars[2],
                                               Named("x3") = pars[3]);

  return f(gam_obj, df);
}

// [[Rcpp::export]]
NumericVector predict_cpp(const List& gam_obj, const NumericVector& pars) {
  NumericVector out = predict_gam_from_r(gam_obj,
                                         std::vector<double>(pars.begin(), pars.end()));
  return out;
}
