library(ggplot2)
theme_set(theme_bw())
library(reshape2)
library(dplyr)
source("R/load.R")

str(convprog)
summary(convprog)

## Modalidades x tempo

summary(convprog$TX_MODALIDADE)

anos = convprog %>% 
  select(ANO_CONVENIO, ANO_PROPOSTA, TX_MODALIDADE) %>% 
  melt(id.vars = c("TX_MODALIDADE")) 

anos %>% 
  filter(TX_MODALIDADE %in% c("Contrato de Repasse", "Convênio"), variable == "ANO_CONVENIO") %>% 
  select(TX_MODALIDADE, value) %>% 
  group_by(TX_MODALIDADE, value) %>% 
  summarise(n = n()) %>%
  ggplot(aes(x = value, y = n, colour = TX_MODALIDADE)) + geom_line() 

anos.ag = anos %>% 
  group_by(variable, value) %>% 
  summarise(n = n())
summary(anos.ag)

ggplot(anos.ag, aes(x = value, y = n, colour = variable)) + 
  geom_line() + 
  geom_point()

orgaos = convprog %>% 
  select(NM_ORGAO_CONCEDENTE) %>% 
  group_by(NM_ORGAO_CONCEDENTE) %>%
  summarise(n = n())

orgaos %>% filter(n > 15) %>% 
  ggplot(aes(x = NM_ORGAO_CONCEDENTE, y = n)) +
  geom_bar(stat = "identity") + 
  coord_flip()


#### Zoom na PB

pb = convprog %>% 
  filter(UF_PROPONENTE == "PB") %>% 
  select(NM_ORGAO_SUPERIOR, 
         NM_MUNICIPIO_PROPONENTE, 
         NM_PROGRAMA, 
         VL_GLOBAL,
         VL_REPASSE,
         VL_CONTRAPARTIDA_TOTAL,
         TX_OBJETO_CONVENIO,
         QT_ADITIVOS,
         QT_PRORROGAS)
summary(pb)

cg = pb %>% filter(NM_MUNICIPIO_PROPONENTE == "CAMPINA GRANDE")
pb.cidade = pb %>% filter(NM_ORGAO_SUPERIOR == "MINISTERIO DAS CIDADES", NM_MUNICIPIO_PROPONENTE == "CAMPINA GRANDE")
pb.privadas = pb %>% filter(TX_ESFERA_ADM_PROPONENTE == "PRIVADA")

# Olhar: NM_PROGRAMA VL_GLOBAL VL_REPASSE VL_CONTRAPARTIDA_TOTAL TX_OBJETO_CONVENIO QT_ADITIVOS QT_PRORROGAS

