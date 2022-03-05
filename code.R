library(tidyverse)
tibble(urls = c("https://github.com/UniversalDependencies/UD_Classical_Chinese-Kyoto/blob/master/lzh_kyoto-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Czech-PDT/blob/master/cs_pdt-ud-train-l.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Estonian-EDT/blob/master/et_edt-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_French-GSD/blob/master/fr_gsd-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Hindi-HDTB/blob/master/hi_hdtb-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Italian-ISDT/blob/master/it_isdt-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Japanese-BCCWJ/blob/master/ja_bccwj-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Korean-Kaist/blob/master/ko_kaist-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Croatian-SET/blob/master/hr_set-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Latin-ITTB/blob/master/la_ittb-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Norwegian-Bokmaal/blob/master/no_bokmaal-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Persian-PerDT/blob/master/fa_perdt-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Polish-PDB/blob/master/pl_pdb-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Galician-CTG/blob/master/gl_ctg-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Basque-BDT/blob/master/eu_bdt-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Chinese-GSDSimp/blob/master/zh_gsdsimp-ud-train.conllu",
                "https://github.com/UniversalDependencies/UD_Armenian-ArmTDP/blob/master/hy_armtdp-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Bulgarian-BTB/blob/master/bg_btb-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Portuguese-GSD/blob/master/pt_gsd-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Romanian-Nonstandard/blob/master/ro_nonstandard-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Indonesian-GSD/blob/master/id_gsd-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Latin-PROIEL/blob/master/la_proiel-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Naija-NSC/blob/master/pcm_nsc-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Russian-SynTagRus/blob/master/ru_syntagrus-ud-train-a.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Catalan-AnCora/blob/master/ca_ancora-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Dutch-Alpino/blob/master/nl_alpino-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Finnish-TDT/blob/master/fi_tdt-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Danish-DDT/blob/master/da_ddt-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Icelandic-IcePaHC/blob/master/is_icepahc-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_German-HDT/blob/master/de_hdt-ud-train-a-1.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Russian-Taiga/blob/master/ru_taiga-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Swedish-LinES/blob/master/sv_lines-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Spanish-AnCora/blob/master/es_ancora-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Afrikaans-AfriBooms/blob/master/af_afribooms-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Ancient_Greek-PROIEL/blob/master/grc_proiel-ud-train.conllu?raw=true")) %>% 
  mutate(language = str_extract(urls, "/UD_.*?-"),
         language = str_remove_all(language, "/UD_"),
         language = str_remove_all(language, "-$"),
         code = str_extract(urls, str_c(language, "-.*?/")),
         code = str_remove(code, language),
         code = str_remove_all(code, "[-/]")) ->
  lang_table

library(udpipe)
map(seq_along(lang_table$urls), function(i){
  print(lang_table$language[i])
  udpipe_read_conllu(lang_table$urls[i]) %>% 
    filter(upos != "PUNCT") %>% 
    group_by(doc_id) %>% 
    summarise(n_words = n(),
              n_tokens = length(unique(token)),
              language = lang_table$language[i],
              corpus_code = lang_table$code[i]) %>% 
    write_csv("results.csv", na = "", append = TRUE)
})

df <- read_csv("results.csv", col_names = FALSE)
colnames(df) <- c("doc_id", "n_words", "n_tokens", "language", "corpus_code")

df %>% 
  filter(!is.na(doc_id)) %>% 
  write_csv("results.csv", na = "")

df <- read_csv("results.csv")

df %>% 
  ggplot(aes(n_words, n_tokens))+
  geom_point()+
  facet_wrap(~language, scale = "free")+
  geom_smooth(method = "lm", se = FALSE)+
  labs(x = "количество слов", 
       y = "количество уникальных слов",
       caption = "данные корпусов Universal Dependencies")

# make data more suitable for linear regressian
df %>% 
  mutate(remove = (language == "Spanish" & n_words > 1500)|
           (language == "Russian" & n_words > 1500)|
           (language == "Classical_Chinese" & n_words > 7500)|
           (language == "Armenian" & n_words > 1300)|
           (language == "Catalan" & n_words > 2500)|
           (language == "Croatian" & n_words > 3000)|
           (language == "Italian" & n_words > 40000)) %>% 
  filter(!is.na(language),
         !(language %in% c("Basque", "Chinese", "Dutch", "Danish", "Finnish", "French", "Galician", "Hindi", "Indonesian", "Japanese", "Korean", "Latin", "Naija", "Norwegian", "Persian", "Polish", "Portuguese", "Romanian", "Swedish")),
         !remove) ->
  filtered_dataset

filtered_dataset %>% 
  select(-remove) %>% 
  write_csv("filtered_dataset.csv")

filtered_dataset %>% 
  ggplot(aes(n_words, n_tokens))+
  geom_point()+
  facet_wrap(~language, scale = "free")+
  geom_smooth(method = "lm", se = FALSE)+
  labs(x = "количество слов", 
       y = "количество уникальных слов",
       caption = "данные корпусов Universal Dependencies")

filtered_dataset %>% 
  group_by(language) %>% 
  group_map(~ broom::tidy(lm(n_tokens~0+n_words, data = .x)))
