
###                       von Schmalensee 2023 Methods Ecol Evol                         ###
##  (use following code as you want, but cite the above study if used in a publication)   ##
##                                                                                        ##
##          Script containing the sinc function, the sinc interpolation functions,        ##
##                           and a tutorial for how to use them.                          ##
##                                                                                        ##
##       Author: Loke von Schmalensee, Department of Zoology, Stockholm University        ##
##                      Email: loke.von.schmalensee@zoologi.su.se                         ##
##                                                                                        ##
###                                                                                      ###


#### The functions ####

## The sinc function
sinc <- function(x) {
  result <- sin(pi * x) / (pi * x)
  result[is.nan(result)] <- 1
  result
}

## The sinc interpolation function:  returns a vector of interpolated values (between measurements).
## 'measurements' is a vector of measurements (e.g. temperature) sampled at even time intervals ...
## which are assumed to be of length 1.
## 'interpolation_times' is a vector of the time points with even intervals at which interpolated values ...
## should be calculated. For example, if the interval between these points is 0.5, one value is ...
## interpolated between each measurement.
sinc_interpolation <- function(measurements, interpolation_times) {
  mat <- array(                                                 # Create a matrix ...
    rep(interpolation_times, each = length(measurements)),      # of the interpolation points sequence repeated on every row ...
    c(length(measurements), length(interpolation_times)))       # with as many rows as the number of data points.
  mat = measurements * sinc(mat - seq(1, length(measurements))) # Apply sinc function and multiply by y-value.
  colSums(mat)                                                  # Sum each column.
}

sinc_interp1 = function(x, measurements, xi){

}

## This is a slightly different, and less intuitive version of the interpolation function, which ...
## uses a method called "zero padding" in the frequency domain. It is much faster, and therefore ...
## better if analyzing very large datasets. It is ever so slightly less exact, but this effect is ...
## for all intents and purposes negligible. Compare results at the end of the script.
## As above, this function returns a vector of interpolated values (between measurements).
## 'measurements' is a vector of measurements (e.g. temperature) sampled at even time intervals ...
## which are assumed to be of length 1.
## 'interpolation_times' is a vector of the time points with even intervals at which interpolated values ...
## should be calculated. For example, if the interval between these points is 0.5, one value is ...
## interpolated between each measurement.
fast_sinc_interpolation <- function(measurements, interpolation_times) {

  n_input <- length(measurements) # Number of measurements
  n_input_even <- 2^(ceiling(log2(n_input))) # Next number that is a power of 2
  resolution <- 1/interpolation_times %% 1 # Pick out the interpolation factors for the desired interpolation times

  # Add zeros to the data to make the sample size a power of 2
  if(n_input != n_input_even){
    measurements <- c(measurements, rep(0, n_input_even - n_input))
  }

  # If interpolation should take place, run this.
  if(is.finite(min(resolution)) == T){

    resolution <- max(resolution[is.finite(resolution)]) # Interpolation resolution (number of times it enhances the resolution of the data)
    n_interpolation <- n_input_even * resolution # Calculate required number of interpolated values
    n_zeros <- n_interpolation - n_input_even # Number of zeros that should be padded in the frequency domain
    measurements_ft <- stats::fft(measurements)  # Calculate the discrete Fourier transform of the measurements

    # Zero pad the transformed measurements (add zeros to the middle of the FFT'ed sequence)
    zero_padded_measurements_ft <- c(measurements_ft[1:(n_input_even/2)], rep(0, n_zeros),measurements_ft[((n_input_even/2)+1):(n_input_even)])

    # Calculate the inverse Fourier transform of the padded measurements and return values at the desired times
    return(Re(stats::fft(zero_padded_measurements_ft, inverse = T) / n_input_even)[(interpolation_times-1) * resolution + 1])
  }

  # Otherwise return the data at the desired time points
  else{
    return(measurements[interpolation_times])
  }
}
