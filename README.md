<img src=wormhole.png width=400/>

[![Build Status](https://travis-ci.org/dmlc/wormhole.svg?branch=master)](https://travis-ci.org/dmlc/wormhole)
[![Documentation Status](https://readthedocs.org/projects/wormhole/badge/?version=latest)](http://wormhole.readthedocs.org/en/latest/)
[![GitHub license](http://dmlc.github.io/img/apache2.svg)](./LICENSE)

Portable, scalable and reliable distributed machine learning.

Wormhole is a place where DMLC projects works together to provide
scalable and reliable machine learning toolkits that can run on various platforms

Features
====
* Portable:
  - Supported platforms: local machine, Apache YARN, MPI and Sungrid Engine
* Rich support of Data Source
  - All projects can read data from HDFS, S3 or local filesystem
* Scalable and Reliable

List of Tools
====
* Linear method: [L-BFGS](learn/lbfgs-linear)
* Factorization Machine based on Rabit: [FM](learn/lbfgs-fm)

Build & Run
====

* Requires a C++11 compiler (e.g.~`g++ >=4.8`) and `git`. Install them on Ubuntu
  >= 13.10

```
sudo apt-get update && sudo apt-get install -y build-essential git libgoogle-glog-dev
```

* Type `make` to build all deps and tools

