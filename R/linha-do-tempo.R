library(scales)

datas = convprog %>% 
  select(DT_ASSINATURA_CONVENIO, 
         # DT_INICIO_VIGENCIA, 
         DT_INCLUSAO_PROPOSTA, 
         DT_ULTIMO_EMPENHO) %>%
  melt(id.vars = c()) %>% 
  mutate(data = as.Date(cut(as.Date(value, format = "%d/%m/%Y"), breaks = "month")))

datas$quantas = 1

ggplot(data = datas,
       aes(data, quantas, colour = variable)) +
  stat_summary(fun.y = sum, # adds up all observations for the month
               geom = "line") + 
  scale_x_date(labels = date_format("%Y-%m"),
    breaks = "6 month", limits = as.Date(c('2009-01-01','2016-06-01'))) + 
  facet_grid(variable ~ .)

  
  