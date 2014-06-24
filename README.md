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

Usage
-----

You can run the shiny web app running the following commands in a
shell:

```shell
git clone https://github.com/maelick/maintaineR.git
cd maintaineR
git clone https://github.com/maelick/CRANData.git data
cd shiny
Rscript run.R
```
