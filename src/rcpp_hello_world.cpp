
#include <Rcpp.h>
using namespace Rcpp;


NumericVector predict_gam_from_r(const List& gam_obj,
                                 const std::vector<double>& pars) {

  Rcpp::DataFrame df = Rcpp::DataFrame::create(Named("x0") = pars[0],
                                               Named("x1") = pars[1],
                                               Named("x2") = pars[2],
                                               Named("x3") = pars[3]);
  Function gam_f("predict_val"); // can not be global
  return gam_f(gam_obj, df);
}

// [[Rcpp::export]]
NumericVector predict_cpp_with_gam_obj(const List& gam_obj, const NumericVector& pars) {
  Function f("predict_val"); // can not be global
  NumericVector out = predict_gam_from_r(gam_obj,
                                           std::vector<double>(pars.begin(), pars.end()));
  return out;
}


NumericVector predict_from_r(const std::vector<double>& pars) {

  Rcpp::DataFrame df = Rcpp::DataFrame::create(Named("x0") = pars[0],
                                               Named("x1") = pars[1],
                                               Named("x2") = pars[2],
                                               Named("x3") = pars[3]);
  Function gam_f("predict_no_gam"); // can not be global
  return gam_f(df);
}


// [[Rcpp::export]]
NumericVector predict_cpp_external_closure(const NumericVector& pars) {
  NumericVector out = predict_from_r(std::vector<double>(pars.begin(), pars.end()));
  return out;
}

// [[Rcpp::export]]
NumericVector predict_cpp_with_closure(const NumericVector& pars,
                           const Function& f) {
 // NumericVector out = predict_from_r(std::vector<double>(pars.begin(), pars.end()));
 Rcpp::DataFrame df = Rcpp::DataFrame::create(Named("x0") = pars[0],
                                              Named("x1") = pars[1],
                                                                Named("x2") = pars[2],
                                                                                  Named("x3") = pars[3]);
  return f(df);
}




