
#include <thread>
#include <chrono>

#include <Rcpp.h>
using namespace Rcpp;

void force_output() {
  //  std::this_thread::sleep_for(std::chrono::nanoseconds(100));
  std::this_thread::sleep_for(std::chrono::milliseconds(300));
  R_FlushConsole();
  R_ProcessEvents();
  R_CheckUserInterrupt();
}



NumericVector predict_gam_from_r(const List& gam_obj,
                                 const std::vector<double>& pars) {
  Function f("predict_val"); // can not be global
  Rcpp::DataFrame df = Rcpp::DataFrame::create(Named("x0") = pars[0],
                                               Named("x1") = pars[1],
                                               Named("x2") = pars[2],
                                               Named("x3") = pars[3]);
//  Rcout << "created df\n";

  return f(gam_obj, df);
}

// [[Rcpp::export]]
NumericVector predict_cpp(const List& gam_obj, const NumericVector& pars) {
 /* Rcout << "inside get_predict\n"; force_output();
  for (int i = 0; i < pars.size(); ++i) {
    Rcout << pars[i] << "\n"; force_output();
  }*/
  NumericVector out = predict_gam_from_r(gam_obj,
                                         std::vector<double>(pars.begin(), pars.end()));
  return out;
}
