library(ggplot2)
theme_set(theme_bw())
library(reshape2)
library(stringr)
library(dplyr)
source("R/load.R")

names(convprog)
head(convprog$NR_CONVENIO)

names(tces)
head(tces$Nº.Original.do.Instrumento)

# Exemplos de número de convênio que aparece nos arquivos de TCEs
777922 %in% convprog$NR_CONVENIO
777574 %in% convprog$NR_CONVENIO

convprog %>% filter(NR_CONVENIO == 777922) %>% View()
convprog %>% filter(NR_CONVENIO == 777574) %>% View()

tces %>% filter(Nº.Original.do.Instrumento == "777922/2012")

