

library(mailR)
library(rvest)
library(magrittr)



# https://myaccount.google.com/lesssecureapps -- turn this on to allow less secure apps to send my stuff
# Need to turn back on 2-step verification, because can't have 2-step with less secure apps

# Also had to install 64 Bit Java for this PC manually

# Used http://selectorgadget.com/ plugin to find the right html nodes

ipchickenurl <- "https://ipchicken.com/" # This Website gets my ip address

htmldata <- read_html(ipchickenurl) # this reads the html of the website


### This section creates a variable that holds the text I need to get my ip address ###
htmltext<- htmldata %>% 
            html_node("b") %>% 
            html_text()

write(htmltext, file = "X:/Directory/To Write/newhtmltext.txt")

### One time use only - made an "oldhtmltext.txt" so that I only send an email when something changes ###

#write(htmltext, file = "X:/Directory/To Write/oldhtmltext.txt")

    #oldhtmltext<- htmldata %>% 
     # html_node("b") %>% 
     # html_text()
#oldhtmltext <- "testing"

#write("testing", file = oldhtmltextlocation)

# This creates a varaible "m" which is the actual matching regex from htmltext
m <- regexpr("\\d\\d\\d.\\d\\d\\d.\\d\\d.\\d\\d\\d", htmltext, perl = TRUE)

# Use regmatches on html text, and pass variable "m" to get the actual IP Address

ipaddress <- regmatches(htmltext, m) # value = TRUE)


### Now we add a condition so if there is no change, we don't send an email ###

oldhtmltextlocation <- "X:/Directory/To Write/oldhtmltext.txt"
newhtmltextlocation <-  "X:/Directory/To Write/newhtmltext.txt" 

oldhtmltext<- read.csv(oldhtmltextlocation, header = FALSE, stringsAsFactors = FALSE) # need strings as factors = FALSE to prevent error in comparing diff values
newhtmltext<- read.csv(newhtmltextlocation, header = FALSE, stringsAsFactors = FALSE)

#write(htmltext, file = "X:/Directory/To Write/oldhtmltext.txt")


#oldhtmltext[1] == newhtmltext[1]

#### Now we send the email so I know how to log in remotely ###
### I had to take away the 2-step verification and allow less secure apps to make this possible ###

if (oldhtmltext[1]  != newhtmltext[1]) {
         
        # Overwrite the old with the new so that it now becomes the old # 
        write(htmltext, file = "X:/Directory/To Write/oldhtmltext.txt")
  
        datetime <- Sys.time()
        
        
        ipmessage <- paste("My current IP is ", ipaddress, ". The current date/time is ", datetime,
                            " and in case the format is funky, here is the raw string: ", htmltext, sep = "")
        
        
        sender <- "some.email.address@gmail.com"
        recipients <- c("some.email.address@gmail.com")
        send.mail(from = sender,
                  to = recipients,
                  subject = "Latest IP Info",
                  body = ipmessage,
                  smtp = list(host.name = "smtp.gmail.com", port = 465,
                              user.name = "some.email.address@gmail.com",            
                              passwd = "passwordforemailaddress", ssl = TRUE),
                  authenticate = TRUE,
                  send = TRUE)

      } else {
               
                      }

# How to schedule an R script

# https://stackoverflow.com/questions/2793389/scheduling-r-script








