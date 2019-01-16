---
layout: post
title: Per possession adjusted xG
subtitle: Goalmouth scrambles and conditional probability
author: "Joe Gallagher"
date: "2019-01-15"
tags: [R, football / soccer, xG, probability]
output: 
  md_document:
    variant: markdown_github
    preserve_yaml: true
always_allow_html: yes
bigimg: /img/scramble.png
shareimg: /img/scramble.png
---

I started thinking about expected goals (xG) recently after seeing this video shared by James Tippett on Twitter.

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">How much xG is accumulated in this ten second clip?<a href="https://t.co/jqwPzfETOk">pic.twitter.com/jqwPzfETOk</a></p>&mdash; James Tippett (@JamesTippett) <a href="https://twitter.com/JamesTippett/status/1074625684914491392?ref_src=twsrc%5Etfw">December 17, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

What are the odds of **not** scoring here? Five shots in the space of a few seconds, and you might expect any of the last four to find the back of the net more often than not. Imagine we had an expected goals model — a cautious one, maybe that takes the position of the goalkeeper and defenders into account — which assigned probabilities of each of these shots being scored as (and I'm pulling these figures out of thin air): 0.2, 0.3, 0.3, 0.3, and 0.3 xG. Would that mean that this sequence contains a total of 0.2 + 0.3 + 0.3 + 0.3 + 0.3 = 1.4 xG? Surely common sense suggests a single sequence can't exceed 1 xG because it's not possible to score more than 1 goal in any given attack?

Usually xG answers the question, "What's the probability a shot like this is scored?" But in the case of successive shots that are part of a single attack, we might be better asking, "What's the probability that **any one** of these shots is scored?".

------------------------------------------------------------------------

We can answer this question using a fundamental concept of probability theory known as conditional probability. Conditional probability is the probability an event occurrs given that another event has already occurred. In the case of the first two shots in this sequence, this would be the probability that a second shot results in a goal given that the first shot missed, which we could write in mathematical notation as *P*(*G*<sub>2</sub>\|*M*<sub>1</sub>).

However, the probability that the second shot is scored given that the first shot misses is simply the xG value for the second shot, 0.3. What we really want to do is consider both shots at once and ask what the probability is that the first shot misses **and** the second shot is scored. This is the intersection probability and can be written as *P*(*M*<sub>1</sub> ∩ *G*<sub>2</sub>).

If we take the formula for conditional probability:  

*P*(*G*<sub>2</sub>\|*M*<sub>1</sub>) = *P*(*G*<sub>2</sub> ∩ *M*<sub>1</sub>) / *P*(*M*<sub>1</sub>)


We can simply rearrange it as:  

*P*(*M*<sub>1</sub> ∩ *G*<sub>2</sub>) = *P*(*G*<sub>2</sub> \| *M*<sub>1</sub>) *P*(*M*<sub>1</sub>)


As we said above, *P*(*G*<sub>2</sub> \| *M*<sub>1</sub>) in our case is just *P*(*G*<sub>2</sub>), so we have:

*P*(*M*<sub>1</sub> ∩ *G*<sub>2</sub>) = *P*(*G*<sub>2</sub>) *P*(*M*<sub>1</sub>)

------------------------------------------------------------------------

Now if we want to estimate the probability of a goal being scored from **any** of these five shots, we should consider the intersection probability of every possible permutation of events. A goal could come from the first shot being scored (meaning we wouldn't see shots 2, 3, 4, or 5), or could come from the first shot missing and the second shot being scored (meaning we wouldn't see shots 3, 4, or 5), and so on.

We can visualise all our permutations using a simple decision tree. As scoring and missing are the only two possibilities at any branch, the probability of any shot missing must be 1 - xG.

![](/assets/2019-01-15-adjusted-xG_files/decision-tree.png)

Next, let's calculate the probability of each permutation by running through their mathematical notations.

Firstly, the unconditional probability of the first shot being scored is simply the xG of that shot:  

*P*(*G*<sub>1</sub>) = 0.2  


Next, the intersection probability of the first shot missing and second shot being scored:  
*P*(*M*<sub>1</sub> ∩ *G*<sub>2</sub>) = 0.8 × 0.3 = 0.24  


And so on for the third, fourth, and fifth shot being scored:
*P*(*M*<sub>1</sub> ∩ *M*<sub>2</sub> ∩ *G*<sub>3</sub>) = 0.8 × 0.7 × 0.3 = 0.168  
*P*(*M*<sub>1</sub> ∩ *M*<sub>2</sub> ∩ *M*<sub>3</sub> ∩ *G*<sub>4</sub>) = 0.8 × 0.7 × 0.7 × 0.3 = 0.1176  
*P*(*M*<sub>1</sub> ∩ *M*<sub>2</sub> ∩ *M*<sub>3</sub> ∩ *M*<sub>4</sub> ∩ *G*<sub>5</sub>) = 0.8 × 0.7 × 0.7 × 0.3 = 0.08232  

Finally, the intersection probability of all shots missing:
*P*(*M*<sub>1</sub> ∩ *M*<sub>2</sub> ∩ *M*<sub>3</sub> ∩ *M*<sub>4</sub> ∩ *M*<sub>5</sub>) = 0.8 × 0.7 × 0.7 × 0.7 = 0.19208  


As a quick sanity check to make sure we've considered every possible outcome, we can add together the probability of all permutations and see that they sum to 1.

``` r
0.2 + 0.24 + 0.168 + 0.08232 + 0.1176 + 0.19208
```

    ## [1] 1

Now if we want to know the probabilty of a goal being scored in any of the above shots, we can sum the probabilities of each permutation containing a goal.

``` r
0.2 + 0.24 + 0.168 + 0.08232 + 0.1176
```

    ## [1] 0.80792

What we're essentially asking is the probability of a goal being scored in the first shot or the second shot or the third shot ... or the *n*th shot, which in mathematical notation is:

*P*(*G*<sub>1</sub> ∪ *G*<sub>2</sub> ∪ *G*<sub>3</sub> ∪ *G*<sub>4</sub> ∪ *G*<sub>5</sub>) = *P*(*G*<sub>1</sub>) + *P*(*M*<sub>1</sub> ∩ *G*<sub>2</sub>) + *P*(*M*<sub>1</sub> ∩ *M*<sub>2</sub> ∩ *G*<sub>3</sub>) + ⋯

Or since we're adding the probability of every permutation except for all shots missing, we can get there more quickly by just subtracting the probability that every shot misses from 1.

``` r
1 - 0.19208
```

    ## [1] 0.80792

So there we have it: the odds of a goal being scored in this sequence (using our naive and probably conservative xG estimates) is around 81%.

------------------------------------------------------------------------

Now we've got a methodology in mind, let's use an example with real xG estimates. How about this goalmouth scramble from the Tunisia vs England game in the World Cup?

<div style="width:100%;height:0px;position:relative;padding-bottom:56.250%;"><iframe src="https://streamable.com/s/fl2om/atvfuu" frameborder="0" width="100%" height="100%" allowfullscreen style="width:100%;height:100%;position:absolute;left:0px;top:0px;overflow:hidden;"></iframe></div>

How many shots have we got here: one, two, three, or four? Maguire's somewhat-fluffed header might have been an attempt at a shot or a squared ball, as might Alli's have been. And does Sterling's shot even count if it goes backward?

Luckily, [StatsBomb](https://statsbomb.com/) have classified each shot and its xG for us already, and — even better — have made all their data freely available for World Cup 2018 (and other competitions, including the FA Women's Super League). These xG values are unconditional probabilities which do not account for other shots in the same sequence, so it is possible for a single attack to have &gt;1 xG; we may therefore wish to adjust xG using the method outlined above.

I'll be using R with the [`StatsBombR`](https://github.com/statsbomb/StatsBombR) package to access the StatsBomb API and the [`soccermatics`](https://github.com/JoGall/soccermatics) package to visualise the data. First let's get the data for the Tunisia v England game.

``` r
library(tidyverse)
# devtools::install_github("statsbomb/StatsBombR")
library(StatsBombR)

FreeCompetitions() # see all free competitions offered

matches <- FreeMatches(43) # get all world cup matches
```

``` r
TUNvENG <- matches %>% 
  filter(match_id == 7537) # select match of interest

dat <- get.matchFree(TUNvENG) %>% 
  allclean() # get all data and clean
```

In order to plot our data with the soccermatics package, we need to transform the x,y-coordinates from StatsBomb's arbitrary { x: 1 - 120, y: 1 - 80 } units to metre units -- the pitch dimensions of the Volgograd Arena (where this game was played), 105m x 68m.

``` r
# devtools::install_github("jogall/soccermatics")
library(soccermatics)

dat <- dat %>% 
  soccerTransform(method = "statsbomb", lengthPitch = 105, widthPitch = 68)
```

First let's look at all the events in this particular sequence.

``` r
dat %>%
  filter(minute == 38 & second >= 40) %>% 
  select(minute, second, possession, team.name, player.name, type.name)
```

    ## # A tibble: 17 x 6
    ##    minute second possession team.name player.name               type.name 
    ##     <int>  <int>      <int> <chr>     <chr>                     <chr>     
    ##  1     38     40         64 England   Kieran Trippier           Pass      
    ##  2     38     42         64 England   Harry Maguire             Ball Rece…
    ##  3     38     42         64 England   Harry Maguire             Pass      
    ##  4     38     44         64 England   Bamidele Alli             Ball Rece…
    ##  5     38     44         64 England   Bamidele Alli             Shot      
    ##  6     38     45         64 Tunisia   Syam Ben Youssef          Block     
    ##  7     38     45         64 Tunisia   Farouk Ben Mustapha       Goal Keep…
    ##  8     38     46         64 England   Raheem Shaquille Sterling Ball Reco…
    ##  9     38     46         64 England   Raheem Shaquille Sterling Shot      
    ## 10     38     47         64 England   John Stones               Ball Reco…
    ## 11     38     47         64 Tunisia   Farouk Ben Mustapha       Goal Keep…
    ## 12     38     47         64 England   John Stones               Shot      
    ## 13     38     48         64 Tunisia   Farouk Ben Mustapha       Goal Keep…
    ## 14     38     50         64 Tunisia   Wahbi Khazri              Ball Reco…
    ## 15     38     53         64 England   Jordan Brian Henderson    Pressure  
    ## 16     38     54         64 Tunisia   Wahbi Khazri              Pass      
    ## 17     38     54         64 England   Jordan Brian Henderson    Block

And then subset only England's shots.

``` r
ss <- dat %>% 
  filter(possession == 64) %>% 
  filter(type.name == "Shot") %>% 
  select(minute, second, team.name, player.name, location.x, location.y, shot.end_location.x, shot.end_location.y, xg = shot.statsbomb_xg)
```

We can plot out the position of the players and trajectory of the shots using `soccerPitchHalf()` function (making sure to invert the x- and y-axes to account for the rotation and mirror across the pitch width to replicate the camera angle in the video clip).

``` r
soccerPitchHalf() +
  geom_point(data = ss, aes(x = 68 - location.y, y = location.x), col = "red", size = 4) +
  geom_segment(data = ss, aes(x = 68 - location.y, xend = 68 - shot.end_location.y, y = location.x, yend = shot.end_location.x))
```

![](/assets/2019-01-15-adjusted-xG_files/unnamed-chunk-8-1.png)

If we extract the xG of each shot, we can calculate the probabilities of each permutation of events as in our first example.

``` r
xg <- ss$xg

xg[1] #P(G_1)
```

    ## [1] 0.1501869

``` r
(1 - xg[1]) * xg[2] #P(M_1 & G_2)
```

    ## [1] 0.4045153

``` r
(1 - xg[1]) * (1 - xg[2]) #P(M_1 & M_2)
```

    ## [1] 0.4452978

``` r
(1 - xg[1]) * (1 - xg[2]) * xg[3] #P(M_1 & M_2 & G_3)
```

    ## [1] 0.1120198

``` r
(1 - xg[1]) * (1 - xg[2]) * (1 - xg[3]) #P(M_1 & M_2 & M_3)
```

    ## [1] 0.333278

``` r
1 - ((1 - xg[1]) * (1 - xg[2]) * (1 - xg[3])) #P(G_1 | G_2 | G_3)
```

    ## [1] 0.666722

Or more simply, subtract the product of all xGs from 1:

``` r
xg_total <- (1 - prod(1 - xg))

xg_total
```

    ## [1] 0.666722

Finally, not all shots in the sequence were created equal, so we don't want the xG for each shot to just be 0.666722 / 3 = 0.2222407. We should therefore adjust the xG of each shot as a relative proportion of the total conditional probability.

``` r
# 
xg_total * (xg / sum(xg))
```

    ## [1] 0.1140787 0.3615628 0.1910806

The whole thing can be achieved in two lines like so:

``` r
ss %>%
  mutate(xg_total = (1 - prod(1 - xg))) %>%
  mutate(xg_adj = xg_total * (xg / sum(xg)))
```

------------------------------------------------------------------------

This is the long and short of what's been added to the [`soccermatics`](https://github.com/JoGall/soccermatics) functions which use xG.

`soccerShotmap` can compare raw xG for England...

``` r
dat %>% 
  filter(team.name == "England") %>% 
  soccerShotmap(adj = F, theme = "dark")
```

![](/assets/2019-01-15-adjusted-xG_files/unnamed-chunk-13-1.png)

or adjusted xG for England.

``` r
dat %>% 
  filter(team.name == "England") %>% 
  soccerShotmap(adj = T, theme = "dark")
```

![](/assets/2019-01-15-adjusted-xG_files/unnamed-chunk-14-1.png)

`soccerxGTimeline` can show the cumulative xG over the course of the game for both teams, either raw xG...

``` r
soccerxGTimeline(dat, adj = F)
```

or adjusted xG.

![](/assets/2019-01-15-adjusted-xG_files/unnamed-chunk-15-1.png)


``` r
soccerxGTimeline(dat, adj = T)
```

![](/assets/2019-01-15-adjusted-xG_files/unnamed-chunk-16-1.png)
