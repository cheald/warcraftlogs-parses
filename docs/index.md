---
title: Parsing WarcraftLogs for fun and profit. Well, not profit.
layout: default
---

## How does my spec scale?

I initially started this project by wondering how well Outlaw rogues scaled relative to Assassination and Subtlety rogues. Community wisdom holds that Outlaw doesn't scale well, but why rely on that when we can go straight to the data? [WarcraftLogs](https://warcraftlogs.com) provides scads of data on the performance of various specs in prolonged raid encounters, long the "gold standard" of performance benchmarking.

The procedure is basically to pull the top 1,000 parses for each spec for each "bucket" of item levels from 840 to 880. Then, for an encounter, for each spec/ilvl bucket combo, we reject the top and bottom 5% of parses, and chart the data with a box plot, then fit it with both a local polynomial regression fitter and a linear regression fitter. This lets us eyeball how well a spec performs as gear levels increase.

We also plot the number of parses per ilvl per spec for the encounter, and provide plots of how well a spec scales over time (effectively, an approximation of the first derivative of the polynomial fit, taken by regressing against the deltas in the dataset), and finally, provide a very blunt linear regression per spec per encounter that attempts to compare how well spec X scales compared to spec Y for that encounter.

You'll find the code to grab and distill the data, as well as the RStudio notebooks used to generate this output at [https://github.com/cheald/warcraftlogs-parses](https://github.com/cheald/warcraftlogs-parses).

## The parses

* [Death Knight](death_knight.html)
* [Druid](druid.html)
* [Hunter](hunter.html)
* [Mage](mage.html)
* [Priest](priest.html)
* [Rogue](rogue.html)
* [Shaman](shaman.html)
* [Warlock](warlock.html)
* [Warrior](warrior.html)

<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-16557101-2', 'auto');
  ga('send', 'pageview');
</script>

