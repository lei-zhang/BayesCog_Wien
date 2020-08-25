# BayesCog <img src="https://github.com/lei-zhang/BayesCog_Wien/raw/master/Thumbnail.png" align="right" width="300px">

**Bayesian Statistics and Hierarchical Bayesian Modeling for Psychological Science**

___

[![GitHub repo size](https://img.shields.io/github/repo-size/lei-zhang/BayesCog_Wien?color=brightgreen&logo=github)](https://github.com/lei-zhang/BayesCog_Wien)
[![GitHub language count](https://img.shields.io/github/languages/count/lei-zhang/BayesCog_Wien?color=brightgreen&logo=github)](https://github.com/lei-zhang/BayesCog_Wien)
[![GitHub last commit](https://img.shields.io/github/last-commit/lei-zhang/BayesCog_Wien?color=orange&logo=github)](https://github.com/lei-zhang/BayesCog_Wien) <br />
[![Twitter Follow](https://img.shields.io/twitter/follow/lei_zhang_lz?label=%40lei_zhang_lz)](https://twitter.com/lei_zhang_lz)
[![Lab Twitter Follow](https://img.shields.io/twitter/follow/ScanUnit?label=%40ScanUnit)](https://twitter.com/ScanUnit)

Teaching materials for **BayesCog** at [Faculty of Psychology](https://psychologie.univie.ac.at/), [University of Vienna](https://www.univie.ac.at/en/), as part of the Advanced Seminar for master's students (Mind and Brain track)\*.

Instructor: [Dr. Lei Zhang](http://lei-zhang.net/)

Location: [virtually via Zoom] 

When: 09:45-11:15 Wednesdays (see calendar below)

Recording: available on [YouTube](https://www.youtube.com/watch?v=8RpLF7ufZs4&list=PLfRTb2z8k2x9gNBypgMIj3oNLF8lqM44-) (also see below).

See also a [**Twitter thread**](https://twitter.com/lei_zhang_lz/status/1276506555660275714?s=20) (being liked 600+ times on Twitter) on the summary of the course. 

\* 2020 Summer Semester.

## Contents
* Computational modeling and mathematical modeling provide an insightful quantitative framework that allows researchers to inspect latent processes and to understand hidden mechanisms. Hence, computational modeling has gained increasing attention in many areas of cognitive science and neuroscience (hence, cognitive modeling). One illustration of this trend is the growing popularity of Bayesian approaches to cognitive modeling. To this aim, this course teaches the theoretical and practical knowledge necessary to perform, evaluate and interpret Bayesian modeling analyses. 
* This course is dedicated to introducing students to the basic knowledge of Bayesian statistics as well as basic techniques of Bayesian cognitive modeling. We will use R/RStudio and a newly developed statistical computing language - [Stan](mc-stan.org) to perform Bayesian analyses, ranging from simple binomial model and linear regression model to more complex hierarchical models.

## Calendar
 
L01: 18.03 Introduction and overview <[slides](slides/BayesCog_2020S_L01.pdf)> <[video](https://youtu.be/8RpLF7ufZs4)> <br />
L02: 27.03 Introduction to R/RStudio I <[slides](slides/BayesCog_2020S_L02+L03.pdf)> <[video](https://youtu.be/Z8dEnRIrrT8)>  <br />
L03: 27.03 Introduction to R/RStudio II <[slides](slides/BayesCog_2020S_L02+L03.pdf)> <[video](https://youtu.be/x6TqWJisux0)>  <br />
L04: 22.04 Probability and Bayes' theorem <[slides](slides/BayesCog_2020S_L04.pdf)> <[video](https://youtu.be/Ul73rtONvHI)> <br />
L05: 29.04 Linking data and parameter/model <[slides](slides/BayesCog_2020S_L05.pdf)> <[video](https://youtu.be/x_8ai-_lxcc)> <br />
L06: 06.05 Grid approximation of Binomial model & intro to MCMC <[slides](slides/BayesCog_2020S_L06.pdf)> <[video](https://youtu.be/7NXjxCT5rpY)> <br />
L07: 13.05 Intro to Stan I and Binomial model in Stan <[slides](slides/BayesCog_2020S_L07.pdf)> <[video](https://youtu.be/CH96BGLhV-E)> <br />
L08: 20.05 Intro to Stan II and Regression models in Stan <[slides](slides/BayesCog_2020S_L08.pdf)> <[video](https://youtu.be/6kP6V_qkQSc)> <br />
L09: 27.05 Intro to cognitive modeling & Rescorla-Wagner model <[slides](slides/BayesCog_2020S_L09.pdf)> <[video](https://youtu.be/tXFKYWx6c3k)> <br />
L10: 03.06 Implementing Rescorla-Wagner in Stan <[slides](slides/BayesCog_2020S_L10.pdf)> <[video](https://youtu.be/M69theIxI3g)> <br />
L11: 10.06 Hierarchical modeling + Stan optimization <[slides](slides/BayesCog_2020S_L11.pdf)> <[video](https://youtu.be/pCIsGBbUCCE)>  <br />
L12: 17.06 Model comparison <[slides](slides/BayesCog_2020S_L12.pdf)> <[video](https://youtu.be/xmt_H2q2tO8)>  <br />
L13: 24.06 Stan tips & debugging in Stan <[slides](slides/BayesCog_2020S_L13.pdf)> <[video](https://youtu.be/l-RIxGgamfw)>  <br />

### List of Folders and contents

Folder | Task | Model
-----  | ---- | ----
00.cheatsheet |NA | NA
01.R_basics |NA | NA
02.binomial_globe | Globe toss | Binomial Model
03.bernoulli_coin | Coin flip  | Bernoulli Model
04.regression_height | Observed weight and height | Linear regression model
05.regression_height_poly |  Observed weight and height | Linear regression model
06.reinforcement_learning  | 2-armed bandit task |   Simple reinforcement learning (RL)
07.optm_rl   | 2-armed bandit task |   Simple reinforcement learning (RL)
08.compare_models | Probabilistic reversal learning task |  Simple and fictitious RL models
09.debugging |  Memory Retention | Exponential decay model

## Useful links

* [The distribution zoo](https://ben18785.shinyapps.io/distribution-zoo/): an interactive tool to build intuitions about common probability distributions.
* [Probability distribution explorer](https://distribution-explorer.github.io/): another interactive tool on probability distributions, with code in `Python` and `Stan`.
* [Michael Betancourt's blog post](https://betanalpha.github.io/writing/): comprehensive case studies using `Stan`.
* [The Stan Forums](https://discourse.mc-stan.org/): A community to discuss Stan and Bayesian modeling.

## Recommended reading

```
[Journal articles]
- Kruschke, J. K., & Liddell, T. M. (2018). Bayesian data analysis for newcomers. Psychonomic bulletin & review, 25(1), 155-177.
- Wagenmakers, E. J., Marsman, M., Jamil, T., Ly, A., Verhagen, J., Love, J., ... & Matzke, D. (2018). Bayesian inference for psychology. Part I: Theoretical advantages and practical ramifications. Psychonomic bulletin & review, 25(1), 35-57.
- Daw, N. D. (2011). Trial-by-trial data analysis using computational models. Decision making, affect, and learning: Attention and performance XXIII, 23, 3-38.
- Etz, A., Gronau, Q. F., Dablander, F., Edelsbrunner, P. A., & Baribault, B. (2018). How to become a Bayesian in eight easy steps: An annotated reading list. Psychonomic Bulletin & Review, 25(1), 219-234.
- Ahn, W. Y., Haines, N., & Zhang, L. (2017). Revealing neurocomputational mechanisms of reinforcement learning and decision-making with the hBayesDM package. Computational Psychiatry, 1, 24-57.

[Books]
- McElreath, R. (2020). Statistical Rethinking: A Bayesian Course with Examples in R and Stan, 2nd Ed. CRC Press.
- Lambert, B. (2018). A Student’s Guide to Bayesian Statistics. Sage.
```

___

For bug reports, please contact Lei Zhang ([lei.zhang@univie.ac.at](mailto:lei.zhang@univie.ac.at), or [@lei_zhang_lz](https://twitter.com/lei_zhang_lz)).

Thanks to [Markdown Cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet) and [shields.io](https://shields.io/).

___

### LICENSE

This license (CC BY-NC 4.0) gives you the right to re-use and adapt, as long as you note any changes you made, and provide a link to the original source. Read [here](https://creativecommons.org/licenses/by-nc/4.0/) for more details. 

![](https://upload.wikimedia.org/wikipedia/commons/9/99/Cc-by-nc_icon.svg)
