#' Configure compilation flags
#'
#' Configure flags for compiling downstream packages.
#'
#' @return String containing flags to add to \code{PKG_LIBS} of the \code{Makevars}.
#'
#' @author Aaron Lun
#' @examples
#' pkgconfig()
#'
#' @export
pkgconfig <- function() {
    system.file("lib", "libigraph.a", package="Rlibigraph", mustWork=TRUE)
}
