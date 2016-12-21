## Read CSV file and put into data frame.
refine <- read.csv("\..refine_original.csv")

##install dplyr
install.packages("dplyr")
library("dplyr")
##install tidyr
install.packages("tidyr")
library("tidyr")

##1: clean up brand names
company_lower <- tolower(refine$company)
x <- company_lower
x1 <- gsub("f","ph",x)
x2 <- gsub("ili","illi",x1)
x3 <- gsub("phll","phill",x2)
x4 <- gsub("lp","lip",x3)
x5 <- gsub("phl","phill",x4)
x6 <- gsub("0","o",x5)
x7 <- gsub("ak zo", "akzo", x6)
company_clean <- gsub("lv","lev",x7)
company_new <- data_frame(company_clean) 
print(company_new)

##2: Separate product code and number
##Separate the product code and product number into separate columns i.e. 
##add two new columns called product_code and product_number, containing 
##the product code and number respectively

refine_new <- refine %>% 
        separate(Product.code...number, c("product_code", "product_number", "-"))


##3: 3: Add product categories
##You learn that the product codes actually represent the following product categories:
##p = Smartphone
##v = TV
##x = Laptop
##q = Tablet

##In order to make the data more readable, add a column with the product category for each record.

refine_3 <- 
        bind_cols(company_new, refine_new)

refine_3$product_category <- NA
refine_3$product_category[refine_3$product_code == "p"] <- "Smartphone"
refine_3$product_category[refine_3$product_code == "v"] <- "TV"
refine_3$product_category[refine_3$product_code == "x"] <- "Laptop"
refine_3$product_category[refine_3$product_code == "q"] <- "Tablet"

##4: 4: Add full address for geocoding
##You'd like to view the customer information on a map. In order to do that, 
##the addresses need to be in a form that can be easily geocoded. 
##Create a new column full_address that concatenates the three address fields (address, city, country), separated by commas.

refine_4 <-unite(refine_3, full_address, address:country, sep = ",")

View(refine_4)



##5: 5: Create dummy variables for company and product category
##Both the company name and product category are categorical variables i.e. they take only a fixed set of values. 
##In order to use them in further analysis you need to create dummy variables. Create dummy binary variables for 
##each of them with the prefix company_ and product_ i.e.
##Add four binary (1 or 0) columns for company: company_phillips, company_akzo, company_van_houten and company_unilever
##Add four binary (1 or 0) columns for product category: product_smartphone, product_tv, product_laptop and product_tablet
##install car package to facilitate creation of binary variables
install.packages("car")
library("car")

##create binary variables for company
refine_4$company_phillips<-recode(refine_4$company_clean, "'phillips'=1;else=0")
refine_4$company_akzo<-recode(refine_4$company_clean, "'akzo'=1;else=0")
refine_4$company_van_houten<-recode(refine_4$company_clean, "'van houten'=1;else=0")
refine_4$company_unilever<-recode(refine_4$company_clean, "'unilever'=1;else=0")

##create binary variables for product
refine_4$product_smartphone<-recode(refine_4$product_category, "'Smartphone'=1;else=0")
refine_4$product_tv<-recode(refine_4$product_category, "'TV'=1;else=0")
refine_4$product_laptop<-recode(refine_4$product_category, "'Laptop'=1;else=0")
refine_4$product_tablet<-recode(refine_4$product_category, "'Tablet'=1;else=0")

##drop old columns and output to csv file on hard drive
refine_5 <- subset(refine_4, select=-company)

refine_6 <- select(refine_5, company_clean:product_number,full_address:product_tablet)

write.csv(refine_6, "/Users/cavaughan99/Documents/personal stuff/R course/refine_clean.csv")

















