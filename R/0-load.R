# Dados do SICONV
programas <- read.csv2("data/14_Programas.csv")
convprog <- read.csv("data/01_ConveniosProgramas-sample.csv", sep=";")
emendas = read.csv("data/10_PropostasEmendaParlamentar.csv", sep=";")

# Emendas no Siga Brasil
emendas.siga <- read.csv("data/sigabrasil/emendas-tipo-autor-loa2016.csv", sep=";")
emendas.siga$ano = 2016

# Tomadas de conta especiais
tces <- read.csv("data/cgu/tce2015.csv")
tces$ano = 2015
