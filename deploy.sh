baseurl = "https://jogall.github.io"
publishDir = "docs"
DefaultContentLanguage = "en"
title = "Beautiful Hugo"
theme = "beautifulhugo"
metaDataFormat = "yaml"
pygmentsUseClasses = true
pygmentCodeFences = true
#disqusShortname = "XXX"
#googleAnalytics = "XXX"

[Params]
  subtitle = "Build a beautiful and simple website in minutes"
  logo = "img/avatar-icon.png"
  favicon = "img/favicon.ico"
  dateFormat = "January 2, 2006"
  commit = false
  rss = true
  comments = true
#  gcse = "012345678901234567890:abcdefghijk" # Get your code from google.com/cse. Make sure to go to "Look and Feel" and change Layout to "Full Width" and Theme to "Classic"

#[[Params.bigimg]]
#  src = "img/triangle.jpg"
#  desc = "Triangle"
#[[Params.bigimg]]
#  src = "img/sphere.jpg"
#  desc = "Sphere"
#[[Params.bigimg]]
#  src = "img/hexagon.jpg"
#  desc = "Hexagon"

[Author]
  name = "Some Person"
  email = "youremail@domain.com"
  facebook = "username"
  googleplus = "+username" # or xxxxxxxxxxxxxxxxxxxxx
  github = "username"
  twitter = "username"
  reddit = "username"
  linkedin = "username"
  xing = "username"
  stackoverflow = "users/XXXXXXX/username"
  snapchat = "username"
  instagram = "username"
  youtube = "user/username" # or channel/channelname
  soundcloud = "username"
  spotify = "username"
  bandcamp = "username"
  itchio = "username"

[[menu.main]]
    name = "Blog"
    url = ""
    weight = 1

[[menu.main]]
    name = "About"
    url = "page/about/"
    weight = 3

[[menu.main]]
    identifier = "samples"
    name = "Samples"
    weight = 2

[[menu.main]]
    parent = "samples"
    name = "Big Image Sample"
    url = "post/2017-03-07-bigimg-sample"
    weight = 1

[[menu.main]]
    parent = "samples"
    name = "Math Sample"
    url = "post/2017-03-05-math-sample"
    weight = 2

[[menu.main]]
    parent = "samples"
    name = "Code Sample"
    url = "post/2016-03-08-code-sample"
    weight = 3

[[menu.main]]
    name = "Tags"
    url = "tags"
    weight = 3

