# packages installeren
install.packages("tidyverse",
                 "jsonlite",  # t.b.v.ophalen data UiC
                 "httr",      # 'content' functie
)

# packages laden
library(tidyverse)
library(jsonlite)
library(httr)

# onderdelen URL (template)
# base_url 	<-"https://utrecht.incijfers.nl/viewer/selectiontableasjson.ashx?"	# basis URL
# var  	<- [opzoeken via UiC]						# code gewenste variabele
# geo  	<- [utrecht/wijk/subwijk/buurt]					# uitsplitsen op gebied
# jaar 	<- [jaartal/jaartallen/mostrecent]				# jaartal(len)


# onderdelen URL (ingevuld voorbeeld)
base_url 	<-"https://utrecht.incijfers.nl/viewer/selectiontableasjson.ashx?"
var  	<- c("phhink125", "vmu_jmu_ervgez") 
geo  	<- "wijk"
jaar 	<- "2021,2022"  

# URL aanmaken
url_uic 	<- paste0(base_url,
                   "var=", var,
                   "&period=", jaar,
                   "&geolevel=", geo,
                   "&flip_table=false")

# data ophalen en in dataframe zetten
content_uic <- fromJSON(content(GET(url_uic), "text"))
df 	 <- data.frame(content_uic$rows) %>% set_names(nm = content_uic$headers$name)
print(df)


# data plotten

# kolomnamen netjes
colnames(df) <- c("Wijk", "Jaar", "Percentage")

# zet Percentage om naar numeric
df$Percentage <- as.numeric(df$Percentage)

#  gewenste volgorde van de wijken
wijk_volgorde <- c(
  "West",
  "Noordwest",
  "Overvecht",
  "Noordoost",
  "Oost",
  "Binnenstad",
  "Zuid",
  "Zuidwest",
  "Leidsche Rijn",
  "Vleuten-De Meern"
)

df$Wijk <- factor(df$Wijk, levels = wijk_volgorde)

# Plot met Jaar op de x-as, kleur per Wijk
ggplot(df, aes(x = Jaar, y = Percentage, fill = Wijk)) +
  geom_col(position = position_dodge(width = 0.8), width = 0.7) +
  scale_fill_viridis_d(option="plasma") +  # <-- ondersteunt 12 kleuren
  scale_y_continuous(
    breaks = seq(0, ceiling(max(df$Percentage, na.rm = TRUE)) + 2, by = 2),
    limits = c(0, ceiling(max(df$Percentage, na.rm = TRUE)) + 2),
    expand = c(0, 0)
  ) +
  labs(
    title = "Percentage huishoudens met inkomen tot 125% van sociaal minimum",
    subtitle = "Per wijk, vergelijking tussen 2022 en 2023",
    x = "Jaar",
    y = "% huishoudens",
    fill = "Wijk"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    panel.grid.major.y = element_line(color = "grey90"),
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    axis.line = element_line(color = "black"),
    plot.title = element_text(face = "bold", size = 15),
    plot.subtitle = element_text(size = 12),
    legend.position = "bottom",
    legend.box = "horizontal"
  )



