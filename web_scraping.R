library(tidyverse)
library(rvest) #ใช้ทำ web scrape

#concept ในการดึง content คือต้องทราบชื่อกล่องที่อยู่ของ content นั้นๆ โดยการใช้ magic mouse เลื่อนดูที่ web แล้วมองหาที่ inspector

url <- "https://www.imdb.com/search/title/?groups=top_100&sort=user_rating,desc"

print(url)

#read html
imdb <- read_html(url)
imdb

#mivie title
titles <- imdb %>%
  html_nodes("h3.lister-item-header") %>% #html_node จะถึงตัวเดียว ถ้าเติม s จะดึงทุกตัว
  html_text2() #text2 มันจะลบ special char

titles[1:10]


##rating
ratings <- imdb %>%
  html_nodes("div.ratings-imdb-rating") %>%
  html_text2() %>%
  as.numeric()

rating[1:10]
#number of votes
num_votes <- imdb %>%
  html_nodes("p.sort-num_votes-visible") %>%
  html_text2()


#build a dataset
df <- data.frame(
  titles = titles,
  rating = ratings,
  num_vote = num_votes
)

head(df)



##**** spec phone project, Phone database
url2 <-read_html("https://specphone.com/Apple-iPhone-12-Pro-Max.html")

att <- url2 %>%
  html_nodes("div.topic") %>%
  html_text2()

detail <- url2 %>%
  html_nodes("div.detail") %>%
  html_text2()

data.frame(attribute = att, value = detail)
View(data.frame(attribute = att, value = detail))

## all iphone smartphone
apple_url <- read_html("https://specphone.com/brand/Apple")

#links to all smartphone
links <- apple_url %>%
  html_nodes("li.mobile-brand-item a") %>% #ที่ต้องมีเว้นแล้ว a คือ เว้น = ดึงทุกตัวที่มีตัว a ซึ่งมันจะต่อด้วย href
  html_attr("href")

full_links <- paste0("https://specphone.com", links) #เพิ่มคำเข้าไปข้างหน้า

result <- data.frame()

for(link in full_links[1:10]) {
  apple_topic <- link %>%
    read_html() %>%
    html_nodes("dev.topic") %>%
    html_text2()

  apple_detail <- link %>%
    read_html() %>%
    html_nodes("dev.topic") %>%
    html_text2()
  
  tmp <- data.frame(attribute = apple_topic,
                    value = apple_detail)
  result <- bind_rows(result, tmp)
  print("progress . . .")
}

print(result)

#write csv
write_csv(result, "result_apple.csv")






































