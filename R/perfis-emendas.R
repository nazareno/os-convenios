library(ggplot2)
theme_set(theme_bw())
library(reshape2)
library(stringr)
library(dplyr)
source("R/load.R")

names(emendas)
names(emendas.siga)

# Subconjunto do SICONV
ew = emendas %>% 
  filter(UF_PROPONENTE == "PB") %>% 
  select(NR_CONVENIO, 
         TX_MODALIDADE, 
         TX_SITUACAO, 
         NM_PROGRAMA, 
         NM_PROPONENTE, 22, 23, 28, 19, 
         NR_EMENDA_PARLAMENTAR)
ew$NR_EMENDA_PARLAMENTAR = as.numeric(levels(ew$NR_EMENDA_PARLAMENTAR))[ew$NR_EMENDA_PARLAMENTAR]
summary(ew)

## --------------
# Do Siga Brasil:
## --------------

# subconjunto dos dados
sigaw = emendas.siga %>% 
  filter(UF == "PB") %>% 
  select(Emenda, Autor, Partido, Autor..UF., Autorizado, Ação...Subtítulo)
sigaw$Autor = droplevels(sigaw$Autor)
sigaw$Ação...Subtítulo = droplevels(sigaw$Ação...Subtítulo)
sigaw$acao.ab = str_sub(sigaw$Ação...Subtítulo, 0, 30)

# visão deles
NROW(sigaw)
sort(table(sigaw$Autor), decreasing = TRUE)
sigaw$Ação...Subtítulo %>%
  table() %>% 
  as.data.frame() %>% 
  filter(Freq > 10) %>% 
  arrange(desc(Freq))

sigaw %>% 
  group_by(Autor, Ação...Subtítulo) %>% 
  tally(sort = TRUE) %>% 
  slice(1:3) %>% 
  View()
  #ggplot(aes(x = acao.ab, y = n, colour = Autor)) + 
  #  geom_point()

# Contagens de palavras:

txt_emendas = str_replace_all(sigaw$Ação...Subtítulo, pattern = "[[:punct:]]", "")
txt_emendas = str_replace_all(txt_emendas, pattern = "\\s+", " ")
txt_list = str_split(txt_emendas, pattern = " ")
# vector of words in titles
title_words = unlist(txt_list)

library(tm)
sw = stopwords("pt-br")
title_words = title_words[!(tolower(title_words) %in% sw)]

top_freqs = data.frame(word = as.factor(title_words)) %>% 
  group_by(word) %>% 
  tally(sort = TRUE) %>% 
  slice(1:50)

library(wordcloud)
wordcloud(top_freqs$word, top_freqs$n, scale=c(4,.2), min.freq=6,
          max.words=Inf, random.order=FALSE, rot.per=.15)

# Fim das palavras

# Tentando comparar deputados

sigaw %>% 
  select(Autor, acao.ab) %>% 
  ggplot(aes(x = acao.ab)) + 
    geom_bar() + 
    facet_wrap(~ Autor) + 
    coord_flip()
  

#########
# Cruzando Siconv e Siga
#########

# Em comum
NROW(intersect(ew$NR_EMENDA_PARLAMENTAR, sigaw$Emenda))

joined = sigaw %>% inner_join(ew, by = c("Emenda" = "NR_EMENDA_PARLAMENTAR"))


