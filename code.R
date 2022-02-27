library(tidyverse)
tibble(urls = c("https://github.com/UniversalDependencies/UD_Classical_Chinese-Kyoto/blob/master/lzh_kyoto-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Czech-PDT/blob/master/cs_pdt-ud-train-l.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Estonian-EDT/blob/master/et_edt-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_French-GSD/blob/master/fr_gsd-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Hindi-HDTB/blob/master/hi_hdtb-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Italian-ISDT/blob/master/it_isdt-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Japanese-BCCWJ/blob/master/ja_bccwj-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Korean-Kaist/blob/master/ko_kaist-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Latin-ITTB/blob/master/la_ittb-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Norwegian-Bokmaal/blob/master/no_bokmaal-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Persian-PerDT/blob/master/fa_perdt-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Polish-PDB/blob/master/pl_pdb-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Portuguese-GSD/blob/master/pt_gsd-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Romanian-Nonstandard/blob/master/ro_nonstandard-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Russian-SynTagRus/blob/master/ru_syntagrus-ud-train-a.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Catalan-AnCora/blob/master/ca_ancora-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Icelandic-IcePaHC/blob/master/is_icepahc-ud-train.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_German-HDT/blob/master/de_hdt-ud-train-a-1.conllu?raw=true",
                "https://github.com/UniversalDependencies/UD_Spanish-AnCora/blob/master/es_ancora-ud-train.conllu?raw=true")) %>% 
  mutate(language = str_extract(urls, "/UD_.*?-"),
         language = str_remove_all(language, "/UD_"),
         language = str_remove_all(language, "-$"),
         code = str_extract(urls, str_c(language, "-.*?/")),
         code = str_remove(code, language),
         code = str_remove_all(code, "[-/]")) ->
  lang_table

library(udpipe)
map(seq_along(lang_table$urls), function(i){
  print(i)
  udpipe_read_conllu(lang_table$urls[i]) %>% 
    group_by(doc_id) %>% 
    summarise(n_words = n(),
              n_tokens = length(unique(token)),
              language = lang_table$language[i],
              corpus_code = lang_table$code[i]) %>% 
    write_csv("results.csv", na = "", append = TRUE)
})
