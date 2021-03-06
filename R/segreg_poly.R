#' Polysomic segregation frequency
#'
#' Computes the polysomic segregation frequency given a ploidy level
#' and the dosage of the locus in both parents.
#'
#' @param m ploidy level
#'
#' @param dP dosage in parent P
#'
#' @param dQ dosage in parent Q
#'
#' @return a vector containing the expected segregation frequency for
#'     all possible genotypic classes.
#'
#' @examples
#'
#' #auto-octaploid with two and three doses in parents P and Q,
#' #respectively
#' (seg<-segreg_poly(m=8, dP=2, dQ=3))
#' barplot(seg, las=2)
#'
#' @author Marcelo Mollinari, \email{mmollin@ncsu.edu}
#'
#' @references
#'     Mollinari, M., and Garcia, A.  A. F. (2018) Linkage
#'     analysis and haplotype phasing in experimental autopolyploid
#'     populations with high ploidy level using hidden Markov
#'     models, _submited_. \url{https://doi.org/10.1101/415232}
#'     
#'     Serang O, Mollinari M, Garcia AAF (2012) Efficient Exact 
#'     Maximum a Posteriori Computation for Bayesian SNP 
#'     Genotyping in Polyploids. PLoS ONE 7(2): 
#'     e30906. \url{https://doi.org/10.1371/journal.pone.0030906}
#'     
#'
#' @importFrom stats dhyper
#' @export segreg_poly
#'
segreg_poly <- function(m, dP, dQ) {
    if (m%%2 != 0)
        stop("m must be an even number")
    p.dose <- numeric((m + 1))
    p.names <- character((m + 1))
    seg.p1 <- dhyper(x = c(0:(m + 1)), m = dP, n = (m - dP), k = m/2)
    seg.p2 <- dhyper(x = c(0:(m + 1)), m = dQ, n = (m - dQ), k = m/2)
    M <- tcrossprod(seg.p1, seg.p2)
    for (i in 1:nrow(M)) {
        for (j in 1:ncol(M)) {
            p.dose[i + j - 1] <- p.dose[i + j - 1] + M[i, j]
        }
    }
    p.dose <- p.dose[!is.na(p.dose)]
    for (i in 0:m) p.names[i + 1] <- paste(paste(rep("A", i), collapse = ""), paste(rep("a", (m - i)), collapse = ""), sep = "")
    names(p.dose) <- p.names
    return(p.dose)
}
