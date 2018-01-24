options(java.parameters="-Xmx4g")

library(rvest);
#library(XLConnect)

startwk <- 1
endwk <- 65
url_init <- "https://www.uchealth.org/Pages/PNRS/ProvidersSearchResult.aspx?Page="

pager <- "_50"

dat9 <- data.frame(docname=character(),
                 specialty=character(),
                 gender=character(),
                 location=character(),
                 stringsAsFactors=FALSE)

for (wk in startwk:endwk){
  # get url for this page
  url_wk <- paste0(url_init, wk, pager)
  
nfl_sched <- read_html(url_wk);

docname <- html_nodes(nfl_sched, xpath = "//*[@class='link-button']/label/a/span[contains(@itemprop, 'name')]") %>% html_text()

# docgender <- html_nodes(nfl_sched, xpath = "//div[contains(@itemprop, 'gender')]/p") %>% html_text()

# doclocation <- html_nodes(nfl_sched, xpath = "//div[contains(@class, 'col-sm-8 sm-plus-trim-left trim-right')]/p/a") %>% html_text()

n <- 50

if (wk == 65){
  n <- 18
}

specialty <- character(n)

location <- character(n)

gender <- character(n)

for (i in 1:n){

y <- paste0("//*[@id='list']/div[",i,"]/div/div[2]/div[2]/div/div")  

z <- paste0("//*[@id='list']/div[",i,"]/div/div[2]/div[4]/div[2]/div/div[2]/div/p/a")  

x <- paste0("//*[@id='list']/div[",i,"]/div/div[2]/div[4]/div[1]/div/div/div/p")  

# docspecialty <- html_nodes(nfl_sched, xpath = "//div[contains(@class, 'search-result-specialties')]") %>% html_text()
docspecialty <- html_node(nfl_sched, xpath = y) %>% html_text()

if (!is.na(docspecialty))
{
  specialty[[i]] <- docspecialty
} else {
  specialty[[i]] <- "none"
}

doclocation <- html_node(nfl_sched, xpath = z) %>% html_text()

if (!is.na(doclocation))
{
  location[[i]] <- doclocation
} else {
  location[[i]] <- "none"
}

docgender <- html_node(nfl_sched, xpath = x) %>% html_text()

if (!is.na(docgender))
{
  gender[[i]] <- docgender
} else {
  gender[[i]] <- "none"
}

}

# awayteam <- gsub("NE", "NEE", awayteam)
# awayteam <- gsub("WSH", "WAS", awayteam)
# awayteam <- gsub("SD", "SAD", awayteam)
# awayteam <- gsub("TB", "TAB", awayteam)


df9 <- data.frame(docname = docname, specialty = specialty, gender = gender, location = location, 
                  stringsAsFactors=FALSE)

    # combine the data
    dat9 <- rbind(dat9, df9)

}

# write out to csv
write.csv(dat9, "uchealth_docs_2016.csv", row.names=FALSE, na="")
