library(dplyr)
library(janitor)

setwd("/Users/ornscar/Documents/ORNELLA/pcdas_fiocruz/dados")

dados_originais <- read.csv("df_cnes_aula.csv")

dados_originais <- dados_originais %>% 
  clean_names() 

dados_originais <- dplyr::rename(
  dados_originais, 
  parto_vaginal = vaginal,
  idade_mae = idademae,
  peso_ao_nascer = peso,
  parto_no_hospital = hospital,
  sexo = masculino
)

sub_dados <- dados_originais %>% 
  select(
    parto_vaginal,
    idade_mae,
    peso_ao_nascer,
    parto_no_hospital,
    sexo
)

raca_cor <- cbind(
  dados_originais$amarela, 
  dados_originais$branca, 
  dados_originais$indigena, 
  dados_originais$parda, 
  dados_originais$preta
) %>% 
  as.data.frame()

colnames(raca_cor) <- c("amarela", "branca", "indigena", "parda", "preta")

raca_cor <- raca_cor %>% 
  mutate(raca_cor = ifelse(amarela == 1, "amarela",
                      ifelse(branca == 1, "branca",
                        ifelse(indigena == 1, "indigena",
                          ifelse(parda == 1, "parda", "preta"))))) %>% 
  select(raca_cor)

novos_dados <- cbind(sub_dados, raca_cor)

novos_dados$parto_vaginal <- factor(
  novos_dados$parto_vaginal,
  labels = c("não", "sim")
)

novos_dados$parto_no_hospital <- factor(
  novos_dados$parto_no_hospital,
  labels = c("não", "sim")
)

novos_dados$sexo <- ifelse(
  novos_dados$sexo == 1, "masculino", "feminino"
)

saveRDS(novos_dados, "dados_sinasc.rds")


