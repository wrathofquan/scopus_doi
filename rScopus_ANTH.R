devtools::install_github("muschellij2/rscopus")
library(rscopus)
library(tidyverse)

# set api key 
set_api_key("542d37a9a4c8a13fa5c536d809d6dc2b")

# all ids
auth_IDs <- c(7403929333,6602245152,6602659025,25655162000,8047132400,7101992203,6507674939,35519275100,9276906000,6602921721,18436971000,
              6603298629,7006568493,57192260796,7102490362,8770813300,6701654805,7407670808,15830127900,14058535200,6602718522,55887917600,
              55533596600,6701454029,6602109336)
              
pii <- df$pii



## loop over authorIDs
df = NULL
for (id in auth_IDs){
  x <- author_df(au_id = id, all_author_info = TRUE)
  df = bind_rows(df, data.frame(x))
  
}

write_csv(df, "scopus_DOI_complete.csv")


## 
doi <- na.omit(df$doi)
abs <- abstract_retrieval(id = doi[2], identifier="doi")
  
x <- abstract_retrieval("10.1215/08992363-9-2-161", identifier= "doi")


df_from_list <- data.frame(matrix(unlist(x), nrow=length(x), byrow=T))



## dataframe of references
references <- as.data.frame(abs$content$`abstracts-retrieval-response`$item$
                              bibrecord$tail$bibliography$reference) %>% 
  select(starts_with("ref.fulltext"))%>%  
gather(id, reference, starts_with("ref.fulltext"))

