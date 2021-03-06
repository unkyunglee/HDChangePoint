% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/simu_results_summary_paraNLME.R
\name{logit.results}
\alias{logit.results}
\title{Summary results of the parametric NLME, when the true data are generated by the logistic model and the parametric NLME assumes the correct logistic  model.}
\usage{
logit.results(
  nsim = 100,
  n = 80,
  res = results,
  theta1 = 6,
  theta3 = 1,
  time.length = 20,
  beta = 0.1,
  beta0 = 0.5,
  file = "nlme_logist"
)
}
\arguments{
\item{nsim}{number of simulation runs.}

\item{n}{number of sample size.}

\item{res}{a nsim-length of list for simulation results.}

\item{theta1}{a true scale parameter, which determines steepness of the logistic model.}

\item{theta3}{a true parameter, which determines the maximum (asymptote) of logstic model.}

\item{time.length}{number of data points at which predictors are required for each individual longitudinal trajectory. This time point for graphs to be plotted.}

\item{beta}{a (p-1)-length of true coefficient vector corresponding to subject specific covariates.}

\item{beta0}{true intercept of the log-normal model for the inflection point.}

\item{file}{a character string of file name for a creating plot in .eps file extention.}
}
\value{
A list of the summarized simulation results including
\itemize{
       \item{res.table}{a data frame of the absolute biases, estimated standard deviations, average of the estimated standard errors and 95\% coverage probabilities for the fixed effects (\code{beta0}, \code{beta}).}
       \item{Rel.glob.logT.est}{a data frame of the relative average performance of inflection points for all subjects including the relative absolute biases, the relative empirical standard errors, the relative bootstrap standard deviations and 95\% boostrap confidence intervals.}
}
}
\description{
Summary results of the parametric NLME, when the true data are generated by the logistic model and the parametric NLME assumes the correct logistic  model.
}
