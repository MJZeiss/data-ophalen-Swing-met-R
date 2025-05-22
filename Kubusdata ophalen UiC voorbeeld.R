# packages installeren
install.packages("tidyverse",
                 "jsonlite",  # t.b.v.ophalen data UiC
                 "httr",      # 'content' functie
)

# packages laden
library(tidyverse)
library(jsonlite)
library(httr)


# onderdelen URL (ingevuld voorbeeld)
base_url    <-"https://utrecht.incijfers.nl/viewer/selectiontableasjson.ashx?"
  var  <- "bevolking_leeftijdgeslacht" 
  geo  <- "wijk"
  dim   <- "dim_geslacht,dim_leeftijd1"
  jaar <- "mostrecent"  
  
  
  # URL aanmaken
  url_uic     <- paste0(base_url,
                        "var=", var,
                        "&period=", jaar,
                        "&geolevel=", geo,
                        "&dimlevel=", dim,
                        "&flip_table=false")
  
  # data ophalen en in dataframe zetten
  content_uic <- fromJSON(content(GET(url_uic), "text"))
  df     <- data.frame(content_uic$rows) %>% set_names(nm = content_uic$headers$name)
  print(df)
  