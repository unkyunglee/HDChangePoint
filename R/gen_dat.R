#' Generate A Longitudinal Data Set
#'
#'
#' @param n number of sample size.
#' @param model  a character string for a nonlinear model: \code{"logist"} or \code{"arctan"}.
#' @param p a parameter for the dimension of coefficients in the log-normal model for the inflection point.
#' @param bb0 a parameter for the true intercept term of the log-normal model for the inflection point.
#' @param bb a (p-1)-length of the true coefficient vector of subject specific covariates.
#' @param x.sd a parameter for the standard deviation of time points (log-transformed ages).
#' @param v1 a parameter for the smallest visit number among all subjects have made.
#' @param v2 a parameter for the largest visit number among all subjects have made.
#' @param dist a character string for the distribution of the within-subject error term in the longitudinal model. Default is \code{"normal"}.
#' @param eps.sd a true scale parameter of the within-subject error term in the longitudinal model.
#' @param u.sd a true scale parameter of the random error term in the inflection point model.
#'
#' @return A data frame of the longitudinal data with 7 variables:
#' \itemize{
#'        \item{subj.id}{a vector of the ID number for all subjects.}
#'        \item{subj.cov}{ a vector of the subject specific covariates for all subjects.}
#'        \item{true_logt}{a vector of the inflection points for all subjects.}
#'        \item{ages}{a vector of the time points, which are the log transformed ages at clinical visits for all subjects}
#'        \item{omega}{a vector of the S-shaped function values depending on the ages and true_logt for all subjects.}
#'        \item{tms}{a vector of the observed longitudinal responses (total motor scores) for all subjects}
#'        \item{sex}{a vector of the subjects's gender.}
#'}
#'        The number of rows for the returned data frame is determined by the number of subjects' visits,
#'        where 5, 6, and 7 visits are randomly assigned to all patients. For example, the first subject made 5 visits and the second subject made 7 visits. Then the size of the data frame containing these two subjects' longitudinal data is 12 by 7.
#'
#'
#' @export
#'
#'
#' @example man/examples/multi_stage_nonpara_example.R


mydata<-function(n=80, model="logist",  p=2, bb0=0.1, bb=0.5, x.sd=0.5, v1=5, v2=7, dist="normal", eps.sd=0.05, u.sd=0.05){



  #################################################################################
  ## gender is created: 30% for male and 70% for females based on the real data ###
  #################################################################################

  gender<-sample(c("Male", "Female"), size=n, replace=TRUE, prob=c(0.3,0.7))


  ########################################
  ## generate data for each subject i   ##
  ########################################

  ## list format of observed HD data
  datgen<-vector("list", n)

  ## vector of visit numbers: different for different patients; 30% for 5 visits, 60% for 6 visits, 10% for 7 visits
  visit.num<-rep(100, n) #sample(v1:v2, n, replace=TRUE, prob=c(0.3, 0.6, 0.1))


  raw.tms.data<-array(0, dim=c(sum(visit.num),7),
                      dimnames=list(paste("xx", 1:sum(visit.num), sep=""),c("subj.id", "subj.cov", "true_logt", "ages", "omega", "tms", "sex")
                      ))




  for (id in 1:n){

    ## vector of subject ID ###

    subj.visit.number<-visit.num[id]
    subj.id<-rep(id, subj.visit.number)


    ## vector of gender  ###

    gender_level<-ifelse(gender[id]=="Male",1,0)
    sex<-rep(gender_level,visit.num[id])


    ###########################################
    ## Model for log of Inflection point T  ###
    ###########################################

    ## covariate W is uniform random number on (2,3)
    #p<-2
    ww<-runif(p-1,35, 50)


    ## error terms
    if (dist=="normal"){
      ee<-rnorm(1,0,u.sd)
    }



    beta<-c(bb0,bb)   ##  input for beta components
    W<-c(1,ww)        ##  ww is true covariate assocaited with log inflection point

    ################################################
    ## estimate log of inflection points         ###
    ################################################
    betaW<-crossprod(beta,W)   #t(as.vector(beta))%*%(as.vector(W));
    true_z<-betaW+ee;


    ## true inflection points should be in the range of logage
    xx<-sort(rnorm(visit.num[id],true_z,x.sd))


    ## error term for longitudinal model,
    ##            which follows normal distribution with mean 0 and standard deviation sigma

    if (dist=="normal"){
      eps.star<-rnorm(visit.num[id],0, eps.sd)
    }

    ## function omega generated by function w()
    true_z<-as.numeric(true_z)
    omega<-w(xx,true_z, model)

    ## longitudinal response: total motor score y
    yy<-omega+eps.star

    ## add covariate values
    cov.W<-rep(ww, visit.num[id])

    datgen[[id]]<-cbind(subj.id, cov.W, true_z, xx, omega, yy, sex)


  }




  ## create data.frame from list type of data
  gendat<-do.call("rbind.data.frame", datgen)
  raw.tms.data<-gendat

  return(raw.tms.data)

}
