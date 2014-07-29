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

The web dashboard depends on the following additional packages:

* timeline
* [extractoR.utils](https://github.com/maelick/extractoR/tree/utils)

You will also need data. Those can either be extracted using
[extractoR](https://github.com/maelick/extractoR),
[timetraveleR](https://github.com/maelick/timetraveleR) and
[cloneR](https://github.com/maelick/cloneR) or by getting serialized
data we previously extracted at
[CRANData](https://github.com/maelick/CRANData).

maintaineR's repository contains a script get_data.R that can get a
subset of CRANData so one's doesn't have to download all the data
which amounts many gigabytes. This allows you to download only data
files you need for a subset of packages. By default it will download
general CRAN data (packages, dependencies, conflicts and clones) and
will only download packages specific data (DESCRIPTION file, functions
list and namespaces) for the last version of the specified packages as
arguments, their dependencies and the packages with which they have
conflicts or clones. Options can be changed in the script to download
more data like reverse dependencies and all versions of the other
packages. This script requires:

* maintaineR package
* igraph
* RCurl

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
git clone https://github.com/maelick/CRANData.git data
```

Or:

```shell
Rscript get_data.R data PackageA PackageB
```

Finally shiny web app can be run width the following commands:

```shell
cd shiny
Rscript shiny/run.R
```

Demo
----

A screencast demo is available on
[Youtube](https://www.youtube.com/watch?v=q3RWTsVnPqg) and
presentation slides from useR 2014
[here](http://maelick.net/presentations/user2014).
