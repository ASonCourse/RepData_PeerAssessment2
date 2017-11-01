# We need the data.table package to import the StormData.csv.bz2 file reaonable
# quickly.

install.packages("data.table")
library(data.table)

# Onderstaande is een shell / terminal commando wat input vormt voor fread...
# Werkt als een tierelier —— en veel sneller dan read.csv:
# Read 902297 rows and 37 (of 37) columns from 0.523 GB file in 00:00:10.
# Enkele seconden versus minuten...
# Optie -c is nodig om resultaat van bunzip2 naar standard output te dirigeren...
fread('bunzip2 -ck StormData.csv.bz2')

