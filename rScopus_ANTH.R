devtools::install_github("muschellij2/rscopus")
library(rscopus)
library(tidyverse)

# set api key 
set_api_key("cfbdabf9ea669f6a13e7e38185883073")

# all ids
auth_IDs <- c(7403929333,6602245152,6602659025,25655162000,8047132400,7101992203,6507674939,35519275100,9276906000,6602921721,18436971000,
              6603298629,7006568493,57192260796,7102490362,8770813300,6701654805,7407670808,15830127900,14058535200,6602718522,55887917600,
              55533596600,6701454029,6602109336)


## loop over authorIDs
df = NULL
for (id in auth_IDs){
  x <- author_df(au_id = id, all_author_info = TRUE)
  df = bind_rows(df, data.frame(x))
  
}

write_csv(df, "scopus_DOI_complete.csv")


## subset dois from df
doi <- na.omit(df$prism.doi)

#abstract retrieval API search to get the deep lists of bib. info. 
# this takes an argument by index
x <- abstract_retrieval(doi[2], identifier="doi")

## you can also do it by specifying doi
x <- abstract_retrieval("10.1017/S0010417503000239", identifier="doi")


## dataframe of references
references_for_oneArticle <- as.data.frame(x$content$`abstracts-retrieval-response`$item$
                                             bibrecord$tail$bibliography$reference) %>% 
  select(starts_with("ref.fulltext"))%>%  
  gather(id, reference, starts_with("ref.fulltext"))


write_csv(references_for_oneArticle, "references_for_oneArticle.csv")
