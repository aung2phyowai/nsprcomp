% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/nsprcomp.R
\name{nsprcomp}
\alias{nsprcomp}
\alias{nsprcomp.default}
\alias{nsprcomp.formula}
\title{Non-Negative and Sparse PCA}
\usage{
nsprcomp(x, ...)

\method{nsprcomp}{default}(x, retx = TRUE, ncomp = min(dim(x)),
  omega = rep(1, nrow(x)), k = ncol(x), nneg = FALSE, center = TRUE,
  scale. = FALSE, tol = NULL, nrestart = 5, em_tol = 0.001,
  em_maxiter = 100, partial_model = NULL, verbosity = 0, ...)

\method{nsprcomp}{formula}(formula, data = NULL, subset, na.action, ...)
}
\arguments{
\item{x}{a numeric matrix or data frame which provides the data 
for the principal component analysis.}

\item{...}{arguments passed to or from other methods.}

\item{retx}{a logical value indicating whether the principal components, i.e.
\code{x} projected into the principal subspace, should be returned.}

\item{ncomp}{the number of principal components (PCs) to be computed. With 
the default setting, PCs are computed until \code{x} is fully deflated. 
\code{ncomp} can be specified implicitly if \code{k} is given as a vector.}

\item{omega}{a vector with as many entries as there are data samples, to 
perform weighted PCA (analogous to weighted least-squares regression). The 
default is an equal weighting of all samples.}

\item{k}{either a scalar or a vector of length \code{ncomp}, specifying the 
upper bounds on the cardinalities of the principal axes (PAs).}

\item{nneg}{a logical value indicating whether the loadings should be 
non-negative, i.e. the PAs should be constrained to the non-negative 
orthant.}

\item{center}{a logical value indicating whether the empirical mean of (the 
columns) of \code{x} should be subtracted. Alternatively, a vector of 
length equal to the number of columns of \code{x} can be supplied. The 
value is passed to \code{\link{scale}}.}

\item{scale.}{a logical value indicating whether the columns of \code{x} 
should be scaled to have unit variance before the analysis takes place. The
default is \code{FALSE} for consistency with \code{prcomp}. Alternatively, 
a vector of length equal to the number of columns of \code{x} can be 
supplied. The value is passed to \code{\link{scale}}.}

\item{tol}{a threshold indicating the magnitude below which components should
be omitted. Components are omitted if their standard deviations are less 
than or equal to \code{tol} times the standard deviation of the first 
component. With the default \code{NULL} setting, no components are omitted.
With \code{tol = 0} or \code{tol = sqrt(.Machine$double.eps)}, essentially 
constant components are omitted.}

\item{nrestart}{the number of random restarts for computing the principal 
component via expectation-maximization (EM) iterations. The solution 
achieving maximum standard deviation over all random restarts is kept. A 
value greater than one can help to avoid poor local maxima.}

\item{em_tol}{If the relative change of the objective is less than 
\code{em_tol} between iterations, the EM procedure is asssumed to have 
converged to a local optimum.}

\item{em_maxiter}{the maximum number of EM iterations to be performed. The EM
procedure is terminated if either the \code{em_tol} or the 
\code{em_maxiter} criterion is satisfied.}

\item{partial_model}{\code{NULL} or an object of class \code{nsprcomp}. The 
computation can be continued from a partial model by providing a 
\code{nsprcomp} object (either from a previous run of this function or from
\code{\link{asdev}}) and setting \code{ncomp} to a value greater than the 
number of components contained in the partial model. See the examples for 
an illustration.}

\item{verbosity}{an integer specifying the verbosity level. Greater values 
result in more output, the default is to be quiet.}

\item{formula}{a formula with no response variable, referring only to numeric variables.}

\item{data}{an optional data frame (or similar: see
\code{\link{model.frame}}) containing the variables in the
\code{formula}. By default the variables are taken from
\code{environment(formula)}.}

\item{subset}{an optional vector used to select rows (observations) of the
data matrix \code{x}.}

\item{na.action}{a function which indicates what should happen
when the data contain \code{NA}s.  The default is set by
the \code{na.action} setting of \code{\link{options}}, and is
\code{\link{na.fail}} if that is unset. The \sQuote{factory-fresh}
default is \code{\link{na.omit}}.}
}
\value{
\code{nsprcomp} returns a list with class \code{(nsprcomp, prcomp)} 
  containing the following elements: \item{sdev}{the additional standard 
  deviation explained by each component, see \code{\link{asdev}}.} 
  \item{rotation}{the matrix of non-negative and/or sparse loadings, 
  containing the principal axes as columns.} \item{x}{the scores matrix 
  \eqn{\mathbf{XW}}{X*W} containing the principal components as columns 
  (after centering and scaling if requested). For the formula method, 
  \code{\link{napredict}} is applied to handle the treatment of values 
  omitted by the \code{na.action}.} \item{center, scale}{the centering and 
  scaling used, or \code{FALSE}} \item{xp}{the deflated data matrix 
  corresponding to \code{x}} \item{q}{an orthonormal basis for the principal 
  subspace}
}
\description{
Performs a constrained principal component analysis,
where non-negativity and/or sparsity constraints are enforced on the principal axes.
The result is returned as an object of class \code{nsprcomp}, which inherits from
\code{prcomp}.
}
\details{
\code{nsprcomp} computes a principal component (PC) using expectation-maximization
iterations, where non-negativity of the loadings is achieved by projecting
the principal axis (PA) into the non-negative orthant, and sparsity of the 
loadings is achieved by soft thresholding (Sigg and Buhmann, 2008).

Because constrained principal axes no longer correspond to true eigenvectors 
of the covariance matrix and are usually not pairwise orthogonal, special
attention needs to be paid when computing more than a single PC. The
algorithm implements the generalized deflation method proposed by
Mackey (2009) to maximize the additional variance of each
component. Given a basis of the space spanned by the previous PAs, the
variance of the PC is maximized after projecting the current PA to the
ortho-complement space of the basis. This procedure maximizes the
additional variance not explained by previous components, and is
identical to standard PCA if no sparsity or non-negativity constraints
are enforced on the PAs.

See the references for further details.
}
\note{
The PCA terminology is not consistent across the literature. Given a 
  zero mean data matrix \eqn{\mathbf{X}}{X} (with observations as rows) and a
  basis \eqn{\mathbf{W}}{W} of the principal subspace, we define the scores 
  matrix as \eqn{\mathbf{Z}=\mathbf{XW}}{Z=X*W} which contains the principal 
  components as its columns. The columns of the pseudo-rotation matrix
  \eqn{\mathbf{W}}{W} are called the principal axes, and the elements of
  \eqn{\mathbf{W}}{W} are called the loadings.
  
  Deflating the data matrix accumulates numerical errors over successive PCs.
}
\examples{
if (requireNamespace("MASS", quietly = TRUE)) withAutoprint({
  set.seed(1)

  # Regular PCA, with the tolerance set to return five PCs
  prcomp(MASS::Boston, tol = 0.36, scale. = TRUE)

  # Sparse PCA with different cardinalities per component. The number of components
  # is derived from the length of vector k.
  nsprcomp(MASS::Boston, k = c(13, 7, 5, 5, 5), scale. = TRUE)

  # Non-negative sparse PCA with four components. Note that the principal axes
  # naturally have a high degree of orthogonality, because each component
  # maximizes the additional variance not already explained.
  set.seed(1)
  nsprcomp(MASS::Boston, k = c(7, 5, 2, 2), nneg = TRUE, scale. = TRUE)

  # The optimization can get stuck in local optima. Increase the number of
  # random restarts or the number of power iterations to likely obtain decreasing
  # standard deviations.
  set.seed(1)
  (nspc <- nsprcomp(MASS::Boston, k = c(7, 5, 2, 2), nneg = TRUE, scale. = TRUE,
                    nrestart = 10, em_tol = 1e-4, verbosity = 1))

  # continue the computation of components from a partial model
  nsprcomp(MASS::Boston, k = 3, ncomp = 5, nneg = TRUE, scale. = TRUE, partial_model = nspc)

  # The reconstruction error for each sample can be influenced using the
  # weighting vector omega. To reconstruct the data, the generalized
  # inverse of the pseudo-rotation matrix has to be used, because the constrained
  # principal axes are in general not pairwise orthogonal.
  set.seed(1)
  X <- matrix(runif(5*10), 5)
  nspc <- nsprcomp(X, omega = c(5, 1, 1, 1, 5), ncomp = 2, nneg = TRUE)
  X_hat <- predict(nspc)\%*\%MASS::ginv(nspc$rotation) + matrix(1,5,1)\%*\%nspc$center
  rowSums((X - X_hat)^2)
})
}
\references{
Sigg, C. D. and Buhmann, J. M. (2008) Expectation-Maximization 
  for Sparse and Non-Negative PCA. In \emph{Proceedings of the 25th 
  International Conference on Machine Learning} (pp. 960--967).

Mackey, L. (2009) Deflation Methods for Sparse PCA. In 
  \emph{Advances in Neural Information Processing Systems} (pp. 1017--1024).
}
\seealso{
\code{\link{asdev}},  \code{\link{peav}}, \code{\link{prcomp}}, 
  \code{\link{scale}}
}
