library(tidyverse)
library(rscopus)

set_api_key("59a2b0a8fd9b3c8cbc9bcdacd5b8f5c8")

##
df <- data.frame(read_csv('names.csv'))   

df <- data.frame(
  last_name = df$last,
  first_name = df$first,
  view = "METRICS",
  self_cite = "include",
  stringsAsFactors = F
  
)

#error handling. keep API running even when names don't match
possible_author_retrieval <- possibly(author_retrieval, otherwise = NA_real_)

# put api results into r object
results <- pmap(df, possible_author_retrieval)

# convert to dataframe
results_df <- as.data.frame(rscopus::gen_entries_to_df(results))
results_df <- results_df %>% select(3:9) 
results_df <- cbind(names, results_df)

results_df$df.content.author.retrieval.response.coredata.prism.url <- results_df$df.content.author.retrieval.response.coredata.prism.url %>% unlist()
results_df$df.content.author.retrieval.response.coredata.dc.identifier<- results_df$df.content.author.retrieval.response.coredata.dc.identifier %>% unlist()
results_df$df.content.author.retrieval.response.coredata.document.count <- results_df$df.content.author.retrieval.response.coredata.document.count %>% unlist()
results_df$df.content.author.retrieval.response.coredata.cited.by.count <- results_df$df.content.author.retrieval.response.coredata.cited.by.count %>% unlist()
results_df$df.content.author.retrieval.response.coredata.citation.count <- results_df$df.content.author.retrieval.response.coredata.citation.count %>% unlist()
results_df$df.content.author.retrieval.response.h.index <- results_df$df.content.author.retrieval.response.h.index %>% unlist()
results_df$df.content.author.retrieval.response.coauthor.count<- results_df$df.content.author.retrieval.response.coauthor.count %>% unlist()



#Check NAs
map(results_df, ~sum(is.na(.)))

#write to excel
write_csv(results_df, "final_scopus.csv")



