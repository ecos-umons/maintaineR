maintaineR
==========

maintaineR is both a package to analyze CRAN packages and a web
dashboard to visualize results of the analysis.


Prerequisites
-------------

maintaineR package depends on the following packages:

* R
* igraph
* rCharts
* d3Network
* RCurl

The web dashboard depends on the following additional packages:

* timeline
* [extractoR.utils](https://github.com/maelick/extractoR/tree/utils)

You will also need data. The entire data set can be obtained from our
[CRANData](https://github.com/maelick/CRANData) repository. However
the Shiny web app allows one to download only a subset of the data.

Available online data was extracted using
[extractoR](https://github.com/maelick/extractoR),
[timetraveleR](https://github.com/maelick/timetraveleR) and
[cloneR](https://github.com/maelick/cloneR).

This allows you to download only data files you need for a subset of
packages. By default the Shiny app will download general CRAN data
(packages, dependencies, conflicts and clones) and will only download
packages specific data (DESCRIPTION file, functions list and
namespaces) when requested by the user. Options allows one to download
more data with each selected package like direct and reverse
dependencies, conflicting packages and cloned packages.

Usage
-----

First download and install required packages:

```shell
git clone https://github.com/maelick/extractoR.git
R CMD INSTALL extractoR/extractoR.utils
git clone https://github.com/maelick/maintaineR.git
cd maintaineR
R CMD INSTALL maintaineR
```

Then data are needed, they can be gotten either:

```shell
git clone https://github.com/maelick/CRANData.git <dest>
```

Or by using maintaineR shiny web app.

Finally shiny web app can be run with the following commands:

```shell
Rscript shiny-webapp.R
```

By default the app will store downloaded data in the package
installation folder (inside "data" subfolder). If all data are
retrieved using git, they must be stored there. Alternately the
directory where data are stored can be modified in shiny-webapp.R.

Demo
----

A screencast demo is available on
[Youtube](https://www.youtube.com/watch?v=q3RWTsVnPqg) and
presentation slides from useR 2014
[here](http://maelick.net/presentations/user2014).
