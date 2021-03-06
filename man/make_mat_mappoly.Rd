% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/make_mat.R
\name{make_mat_mappoly}
\alias{make_mat_mappoly}
\title{Subset recombination fraction matrices}
\usage{
make_mat_mappoly(input.mat, input.seq)
}
\arguments{
\item{input.mat}{an object of class \code{mappoly.rf.matrix}.}

\item{input.seq}{an object of class \code{mappoly.sequence}.
It must be contained in 'input.mat'}
}
\value{
a subset of \code{'input.mat'}. This object is also
    of class \code{mappoly.rf.matrix}.
}
\description{
Get a subset of an object of class \code{'mappoly.rf.matrix'}, i.e.,
 recombination fraction and LOD score matrices based in a
 sequence of markers.
}
\examples{
 \dontrun{
    data(hexafake)
    # sequence with 100 markers
    mrk.seq<-make_seq_mappoly(hexafake, 1:100)
    counts.web<-cache_counts_twopt(mrk.seq, get.from.web = TRUE)
    mrk.pairs<-est_pairwise_rf(input.seq = mrk.seq,
                               count.cache = counts.web,
                               n.clusters = 1,
                               verbose=TRUE)
    ## Full recombination fraction matrix
    mat<-rf_list_to_matrix(input.twopt=mrk.pairs)
    plot(mat)
    ## Matrix subset
    id <- make_seq_mappoly(hexafake, 1:10)
    mat.sub<-make_mat_mappoly(mat, id)
    plot(mat.sub)
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
