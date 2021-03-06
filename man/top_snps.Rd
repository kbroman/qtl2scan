% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/top_snps.R
\name{top_snps}
\alias{top_snps}
\title{Create table of top snp associations}
\usage{
top_snps(scan1_output, snpinfo, lodcolumn = 1, chr = NULL, drop = 1.5,
  show_all_snps = TRUE)
}
\arguments{
\item{scan1_output}{Output of \code{\link[=scan1]{scan1()}}.
Should contain a component \code{"snpinfo"}, as when
\code{\link[=scan1]{scan1()}} is run with SNP probabilities
produced by \code{\link[=genoprob_to_snpprob]{genoprob_to_snpprob()}}.}

\item{snpinfo}{Data frame with SNP information with the following
columns (the last three are generally derived with
\code{\link[=index_snps]{index_snps()}}):
\itemize{
\item \code{chr} - Character string or factor with chromosome
\item \code{pos} - Position (in same units as in the \code{"map"}
attribute in \code{genoprobs}.
\item \code{sdp} - Strain distribution pattern: an integer, between
1 and \eqn{2^n - 2} where \eqn{n} is the number of strains, whose
binary encoding indicates the founder genotypes
\item \code{snp} - Character string with SNP identifier (if
missing, the rownames are used).
\item \code{index} - Indices that indicate equivalent
groups of SNPs, calculated by \code{\link[=index_snps]{index_snps()}}.
\item \code{intervals} - Indexes that indicate which marker
intervals the SNPs reside.
\item \code{on_map} - Indicate whether SNP coincides with a marker
in the \code{genoprobs}
}}

\item{lodcolumn}{Selected LOD score column to (a numeric index, or a
character string for a column name). Only one value allowed.}

\item{chr}{Selected chromosome; only one value allowed.}

\item{drop}{Show all SNPs with LOD score within this amount of the
maximum SNP association.}

\item{show_all_snps}{If TRUE, expand to show all SNPs.}
}
\description{
Create a table of the top snp associations
}
\examples{
\dontrun{
# load example DO data from web
library(qtl2geno)
file <- paste0("https://raw.githubusercontent.com/rqtl/",
               "qtl2data/master/DOex/DOex.zip")
DOex <- read_cross2(file)

# subset to chr 2
DOex <- DOex[,"2"]

# calculate genotype probabilities and convert to allele probabilities
pr <- calc_genoprob(DOex, error_prob=0.002)
apr <- genoprob_to_alleleprob(pr)

# download snp info from web
tmpfile <- tempfile()
file <- paste0("https://raw.githubusercontent.com/rqtl/",
               "qtl2data/master/DOex/c2_snpinfo.rds")
download.file(file, tmpfile, quiet=TRUE)
snpinfo <- readRDS(tmpfile)
unlink(tmpfile)

# calculate strain distribution patterns
snpinfo$sdp <- calc_sdp(snpinfo[,-(1:4)])

# identify groups of equivalent SNPs
snpinfo <- index_snps(DOex$pmap, snpinfo)

# convert to snp probabilities
snppr <- genoprob_to_snpprob(apr, snpinfo)

# perform SNP association analysis (here, ignoring residual kinship)
out_snps <- scan1(snppr, DOex$pheno)

# table with top SNPs
top_snps(out_snps, snpinfo)

# top SNPs among the distinct subset at which calculations were performed
top_snps(out_snps, snpinfo, show_all_snps=FALSE)

# top SNPs within 0.5 LOD of max
top_snps(out_snps, snpinfo, 0.5)
}
}
\seealso{
\code{\link[=index_snps]{index_snps()}}, \code{\link[=genoprob_to_snpprob]{genoprob_to_snpprob()}}, \code{\link[=scan1snps]{scan1snps()}}, \code{plot_snpasso()} in \href{https://github.com/rqtl/qtl2plot}{R/qtl2plot}
}
