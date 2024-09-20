cmake <- biocmake::find()

###################################
######### Configuration ###########
###################################

options <- biocmake::formatArguments(biocmake::configure(fortran.compiler=FALSE))
options <- c(options, "-DIGRAPH_WARNINGS_AS_ERRORS=OFF")

# Setting up BLAS and LAPACK.
X <- sessionInfo()
blas_path <- X$BLAS
lapack_path <- X$LAPACK

if (file.exists(blas_path)) {
    options <- c(options,
        sprintf('-DBLAS_LIBRARIES="%s"', blas_path),
        "-DIGRAPH_USE_INTERNAL_BLAS=0"
    )
}

if (file.exists(lapack_path)) {
    options <- c(options,
        sprintf('-DLAPACK_LIBRARIES="%s"', lapack_path),
        "-DIGRAPH_USE_INTERNAL_LAPACK=0"
    )
}

# Forcing vendored builds of everything else.
options <- c(options,
    "-DIGRAPH_USE_INTERNAL_ARPACK=1",
    "-DIGRAPH_USE_INTERNAL_GLPK=1",
    "-DIGRAPH_USE_INTERNAL_GMP=1",
    "-DIGRAPH_USE_INTERNAL_PLFIT=1"
)

# Skipping the optional dependencies.
options <- c(options,
    "-DIGRAPH_BISON_SUPPORT=0",
    "-DIGRAPH_FLEX_SUPPORT=0"
)

###################################
######### Configuration ###########
###################################

install_path <- "inst"

if (!file.exists(install_path)) {
    tmp_dir <- "_temp"
    dir.create(tmp_dir, recursive=TRUE, showWarnings=FALSE)
    build_path <- file.path(tmp_dir, "build")

    if (!file.exists(build_path)) {
        source_path <- file.path(tmp_dir, "source")
        if (!file.exists(source_path)) {
            stopifnot(untar("sources.tar.gz", exdir=tmp_dir) == 0)
            first <- list.files(tmp_dir, pattern="^igraph-")
            file.rename(file.path(tmp_dir, first), source_path)
        }

        options <- c(options, paste0("-DCMAKE_INSTALL_PREFIX=", install_path))
        system2(cmake, c("-S", source_path, "-B", build_path, options), stderr=FALSE)
    }

    if (.Platform$OS.type != "windows") {
        system2(cmake, c("--build", build_path))
    } else {
        system2(cmake, c("--build", build_path, "--config", "Release"))
    }

    system2(cmake, c("--install", build_path), stderr=FALSE)
}
