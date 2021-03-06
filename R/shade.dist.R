#' Shade for continuous distributions
#'
#' This function plots shades for any CONTINUOUS probability distribution
#'
#' @param dist the distribution name as \code{'dnorm'}, \code{'dt'}, \code{'dbeta'} or any pdf available in the current session. Remember, only for CONTINUOUS probability distribution.
#' @param param is a list with the parameters of the distribution.
#' @param a is the lower limit of the shaded area.
#' @param b is the upper limit of the shaded area.
#' @param type is used to define the shaded area, it could be \code{'lower'} (by default), \code{'upper'}, \code{'middle'} or \code{'two'} for two tails.
#' @param from minimum X value to plot the density.
#' @param to maximum X value to plot the density.
#' @param col.shadow is the shade color, by default is \code{'skyblue'}.
#' @param col.line is the color line for the density.
#' @param lwd is the line width, a positive number, defaulting to 3.
#' @param nbreaks is the number of divisions to plot the shadow, by default is 10000.
#' @param ylab is the y label, by default is 'Density'.
#' @param ... Arguments to be passed to methods, such as graphical parameters (see par).
#' @param x it is nothing.
#'
#' @author Freddy Hernandez
#'
#' @examples
#' # With normal distribution
#' shade.dist(dist='dnorm', param=list(mean=0, sd=1),
#'             a=0, b=1, type='middle', from=-3, to=3)
#'
#' shade.dist(dist='dnorm', param=list(mean=0, sd=1),
#'             a=0, type='lower', from=-3, to=3)
#'
#' shade.dist(dist='dnorm', param=list(mean=0, sd=1),
#'             b=1, type='upper', from=-3, to=3)
#'
#' shade.dist(dist='dnorm', param=list(mean=0, sd=1),
#'             a=0, b=1, type='two', from=-3, to=3)
#'
#' # With chi-square distribution
#' shade.dist(dist='dchisq', param=list(df=2),
#'             a=2, b=6, type='middle', from=0, to=10, col.shadow='pink')
#'
#' # With t distribution
#' shade.dist(dist='dt', param=list(df=2),
#'             a=-2, b=2, type='middle', from=-5, to=5, col.shadow='tomato')
#'
#' # With beta distribution
#' shade.dist(dist='dbeta', param=list(shape1=2, shape2=5),
#'             a=0.2, b=0.6, type='middle', from=0, to=1,
#'             nbreaks=3, main='nbreaks=3, opps!!!')
#'
#' shade.dist(dist='dbeta', param=list(shape1=2, shape2=5),
#'             a=0.2, b=0.6, type='middle', from=0, to=1,
#'             nbreaks=20)
#'
#'
#' @importFrom graphics polygon curve Axis box
#' @export
shade.dist <- function(dist='dnorm', param=list(mean=0, sd=1),
                       a=NULL, b=NULL, type='lower',
                       from, to, col.shadow='skyblue', col.line='black',
                       lwd=3, nbreaks=1000, ylab=NULL, x, ...) {

  type <- match.arg(arg=type, choices=c('lower', 'middle', 'upper', 'two'))

  if (is.null(a) & is.null(b)) stop('At least define the parameter a')

  if (type %in% c('middle', 'two') & length(c(a, b)) <=1)
    stop("When type is 'middle' or 'two' you must define a & b")

  if (length(c(a, b)) == 2) { # To ensure that a < b
    values <- c(a, b)
    a <- min(values)
    b <- max(values)
  }

  if (is.null(a) & !is.null(b)) a <- b

  if (type == 'lower') {
    b <- a
    a <- from
  }

  if (type == 'upper') {
    a <- b
    b <- to
  }

  # To include the ylab automatically if ylab is NULL
  if (is.null(ylab)) ylab <- 'Density'

  # To create the main polygon
  cord.x <- c(a, seq(from=a, to=b, length.out=nbreaks+1), b)
  y <- seq(from=a, to=b, length.out=nbreaks+1)
  cord.y <- c(0, do.call(dist, c(list(x=y), param)), 0)

  # To create a secondary polygon if type='two'
  cord.x2 <- c(from, seq(from=from, to=to, length.out=nbreaks+1), to)
  y <- seq(from=from, to=to, length.out=nbreaks+1)
  cord.y2 <- c(0, do.call(dist, c(list(x=y), param)), 0)

  # First curve
  curve(do.call(dist, c(list(x), param)), ylab=ylab, from=from, to=to, axes=F, ...)

  # Shade if type == 'two'
  if (type == 'two') {
    polygon(cord.x2, cord.y2, col=col.shadow)
    col.shadow <- 'white'
  }

  # Main shadow
  polygon(cord.x, cord.y, col=col.shadow)

  # Second curve to avoid the borders
  curve(do.call(dist, c(list(x), param)), add=TRUE,
        lwd=lwd, col=col.line, ...)
  Axis(side=1)
  Axis(side=2)
  box(bty='l')

}
