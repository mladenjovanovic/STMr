% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/adj-reps.R
\name{adj_reps}
\alias{adj_reps}
\alias{adj_reps_RIR}
\alias{adj_reps_DI}
\alias{adj_reps_rel_int}
\alias{adj_reps_perc_MR}
\title{Family of functions to adjust number of repetition}
\usage{
adj_reps_RIR(
  perc_1RM,
  adjustment = 0,
  mfactor = 1,
  max_reps_func = max_reps_epley,
  ...
)

adj_reps_DI(
  perc_1RM,
  adjustment = 1,
  mfactor = 1,
  max_reps_func = max_reps_epley,
  ...
)

adj_reps_rel_int(
  perc_1RM,
  adjustment = 1,
  mfactor = 1,
  max_reps_func = max_reps_epley,
  ...
)

adj_reps_perc_MR(
  perc_1RM,
  adjustment = 1,
  mfactor = 1,
  max_reps_func = max_reps_epley,
  ...
)
}
\arguments{
\item{perc_1RM}{Numeric vector. \%1RM used (use 0.5 for 50\%, 0.9 for 90\%)}

\item{adjustment}{Numeric vector. Adjustment to be implemented}

\item{mfactor}{Numeric vector. Default is 1 (i.e., no adjustment).
Use \code{mfactor = 2} to generate ballistic adjustment and tables}

\item{max_reps_func}{Max reps function to be used. Default is \code{\link{max_reps_epley}}}

\item{...}{Forwarded to \code{max_reps_func}. Usually the parameter value.
For example \code{klin = 36} when using \code{\link{max_reps_linear}} as
\code{max_reps_func} function}
}
\value{
Numeric vector. Predicted number of repetitions to be performed
}
\description{
These functions are reverse version of the \code{\link{adj_perc_1RM}}
family of functions. Use these when you want to estimate number of
repetitions to be used when using the known \%1RM and level of
adjustment
}
\section{Functions}{
\itemize{
\item \code{adj_reps_RIR()}: Adjust number of repetitions using the Reps In Reserve (RIR) approach

\item \code{adj_reps_DI()}: Adjust number of repetitions using the Deducted Intensity (DI) approach

\item \code{adj_reps_rel_int()}: Adjust number of repetitions using the Relative Intensity (RelInt) approach

\item \code{adj_reps_perc_MR()}: Adjust number of repetitions using the \% max reps (\%MR) approach

}}
\examples{
# ------------------------------------------
# Adjustment using Reps In Reserve (RIR)
adj_reps_RIR(0.75)

# Use ballistic adjustment (this implies doing half the reps)
adj_reps_RIR(0.75, mfactor = 2)

# Use 2 reps in reserve
adj_reps_RIR(0.75, adjustment = 2)

# Use Linear model
adj_reps_RIR(0.75, max_reps_func = max_reps_linear, adjustment = 2)

# Use Modifed Epley's equation with a custom parameter values
adj_reps_RIR(
  0.75,
  max_reps_func = max_reps_modified_epley,
  adjustment = 2,
  kmod = 0.06
)
# ------------------------------------------
# Adjustment using Deducted Intensity (DI)
adj_reps_DI(0.75)

# Use ballistic adjustment (this implies doing half the reps)
adj_reps_DI(0.75, mfactor = 2)

# Use 10\% deducted intensity
adj_reps_DI(0.75, adjustment = -0.1)

# Use Linear model
adj_reps_DI(0.75, max_reps_func = max_reps_linear, adjustment = -0.1)

# Use Modifed Epley's equation with a custom parameter values
adj_reps_DI(
  0.75,
  max_reps_func = max_reps_modified_epley,
  adjustment = -0.1,
  kmod = 0.06
)
# ------------------------------------------
# Adjustment using Relative Intensity (RelInt)
adj_reps_rel_int(0.75)

# Use ballistic adjustment (this implies doing half the reps)
adj_reps_rel_int(0.75, mfactor = 2)

# Use 85\% relative intensity
adj_reps_rel_int(0.75, adjustment = 0.85)

# Use Linear model
adj_reps_rel_int(0.75, max_reps_func = max_reps_linear, adjustment = 0.85)

# Use Modifed Epley's equation with a custom parameter values
adj_reps_rel_int(
  0.75,
  max_reps_func = max_reps_modified_epley,
  adjustment = 0.85,
  kmod = 0.06
)
# ------------------------------------------
# Adjustment using \% max reps (\%MR)
adj_reps_perc_MR(0.75)

# Use ballistic adjustment (this implies doing half the reps)
adj_reps_perc_MR(0.75, mfactor = 2)

# Use 85\% of max reps
adj_reps_perc_MR(0.75, adjustment = 0.85)

# Use Linear model
adj_reps_perc_MR(0.75, max_reps_func = max_reps_linear, adjustment = 0.85)

# Use Modifed Epley's equation with a custom parameter values
adj_reps_perc_MR(
  0.75,
  max_reps_func = max_reps_modified_epley,
  adjustment = 0.85,
  kmod = 0.06
)
}
