% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/est_map_hmm.R
\name{est_rf_hmm_sequential}
\alias{est_rf_hmm_sequential}
\title{Multipoint analysis using Hidden Markov Models - Sequential phase elimination}
\usage{
est_rf_hmm_sequential(input.seq, twopt, start.set = 4, thres.twopt = 5,
  thres.hmm = 50, extend.tail = 50, phase.number.limit = Inf,
  sub.map.size.diff.limit = Inf, info.tail = TRUE,
  reestimate.single.ph.configuration = FALSE, tol = 0.1,
  tol.final = 0.001, verbose = TRUE, high.prec = FALSE)
}
\arguments{
\item{input.seq}{an object of class \code{mappoly.sequence}.}

\item{twopt}{an object of class \code{poly.est.two.pts.pairwise}
containing the two-point information}

\item{start.set}{number of markers to start the phasing procedure.}

\item{thres.twopt}{the threshold used to determine if the linkage
phases compared via two-point analysis should be considered 
for the search space reduction. (A.K.A. \eqn{\eta} in 
\cite{Mollinari and Garcia (2018)}).}

\item{thres.hmm}{the threshold used to determine if the linkage
phases compared via hmm analysis should be evaluated in the 
next round of marker inclusion.}

\item{extend.tail}{the length of the tail of the chain that should
be used to calculate the likelihood of the map. Even if function 
\code{info.tail = TRUE}, it uses at least \code{extend.tail}
as the tail length.}

\item{phase.number.limit}{the maximum number of linkage phases of the sub-maps defined 
by arguments \code{info.tail} and \code{extend.tail}. If the
size exceeds the limit, the marker will not be inserted. If
\code{NULL}, the it will insert all markers.}

\item{sub.map.size.diff.limit}{the maximum accepted length
difference between the current and the previous sub-map defined 
by arguments \code{info.tail} and \code{extend.tail}. If the
size exceeds the limit, the marker will not be inserted. If
\code{NULL}, the it will insert all markers.}

\item{info.tail}{if \code{TRUE} uses the complete informative tail
of the chain (i.e. number of markers where \eqn{ploidy x 2} 
homologous can be distinguished) to calculate the map likelihood}

\item{reestimate.single.ph.configuration}{logical. If \code{FALSE}
returns a map without reestimating the map parameters in cases
where there are only one possible linkage phase configuration.}

\item{tol}{the desired accuracy during the sequential phase.}

\item{tol.final}{the desired accuracy for the final map.}

\item{verbose}{If \code{TRUE}, current progress is shown; if
\code{FALSE}, no output is produced.}

\item{high.prec}{logical. If \code{TRUE} (default) uses high precision 
long double numbers in the HMM procedure.}
}
\value{
An object of class 'mappoly.map'
}
\description{
Performs the multipoint analysis proposed by \cite{Mollinari and
 Garcia (2018)} in a sequence of markers removing unlikely phases
using sequential multipoint information
}
\details{
This function sequentially includes markers into a map given an
ordered sequence. It uses two-point information to eliminate
unlikely linkage phase configurations given \code{thres.twopt}. The
search is made within a window of size \code{extend.tail}. For the
remaining configurations the HMM-based likelihood is computed and
the ones that pass the HMM threshold (\code{thres.hmm}) are eliminated.
}
\examples{
 \dontrun{
    data(hexafake)
    mrk.subset<-make_seq_mappoly(hexafake, 'seq1')
    red.mrk<-elim_redundant(mrk.subset)
    unique.mrks<-make_seq_mappoly(red.mrk)
    counts.web<-cache_counts_twopt(unique.mrks, get.from.web = TRUE)
    subset.pairs<-est_pairwise_rf(input.seq = unique.mrks,
                                  count.cache = counts.web,
                                  n.clusters = 16,
                                  verbose=TRUE)
    system.time(
    subset.map <- est_rf_hmm_sequential(input.seq = unique.mrks,
                                        thres.twopt = 5,
                                        thres.hmm = 10,
                                        extend.tail = 10,
                                        tol = 0.1,
                                        tol.final = 10e-3,
                                        twopt = subset.pairs,
                                        verbose = TRUE))

     ## Retrieving simulated linkage phase
     sim.ph.P.file <- system.file('doc', 'phase_sim_hexa_P.csv', package = 'mappoly')
     ph.P <- read.csv2(sim.ph.P.file)
     ph.P <- ph_matrix_to_list(ph.P[,-1])
     sim.ph.Q.file <- system.file('doc', 'phase_sim_hexa_Q.csv', package = 'mappoly')
     ph.Q <- read.csv2(sim.ph.Q.file)
     ph.Q <- ph_matrix_to_list(ph.Q[,-1])

     ## Estimated linkage phase
     ph.P.est <- subset.map$maps[[1]]$seq.ph$P
     ph.Q.est <- subset.map$maps[[1]]$seq.ph$Q

     ##Notice that two estimated homologous in parent P are different
     ##from the simulated ones
     compare_haplotypes(m = 6, h1 = ph.P[names(ph.P.est)], h2 = ph.P.est)
     compare_haplotypes(m = 6, h1 = ph.Q[names(ph.Q.est)], h2 = ph.Q.est)

     plot(subset.map, 1)

   }

}
\references{
Mollinari, M., and Garcia, A.  A. F. (2018) Linkage
    analysis and haplotype phasing in experimental autopolyploid
    populations with high ploidy level using hidden Markov
    models, _submited_. \url{https://doi.org/10.1101/415232}
}
\author{
Marcelo Mollinari, \email{mmollin@ncsu.edu}
}
