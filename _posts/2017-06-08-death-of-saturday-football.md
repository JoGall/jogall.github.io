---
layout: post
title: The death of Saturday football?
subtitle: The effects of declining fixture density on reducing the number of matchday goals in the Premier League
date: "2017-06-12"
tags: [football / soccer, R]
output: 
  md_document:
    variant: markdown_github
    preserve_yaml: true
always_allow_html: yes
bigimg: /img/motd.jpg
share-img: https://jogall.github.io/assets/2017-06-08-death-of-saturday-football_files/unnamed-chunk-20-1.png

---

My [last post](https://jogall.github.io/2017-05-24-final-gameweek-extravaganzas/) looked at the highest number of goals scored in the final fixtures of a season, but this got me thinking: what about the highest scoring single **matchday**? In other words, what was the best Match of the Day ever? In this post I'll examine trends showing a diminishing numbers of goals scored per matchday in the top division over recent decades and look at the effects of declining 'fixture density' - the number of games played per day - to see if we can blame this on fixtures becoming more 'spread out' and the death of Saturday football in the top flight. (By the way, keep an eye out for inline footnotes in this and future posts, indicated by these numbers [^1].)

<!--- R configuration and post-specific webpage code --->

<!-- javascript to hide / show R code used to generate plot -->
<script language="javascript"> 
function toggle(num) {
var ele = document.getElementById("toggleText" + num);
var text = document.getElementById("displayText" + num);
if(ele.style.display == "block") {
ele.style.display = "none";
text.innerHTML = "show";
}
else {
ele.style.display = "block";
text.innerHTML = "hide";
}
} 
</script>

<!--- end --->

------------------------------------------------------------------------

To begin, we'll subset the top tier of the `england` dataframe from the R package `engsoccerdata` as in the last post:

``` r
devtools::install_github("jalapic/engsoccerdata")
library(engsoccerdata)
library(dplyr)
library(ggplot2)
library(DT)

# Update 'england' dataframe if there are new results
england <- rbind(england, subset(england_current(), !(Date %in% england$Date & home %in% england$home)))

#subset all-time top flight and prettify the season variable for plotting (e.g. '2016' -> '2016-17')
topflight <- subset(england, tier==1) %>%
  arrange(Date) %>%
  mutate(season = as.factor(paste0(Season, "-", substr(Season+1, 3, 4))))
```

------------------------------------------------------------------------

### Best ever Match Of The Day?

First the easiest question: most goals scored in a single day?

``` r
d1 <- topflight %>%
  group_by(Date) %>%
  summarise(Season = Season[1], goals = sum(totgoal), matches = n()) %>%
  arrange(-goals) %>%
```


    ## # A tibble: 10 x 4
    ##          Date Season goals matches
    ##        <date>  <dbl> <int>   <int>
    ##  1 1963-12-26   1963    66      10
    ##  2 1931-11-28   1931    62      11
    ##  3 1960-12-10   1960    60      11
    ##  4 1925-09-26   1925    59      11
    ##  5 1930-09-13   1930    59      11
    ##  6 1930-12-13   1930    59      11
    ##  7 1955-02-12   1954    59      11
    ##  8 1930-01-04   1929    58      11
    ##  9 1926-09-11   1926    57      11
    ## 10 1929-02-23   1928    57      11

    
The 66 goals gifted to us on Boxing Day 1963, and just look at those results:

``` r
subset(topflight, Date=="1963-12-26") %>%
  select(Date, home, visitor, FT)
```


    ##             Date                    home           visitor   FT
    ## 25309 1963-12-26               Blackpool           Chelsea  1-5
    ## 25310 1963-12-26                 Burnley Manchester United  6-1
    ## 25311 1963-12-26                  Fulham      Ipswich Town 10-1
    ## 25312 1963-12-26          Leicester City           Everton  2-0
    ## 25313 1963-12-26               Liverpool        Stoke City  6-1
    ## 25314 1963-12-26       Nottingham Forest  Sheffield United  3-3
    ## 25315 1963-12-26     Sheffield Wednesday  Bolton Wanderers  3-0
    ## 25316 1963-12-26    West Bromwich Albion Tottenham Hotspur  4-4
    ## 25317 1963-12-26         West Ham United  Blackburn Rovers  2-8
    ## 25318 1963-12-26 Wolverhampton Wanderers       Aston Villa  3-3

    
The only thing is, Match Of The Day (MotD) wasn't on the air then - although it did start only 8 months later so it's possible this Boxing Day bonanza helped push the BBC towards televising football highlights. Before we continue, I still feel obliged to answer the original question and find out what is the highest scoring matchday since MotD began, i.e. post-August 1964?

<!-- html to show R code --> 
<a id="displayText" href="javascript:toggle(3);" markdown="1">
(Click here to show R code)
</a>
<div markdown="1" id="toggleText3" style="display: none">

``` r
topflight %>%
  subset(Date >= "1964-08-22") %>%
  group_by(Date) %>%
  summarise(goals = sum(totgoal), matches = n()) %>%
  arrange(-goals) %>%
  head(10)
```
</div>


    ## # A tibble: 10 x 3
    ##          Date goals matches
    ##        <date> <int>   <int>
    ##  1 1965-12-11    56      11
    ##  2 1964-12-05    52      11
    ##  3 1966-10-01    50      11
    ##  4 1982-09-25    50      11
    ##  5 1965-09-18    49      11
    ##  6 1964-09-26    48      11
    ##  7 1965-10-16    48      11
    ##  8 1967-05-06    47      11
    ##  9 1993-05-08    47       9
    ## 10 1966-11-05    46      11
    

The slightly-less-exciting sum of 56 goals scored in December of the 1965-66 season:

``` r
subset(topflight, Date=="1965-12-11") %>%
  select(Date, home, visitor, FT)
```


    ##             Date              home              visitor  FT
    ## 26190 1965-12-11       Aston Villa              Everton 3-2
    ## 26191 1965-12-11  Blackburn Rovers     Northampton Town 6-1
    ## 26192 1965-12-11         Blackpool           Stoke City 1-1
    ## 26193 1965-12-11            Fulham              Burnley 2-5
    ## 26194 1965-12-11      Leeds United West Bromwich Albion 4-0
    ## 26195 1965-12-11    Leicester City  Sheffield Wednesday 4-1
    ## 26196 1965-12-11         Liverpool              Arsenal 4-2
    ## 26197 1965-12-11  Sheffield United    Nottingham Forest 1-1
    ## 26198 1965-12-11        Sunderland    Manchester United 2-3
    ## 26199 1965-12-11 Tottenham Hotspur              Chelsea 4-2
    ## 26200 1965-12-11   West Ham United     Newcastle United 4-3
    

------------------------------------------------------------------------

### So teams are scoring less nowadays, right?

The first thing I notice when looking at the top table is that almost all of the highest scoring matchdays are from over 50 years ago; in fact, you have to look all the way down to the 83rd highest entry to find a fixture from the 1970s or later. If we plot the data we can visualise this decline in goals per matchday (red line shows a linear regression fitted to the data, blue line a [smoothed Loess curve](https://en.wikipedia.org/wiki/Local_regression)):

<!-- html to show R code --> 
<a id="displayText" href="javascript:toggle(4);" markdown="1">
(Click here to show R code)
</a>
<div markdown="1" id="toggleText4" style="display: none">

``` r
#set default theme and increase font size for all plots
theme_set(theme_bw(base_size = 14))

ggplot(d1, aes(x = Date, y = goals)) +
  geom_point(alpha=0.2) +
  geom_smooth(method='loess', se=FALSE, col="blue", alpha=0.5) +
  geom_smooth(method='lm', se=FALSE, col="red", alpha=0.5) +
  scale_y_continuous(lim=c(0,70)) +
  ylab("Total goals on matchday")
```
</div>

![](/assets/2017-06-08-death-of-saturday-football_files/unnamed-chunk-7-1.png)

So why might this be happening? The most obvious explanation would be that there are simply fewer goals scored nowadays; after all, the modern game has evolved a lot in the last few decades in terms of both physicality and tactics. Let's check to see if the data supports this idea:

``` r
d2 <- topflight %>%
  group_by(Season) %>%
  group_by(Season) %>%
  summarise(goals.sum = sum(totgoal), goals.per.game = sum(totgoal) / n(), games = n())
```

The total number of goals scored has definitely declined since the 1950s...

<!-- html to show R code --> 
<a id="displayText" href="javascript:toggle(5);" markdown="1">
(Click here to show R code)
</a>
<div markdown="1" id="toggleText5" style="display: none">

``` r
ggplot(d2, aes(x = Season, y = goals.sum)) +
  geom_point() +
  geom_smooth(method='loess', se=FALSE, col="blue", alpha=0.5) +
  scale_x_continuous(breaks=c(1888, 1900, 1925, 1950, 1975, 2000, 2016)) +
  ylab("Total goals per season")
```
</div>

![](/assets/2017-06-08-death-of-saturday-football_files/unnamed-chunk-9-1.png)

...but standardising for the amount of games played per season shows this decline is less dramatic in terms of goals per game.

<!-- html to show R code --> 
<a id="displayText" href="javascript:toggle(6);" markdown="1">
(Click here to show R code)
</a>
<div markdown="1" id="toggleText6" style="display: none">

``` r
ggplot(d2, aes(x = Season, y = goals.per.game)) +
  geom_point() +
  geom_smooth(method='loess', se=FALSE, col="blue", alpha=0.5) +
  geom_smooth(method='lm', se=FALSE, col="red", alpha=0.5) +
  scale_y_continuous(lim=c(0,5)) +
  scale_x_continuous(breaks=c(1888, 1900, 1925, 1950, 1975, 2000, 2016)) +
  ylab("Goals per game")
```
</div>

![](/assets/2017-06-08-death-of-saturday-football_files/unnamed-chunk-10-1.png) 

In fact, it looks like the period from the 1950s to the mid-1960s was exceptionally high scoring, but that things have been relatively stable since the 1970s (there's actually a trend for a slight increase):

<!-- html to show R code --> 
<a id="displayText" href="javascript:toggle(7);" markdown="1">
(Click here to show R code)
</a>
<div markdown="1" id="toggleText7" style="display: none">

``` r
ggplot(subset(d2, Season >= 1970), aes(x = Season, y = goals.per.game)) +
  geom_point() +
  geom_smooth(method='lm', se=FALSE, col="red", alpha=0.5) +
  scale_y_continuous(lim=c(0,5)) +
  scale_x_continuous(breaks = c(1970, 1980, 1990, 2000, 2010, 2016)) +
  ylab("Goals per game")
```
</div>

![](/assets/2017-06-08-death-of-saturday-football_files/unnamed-chunk-11-1.png) 

So the number of goals per matchday looks to be decreasing but the number of goals per game doesn't? Surely then that suggests there are fewer **games per matchday** in the modern game compared to the pre-1970s... It seems to me nowadays that most weekends in the EPL feature only a handful of Saturday fixtures with a few being played instead on Sunday and sometimes Monday and/or Friday too. (The penultimate week of this season saw games played on Friday, Saturday, Sunday, Monday, Tuesday, Wednesday and Thursday!) Also, 3pm-5pm Saturday kick offs are now the only Premier League fixtures not to be televised live in the UK, a [blackout introduced by the Football League in the 1960s which aimed to protect attendances at lower league games](https://qz.com/867361/why-premier-league-soccer-games-cant-be-shown-at-3pm-in-the-uk/).

------------------------------------------------------------------------

### Fixture density

I can't recall ever seeing any data to support this idea though so let's investigate using our historical results. A straightforward way of measuring whether fixtures have become more 'spread out' could be to calculate '**fixture density score**' by dividing the expected number of games per season by the number of unique matchdays that season. So in the modern 20-team EPL featuring 38 gameweeks, the highest score would be 10.0 if all 10 matches each gameweek were played on a Saturday (380 / (38 × 1) = 380 / 38 = 10.0), and the lowest possible score would be 1.4 if the 10 matches each gameweek were spread out over all 7 days that week (380 / (38 × 7) = 380 / 266 = 1.43). To make it more intuitive, let's divide this number by the expected number of matches per gameweek (in the example above, 10 games per week) to let our score fall between 0 and 1 [^2].

``` r
fixdens <- england %>% 
  group_by(division, Season) %>%
  summarise(gameweeks = (n_distinct(home)-1) * 2,
            matchdays = n_distinct(Date)) %>%
  mutate(fixdens = gameweeks / matchdays)
```

Let's visualise fixture density over the years in the top fight first:

<!-- html to show R code --> 
<a id="displayText" href="javascript:toggle(8);" markdown="1">
(Click here to show R code)
</a>
<div markdown="1" id="toggleText8" style="display: none">

``` r
ggplot(subset(fixdens, division == 1), aes(x = Season, y = fixdens)) +
  geom_point() + 
#  geom_smooth(method='lm', col="red") +
  geom_smooth(method='loess') +
  scale_x_continuous(breaks = c(1888, 1920, 1950, 1980, 2016)) +
  ylab("Fixture density")
```
</div>

![](/assets/2017-06-08-death-of-saturday-football_files/unnamed-chunk-13-1.png)

There looks to be a trend of decreasing fixture density since the 1950s, and a particularly sharp dip since around 1992. Is this something to do with TV rights and increasing commercialisation of the top division in England? Let's have a look at fixture density in the lower divisions to compare [^3] [^4]:

``` r
fixdens <- fixdens %>%
  mutate(division2 = recode(division, "3a" = "3", "3b" = "3"))
```

<!-- html to show R code --> 
<a id="displayText" href="javascript:toggle(9);" markdown="1">
(Click here to show R code)
</a>
<div markdown="1" id="toggleText9" style="display: none">

``` r
ggplot(fixdens, aes(x = Season, y = fixdens)) +
  geom_point() + 
  geom_smooth(method='lm', formula=y ~ poly(x, 3, raw=TRUE)) +
  # stat_smooth(method = "gam", formula = y ~ s(x, k = 3)) +
  scale_x_continuous(breaks = c(1888, 1920, 1950, 1980, 2016)) +
  ylab("Fixture density") +
  facet_wrap(~ division2)
```
</div>

![](/assets/2017-06-08-death-of-saturday-football_files/unnamed-chunk-15-1.png) 

It looks like the second tier (present-day EFL Championship) has experienced a similar decline in fixture density since the 1950s, although this seems to be offset by increased fixture density in the 3rd and 4th tiers.

What about the distribution of matchdays across **days of the week** - can we see whether this decline come from a decrease in Saturday fixtures? We can use the `wday()` function from the handy [`lubridate`](https://cran.r-project.org/web/packages/lubridate/vignettes/lubridate.html) package to infer days of the week from our dates.

``` r
matchdays <- england %>%
  mutate(day = lubridate::wday(Date, label=TRUE)) %>%
  group_by(division, Season) %>%
  mutate(games = n()) %>%
  group_by(division, Season, day) %>%
  summarise(prop = n() / games[1], games = n()) %>%
  mutate(division2 = recode(division, "3a" = "3", "3b" = "3"))
```

<!-- html to show R code --> 
<a id="displayText" href="javascript:toggle(10);" markdown="1">
(Click here to show R code)
</a>
<div markdown="1" id="toggleText10" style="display: none">

``` r
ggplot(matchdays, aes(x = Season, y = prop, colour = day)) +
  geom_line() +
  scale_x_continuous(breaks = c(1888, 1920, 1950, 1980, 2016)) +
  scale_y_continuous(lim=c(0,1)) +
  ylab("Proportion of total games") +
  facet_wrap(~division2)
```
</div>

![](/assets/2017-06-08-death-of-saturday-football_files/unnamed-chunk-17-1.png)

It looks like there is a decline in the proportion of matches played on a Saturday in the top two divisions; in the top flight, from around three-quarters in the 1950s to around half now. And this seems to be accounted for by an increased proportion of Sunday fixtures in the top division and Tuesday fixtures in the second division. The lower leagues seem to tell the same story except with an increasing proportion of Saturdays being replaced by Tuesdays, but I'm thinking that this is probably due to an increased occurrance of two fixtures per week due to the increased number of teams in their leagues. So let's look at the **absolute number** of games instead of proportions:

<!-- html to show R code --> 
<a id="displayText" href="javascript:toggle(11);" markdown="1">
(Click here to show R code)
</a>
<div markdown="1" id="toggleText11" style="display: none">

``` r
ggplot(matchdays, aes(x = Season, y = games, colour = day)) +
  geom_line() +
  scale_x_continuous(breaks = c(1888, 1920, 1950, 1980, 2016)) +
  ylab("Absolute number of games") +
  facet_wrap(~division2)
```
</div>

![](/assets/2017-06-08-death-of-saturday-football_files/unnamed-chunk-18-1.png) 

Just as I suspected: there appears to be a greater number of total number in the lower leagues but the number of Saturday fixtures in the top division has definitely been declining since around 1980 - although we can see now this is not happened in the second tier.

------------------------------------------------------------------------

### In conclusion...

So whilst the number of goals per game is much the same in the EPL now as it was during the First Division in the 1970s, the absolute number of goals - the important thing - scored per matchday is decreasing as a result of decreasing fixture density, most noticeable fewer Saturday fixtures. Here's the last figure to show that Saturday's MotD is offering up less goals.

``` r
#subset Saturday fixtures only
d3 <- topflight %>%
  mutate(day = lubridate::wday(Date, label=TRUE)) %>%
  subset(day == "Sat") %>%
  group_by(Season) %>%
  summarise(games = n(), goals = sum(totgoal))
```

<!-- html to show R code --> 
<a id="displayText" href="javascript:toggle(12);" markdown="1">
(Click here to show R code)
</a>
<div markdown="1" id="toggleText12" style="display: none">

``` r
ggplot(d3, aes(x = Season, y = goals)) +
  geom_point() +
  geom_smooth(method='loess', se=FALSE, col="blue", alpha=0.5) +
  scale_x_continuous(breaks=c(1888, 1900, 1925, 1950, 1975, 2000, 2016)) +
  ylab("Total Saturday goals")
```
</div>

![](/assets/2017-06-08-death-of-saturday-football_files/unnamed-chunk-20-1.png) 


------------------------------------------------------------------------

[^1]: Inline footnotes pop up here thanks to a jQuery plugin, [bigfoot](http://bigfootjs.com/). 

[^2]: The equation explicitly: for a league consisting of a number of teams, ![equation](http://latex.codecogs.com/gif.latex?x), fixture density is calculated as the number of games per season ( ![equation](http://latex.codecogs.com/gif.latex?2%28x%20-%201%29%20%5Ccdot%20%5Cfrac%7Bx%7D%7B2%7D) ) divided by the number of unique matchdays (![equation](http://latex.codecogs.com/gif.latex?m)) divided by the expected number of games per gameweek ( ![equation](http://latex.codecogs.com/gif.latex?%5Cfrac%7Bx%7D%7B2%7D) ). This simplifies down to expected number of gameweeks per season divided by the number of unique matchdays per season ( ![equation](http://latex.codecogs.com/gif.latex?%5Cfrac%7B2%28x-1%29%7D%7Bm%7D) ).

[^3]: The roots of the third and fourth tiers of English football are [a bit of a nightmare](https://en.wikipedia.org/wiki/Football_League_Third_Division): the Third Division lasted only a single season before the league split into North and South divisions in 1921-22 and again merged in 1958-1959, with the top half of the league that season going on to form the new Third Division and the bottom half the new Fourth Division. To save on headaches, I've therefore combined division `3` (1920-21 Third Division + new Third Division) with `3a` (Third Division North) and `3b` (Third Division South), and left division 4 alone.

[^4]: I've sprung for a third order polynomial to fit the data as this curve appears to fit the data better and seems less biased by single outliers than a Loess curve.