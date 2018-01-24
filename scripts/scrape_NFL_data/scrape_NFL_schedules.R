options(java.parameters="-Xmx4g")

library(rvest);
#library(XLConnect)

startwk <- 10
endwk <- 17
url_init <- "http://www.espn.com/nfl/schedule/_/seasontype/2/week/"


dat9 <- data.frame(week=character(),
                 weekday=character(),
                 datetime=character(),
                 awayteam=character(),
                 hometeam=character(),
                 stringsAsFactors=FALSE)

dat5 <- data.frame(week=character(),
                   weekday=character(),
                   datetime=character(),
                   awayteam=character(),
                   stringsAsFactors=FALSE)


for (wk in startwk:endwk){
  # get url for this week
  url_wk <- paste0(url_init, wk)
  
nfl_sched <- read_html(url_wk);

awayteam <- html_nodes(nfl_sched, xpath = "//*[@id='sched-container']/div/table/tbody/tr/td[1]/a/abbr") %>% html_text()

hometeam <- html_nodes(nfl_sched, xpath = "//*[@id='sched-container']/div/table/tbody/tr/td[2]/div/a/abbr") %>% html_text()

datetime <- html_nodes(nfl_sched, xpath = "//*[@id='sched-container']/div/table/tbody/tr/td[3]/a") %>% html_text()

byeteams <- html_nodes(nfl_sched, xpath = "//tr[contains(@class, 'byeweek')]/td/a/abbr") %>% html_text()

awayteam <- gsub("NE", "NEE", awayteam)
awayteam <- gsub("WSH", "WAS", awayteam)
awayteam <- gsub("SD", "SAD", awayteam)
awayteam <- gsub("TB", "TAB", awayteam)
awayteam <- gsub("SF", "SAF", awayteam)
awayteam <- gsub("GB", "GRB", awayteam)
awayteam <- gsub("LA", "LOA", awayteam)
awayteam <- gsub("KC", "KAC", awayteam)
awayteam <- gsub("NO", "NEO", awayteam)
awayteam <- gsub("JAX", "JAC", awayteam)


hometeam <- gsub("NE", "NEE", hometeam)
hometeam <- gsub("WSH", "WAS", hometeam)
hometeam <- gsub("SD", "SAD", hometeam)
hometeam <- gsub("TB", "TAB", hometeam)
hometeam <- gsub("SF", "SAF", hometeam)
hometeam <- gsub("GB", "GRB", hometeam)
hometeam <- gsub("LA", "LOA", hometeam)
hometeam <- gsub("KC", "KAC", hometeam)
hometeam <- gsub("NO", "NEO", hometeam)
hometeam <- gsub("JAX", "JAC", hometeam)


byeteams <- gsub("NE", "NEE", byeteams)
byeteams <- gsub("WSH", "WAS", byeteams)
byeteams <- gsub("SD", "SAD", byeteams)
byeteams <- gsub("TB", "TAB", byeteams)
byeteams <- gsub("SF", "SAF", byeteams)
byeteams <- gsub("GB", "GRB", byeteams)
byeteams <- gsub("LA", "LOA", byeteams)
byeteams <- gsub("KC", "KAC", byeteams)
byeteams <- gsub("NO", "NEO", byeteams)
byeteams <- gsub("JAX", "JAC", byeteams)


datetime <- gsub("T", " ", datetime)
datetime <- gsub("Z", "", datetime)

#datetime1 <- as.POSIXct(datetime, tz="GMT")
#datetime2 <- format(datetime1, tz="America/New_York",usetz=FALSE)

#weekday <- weekdays(as.Date(datetime2))

if(nchar(wk) == 1) {
  wknbr <- paste0("170", wk)
} else {
  wknbr <- paste0("17", wk)
}

#df9 <- data.frame(week = wknbr, weekday = weekday, datetime = datetime2, awayteam = awayteam, hometeam = hometeam, stringsAsFactors=FALSE)

df9 <- data.frame(week = wknbr, weekday = "Sunday", datetime = "4PM", awayteam = awayteam, hometeam = hometeam, stringsAsFactors=FALSE)

if(length(byeteams) != 0) {

df5 <- data.frame(week = wknbr, weekday = "Open", datetime = "null", awayteam = byeteams, stringsAsFactors=FALSE)

dat5 <- rbind(dat5, df5)
}
    # combine the data
    dat9 <- rbind(dat9, df9)

}

dat9
dat5

# write out to csv
write.csv(dat9, "game_schedules_2017.csv", row.names=TRUE, na="")

write.csv(dat5, "bye_weeks_2017.csv", row.names=TRUE, na="")
