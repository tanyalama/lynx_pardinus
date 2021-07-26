library(readr)
library(dplyr)

#First, save the genotype call map and detailed table from Fluidigm in *.csv format. See placa_1_genotype_table_original.CSV as an example of how the callmap should look. 
#Then set working directory
dir1 <- file.path("/Volumes/GoogleDrive/My Drive/project_iberian_lynx/running_scripts_dani_david/")
setwd(dir1)

input_output <- "output_fluidigm_callmap_lince_portugal_jun_2021.csv"
#Edit the input_output line to match the name of the current genotype table
#input_output <- "placa_2_genotype_table_" #change the name!! ##no idea what this is supposed to do
input <- read.csv("/Volumes/GoogleDrive/My Drive/project_iberian_lynx/running_scripts_dani_david/output_fluidigm_callmap_lince_portugal_jun_2021.csv") 
inputraw<- input
#Name the first two columns "sample_order" and "sample_id"
colnames(input)[1]<- "sample_order"
colnames(input)[2]<- "sample_id"

#Import the SNP database in order to retrieve the SNP names from the scaffolds and positions
SNP_database <- read.csv2("/Volumes/GoogleDrive/My Drive/project_iberian_lynx/running_scripts_dani_david/SNPs_lista_suprema.csv")[,c(1,2,4)]
SNP_database
SNP_database$SCAFF_POSIT = paste(SNP_database$SCAFFOLD,SNP_database$POSITION,sep="_")

#Retrieve SNP names when necessary, but keep current names otherwise (i.e. for the sexual markers), and update the input with the new, proper names
input_SNP_names <- vector('character')
for (i in colnames(input)) {
  if (startsWith(i,"lp23.")==F) {
    input_SNP_names <- c(input_SNP_names,i)
  } else {
    input_SNP_names <- c(input_SNP_names,unlist(SNP_database[which(SNP_database$SCAFF_POSIT==i),1],use.names=F))
  }
}
input_SNP_names
colnames(input) <- input_SNP_names

#Duplicate all marker names (one for allele "a" and one for allele "b"), since we'll be converting from genotypes to alleles
duplicated_assay_markers <- rep(colnames(input[,-c(1:2)]),each=2)
markers_a <- paste0("a_",duplicated_assay_markers[c(T,F)])
markers_b <- paste0("b_",duplicated_assay_markers[c(F,T)])
duplicated_assay_markers <- c(colnames(input[,c(1:2)]),as.vector(rbind(markers_a,markers_b)))
duplicated_assay_markers

#Obtain a list of all strings in the dataframe that are equivalent to no alleles found (i.e. equivalent to "0:0")
strings_to_replace <- grep(":",unique(unlist(input[,-c(1:2)])),value=T,invert=T)
strings_to_replace #Update the input replacing all strings equivalent to "0:0" with "0:0"
for (string in strings_to_replace) { 
  input <- as.data.frame(lapply(input, function(x) { 
                                gsub(string, "0:0", x)
                                }
                              )
                        )
  }
input

#Split genotypes into separate alleles (i.e. convert from one column per SNP to two columns per SNP) and add the proper names obtained before
assay_genotypes <- input[,c(1:2)]
for (col in 3:ncol(input)) {
  assay_genotypes <- data.frame(lapply(cbind(assay_genotypes,data.frame(do.call('rbind', strsplit(as.character(input[,col]),':',fixed=TRUE)))), as.character), stringsAsFactors=FALSE)
}
colnames(assay_genotypes) <- duplicated_assay_markers
assay_genotypes

assay_genotypes[,3:194][assay_genotypes[,3:194]== "0"]<- "000"
assay_genotypes[,3:194][assay_genotypes[,3:194]== "A"]<- "001"
assay_genotypes[,3:194][assay_genotypes[,3:194]== "C"]<- "003"
assay_genotypes[,3:194][assay_genotypes[,3:194]== "T"]<- "004"
assay_genotypes[,3:194][assay_genotypes[,3:194]== "G"]<- "002"
assay_genotypes_keep<- assay_genotypes

library(data.table)
d <- rbind(data.table(assay_genotypes[, 2:3]), data.table(assay_genotypes[, 3:4]), data.table(assay_genotypes[, 5:6]), use.names = T)

#Save the modified table as a .csv file. Remember to rename the input_output at the beginning of the script when working with other inputs!!!!!
write_csv(assay_genotypes,paste0(input_output,"formatted.csv"))


##################
inputraw2<- input
input<- inputraw2
#for every column 3 to 98, change the format of that column to as.character.
for (col in 3:ncol(input)) {
  input[,i] <- as.character(input[,i])
}

input[,3]<- as.character(input[,3])

#for (col in 3:98(input)) {
  input[i][input[i] == "0:T"]<-"004004"
}

input["X2071053"][input["X2071053"] == "0:0"]<-as.character("000000")

input[,4:10][input[,4:10] == "0:0"]<-"000000"

data$genepop_x<- as.character(data$final_x)
data$genepop_y<- as.character(data$final_y)

####genepop_x

input[1:96,3:98][input[1:96,3:98] =="0:0"]<-as.factor("000000")
data["genepop_x"][data["genepop_x"] =="NoCall"]<-"000"
data["genepop_x"][data["genepop_x"] =="A"]<-"001"
data["genepop_x"][data["genepop_x"] =="G"]<-"002"
data["genepop_x"][data["genepop_x"] =="C"]<-"003"
data["genepop_x"][data["genepop_x"] =="T"]<-"004"

data["genepop_x"][data["genepop_x"] =="NoCall"]<-"000"



assay_genotypes



data["converted"][data["converted"] =="No Call" ]<-"NoCall:NoCall"

write.csv(input, "/Volumes/GoogleDrive/My Drive/project_iberian_lynx/running_scripts_dani_david/genepop_lince_portugal_jun_2021.csv")

write.table(genepop, file ="/Volumes/GoogleDrive/My Drive/project_iberian_lynx/github_iberian_lynx/input_gimlet_david-16-07-21.txt", row.names=F, col.names = F)
write.table(assay_genotypes, file ="/Volumes/GoogleDrive/My Drive/project_iberian_lynx/github_iberian_lynx/assay_genotypes_genepop_lince_portugal_jun_2021.txt", row.names=F, col.names = T)





#Get the alleles from each SNP in the assay in alphabetical order
assay_alleles <- vector("character")
for (col in seq(from=3, to=ncol(assay_genotypes), by=2)) {
  assay_alleles <- c(assay_alleles,paste(sort(unique(c(assay_genotypes[,col],assay_genotypes[,col+1]))[unique(c(assay_genotypes[,col],assay_genotypes[,col+1])) != 0]),collapse=""))
  names(assay_alleles) <- c(names(assay_alleles)[1:(length(names(assay_alleles))-1)],substr(colnames(assay_genotypes)[col],3,nchar(colnames(assay_genotypes)[col])))
  }
assay_alleles

#Import chip genotypes and rename the markers following the previous convention
chip_genotypes <- read_tsv("/Users/Dani/Dropbox/SNPs_lince/SNPs_lince_1471x329_ordered_scaffold_population_code.txt", col_names=T) #this file does not exist anywhere in the archive
chip_genotypes

markers_chip_a <- paste0("a_",colnames(chip_genotypes[,-c(1:8)])[c(T,F)])
markers_chip_b <- paste0("b_",colnames(chip_genotypes[,-c(1:8)])[c(T,F)])
duplicated_chip_markers <- c(colnames(chip_genotypes[,c(1:8)]),as.vector(rbind(markers_chip_a,markers_chip_b)))
duplicated_chip_markers

colnames(chip_genotypes) <- duplicated_chip_markers

#Subset the chip dataframe in order to keep just the assayed SNPs (note that the two sex markers weren't part of the original chip and thus won't be selected)
subset_chip_genotypes <- chip_genotypes %>%
select_(.dots=c(duplicated_chip_markers[c(1:8)],duplicated_assay_markers[which(duplicated_assay_markers %in% duplicated_chip_markers)]))
subset_chip_genotypes

#Get the alleles from each SNP in the chip in alphabetical order
chip_alleles <- vector("character")
for (col in seq(from=9, to=ncol(subset_chip_genotypes), by=2)) {
  chip_alleles <- c(chip_alleles,paste(sort(unique(unlist(c(subset_chip_genotypes[,col],subset_chip_genotypes[,col+1]),use.names=F))[unique(unlist(c(subset_chip_genotypes[,col],subset_chip_genotypes[,col+1]),use.names=F)) != 0]),collapse=""))
  names(chip_alleles) <- c(names(chip_alleles)[1:(length(names(chip_alleles))-1)],substr(colnames(subset_chip_genotypes)[col],3,nchar(colnames(subset_chip_genotypes)[col])))
}
chip_alleles
assay_alleles

#Add back the two sex-markers to the chip alleles table (with null alleles)
chip_alleles <- c(chip_alleles, "","")
names(chip_alleles) <- c(names(chip_alleles)[1:(length(names(chip_alleles))-2)],"SRY","ZFR")

#Build dataframe which compares the called alleles per marker between the chip and the assay. Won't be able to distinguish ambiguous cases (those were both alleles are the same in the two threads (e.g. "AT" and "TA"))
called_alleles <- data.frame("assay_alleles"=assay_alleles[order(names(assay_alleles))],"chip_alleles"=chip_alleles[order(names(chip_alleles))],stringsAsFactors=F)
called_alleles_comparison <- called_alleles %>%
  mutate(SNP=row.names(called_alleles), equal=ifelse((assay_alleles=="" | chip_alleles==""),NA,ifelse(assay_alleles==chip_alleles,T,F))) %>%
  dplyr::select(3,1,2,4)
called_alleles_comparison

#WARNING!!! No reference individuals were included in plate2, so all following sections will yield empty or nonsense tables since there won't be any individuals to compare. They can be skipped!

# #Build dataframe with all individuals both genotyped with the chip and the assay in order to learn which thread's being used in the ambiguous cases
# common_individuals <- subset_chip_genotypes$ID[subset_chip_genotypes$ID %in% assay_genotypes$sample_id == T]
# common_chip <- as.data.frame(filter(subset_chip_genotypes, ID %in% common_individuals)[,-c(1,3:8)])
# common_assay <- as.data.frame(filter(assay_genotypes, sample_id %in% common_individuals)[,-c(1)])
# 
# #WARNING! The following two loops might not work, but they DO work if you iterate manually (i.e. write row=1 in the console and then run the inner lines; repeat for each row)
# common_chip_genotypes <- data.frame("SNP"= substr(colnames(common_chip[,c(F,T)]),3,nchar(colnames(common_chip[,c(F,T)]))))
# for (row in common_chip) {
#   name <- unlist(common_chip[row,1],use.names=F)
#   allele_a_df <- data.frame("SNP"=substr(colnames(common_chip[row,c(F,T)]),3,nchar(colnames(common_chip[row,c(F,T)]))),"allele_a"=unlist(common_chip[row,c(F,T)],use.names=F))
#   allele_b_df <- data.frame("SNP"=substr(colnames(common_chip[row,c(T,F)][,-c(1)]),3,nchar(colnames(common_chip[row,c(T,F)][,-c(1)]))),"allele_b"=unlist(common_chip[row,c(T,F)][,-c(1)],use.names=F))
#   common_chip_genotypes <- left_join(common_chip_genotypes,allele_a_df,by=c("SNP"="SNP"))
#   common_chip_genotypes <- left_join(common_chip_genotypes,allele_b_df,by=c("SNP"="SNP"))
#   colnames(common_chip_genotypes)[length(colnames(common_chip_genotypes))-1] <- paste0(name,"_a_chip")
#   colnames(common_chip_genotypes)[length(colnames(common_chip_genotypes))] <- paste0(name,"_b_chip")
#   head(common_chip_genotypes)
# }
# 
# common_assay_genotypes <- data.frame("SNP"= substr(colnames(common_assay[,c(F,T)]),3,nchar(colnames(common_assay[,c(F,T)]))))
# for (row in common_assay) {
#   name <- unlist(common_assay[row,1],use.names=F)
#   allele_a_df <- data.frame("SNP"=substr(colnames(common_assay[row,c(F,T)]),3,nchar(colnames(common_assay[row,c(F,T)]))),"allele_a"=unlist(common_assay[row,c(F,T)],use.names=F))
#   allele_b_df <- data.frame("SNP"=substr(colnames(common_assay[row,c(T,F)][,-c(1)]),3,nchar(colnames(common_assay[row,c(T,F)][,-c(1)]))),"allele_b"=unlist(common_assay[row,c(T,F)][,-c(1)],use.names=F))
#   common_assay_genotypes <- left_join(common_assay_genotypes,allele_a_df,by=c("SNP"="SNP"))
#   common_assay_genotypes <- left_join(common_assay_genotypes,allele_b_df,by=c("SNP"="SNP"))
#   colnames(common_assay_genotypes)[length(colnames(common_assay_genotypes))-1] <- paste0(name,"_a_assay")
#   colnames(common_assay_genotypes)[length(colnames(common_assay_genotypes))] <- paste0(name,"_b_assay")
#   head(common_assay_genotypes)
# }
# 
# 
# #Generate a vector with rearranged column indices in order to better compare each individual's alleles between genotyping methods, and then join both the chip and the assay alleles using said order
# nr=length(common_individuals)
# 
# i_vector <- numeric(0)
# for (i in 1:nr) {
# i_vector <- c(i_vector,c(seq(2, nr*4, by=nr*2)+(i-1)*2))
# }
# i_vector
# 
# j_vector <- numeric(0)
# for (j in 1:nr) {
#   j_vector <- c(j_vector,c(seq(3, nr*4+1, by=nr*2)+(j-1)*2))
# }
# j_vector
# 
# columns_order <- c(1,rbind(i_vector,j_vector))
# columns_order
# 
# common_genotypes <- left_join(common_assay_genotypes,common_chip_genotypes,by=c("SNP"="SNP")) %>%
#   select(columns_order)
# common_genotypes <- common_genotypes[complete.cases(common_genotypes),]
# head(common_genotypes)
# 
# #For each individual and marker, check if the actual genotype is the same between both genotyping methods (i.e. check whether the genotyped thread is the same or the opposite) and add the information to called_alleles_
# for (individual in common_individuals) {
#   print(individual)
#   individual_genotypes <- common_genotypes[,c(1,grep(individual,colnames(common_genotypes)))]
#   assay_geno <- as.data.frame(apply(rbind(c(as.character(individual_genotypes[,2])),c(as.character(individual_genotypes[,3]))),2,sort),stringsAsFactors=F)
#   assay_geno <- paste0(assay_geno[1,],assay_geno[2,])
#   assay_geno
#   chip_geno <- as.data.frame(apply(rbind(c(as.character(individual_genotypes[,4])),c(as.character(individual_genotypes[,5]))),2,sort),stringsAsFactors=F)
#   chip_geno <- paste0(chip_geno[1,],chip_geno[2,])
#   chip_geno
#   individual_genotypes <- individual_genotypes %>% mutate(equal=ifelse(assay_geno=="00",NA,ifelse(assay_geno==chip_geno,T,F)))
#   colnames(individual_genotypes)[length(colnames(individual_genotypes))] <- paste0(individual,"_equal")
#   head(individual_genotypes)
#   common_genotypes <- left_join(common_genotypes,individual_genotypes[,c(1,6)],by=c("SNP"="SNP"))
#   }
# head(common_genotypes)
# 
# called_alleles_comparison <- left_join(called_alleles_comparison,common_genotypes)
write_csv(called_alleles_comparison, "called_alleles_comparison.csv")

#called_alleles_comparison[,c(1,4,17,18,19)]


#Build library with alleles and their complementaries to guide the subsequent conversion
alleles_library <- data.frame("replaced_allele"=c("0","A","G","C","T"),"new_allele"=c("0","T","C","G","A"),stringsAsFactors = F)
alleles_library

#Build genotype database with converted alleles when there's been a thread change between the chip genotyping and the current assays (i.e. when any of the comparisons in called_alleles_comparison is FALSE)
subset_chip_genotypes_converted <- as.data.frame(subset_chip_genotypes)
for (col in 9:ncol(subset_chip_genotypes_converted)) {
  actual_colname <- substr(colnames(subset_chip_genotypes_converted)[col],3,nchar(colnames(subset_chip_genotypes_converted)[col]))
  #if (FALSE %in% (called_alleles_comparison[which(called_alleles_comparison[,1]==actual_colname),c(4,17,18,19)])) { #this row works for plate1
  if (FALSE %in% (called_alleles_comparison[which(called_alleles_comparison[,1]==actual_colname),c(4)])) { #this row works for plate2
    for (row in 1:nrow(subset_chip_genotypes_converted)) {
      subset_chip_genotypes_converted[row,col] <- alleles_library[which(alleles_library[,1]==subset_chip_genotypes_converted[row,col]),2]
    }
  }
}
write_csv(subset_chip_genotypes_converted,"SNPs_lince_46(plate2)x329_converted_genotypes.csv")

#Import the plate1 table and join the 3 new SNPs in plate2 to the previous 46 SNPs in plate1. Save the result as a new genotype table with 49 markers
plate1 <- read.csv2("/Users/Dani/Dropbox/SNPs_application/TFM_barbara/20170807_GODOY_JA_PLACA_01_RESULTS/SNPs_lince_46(plate1)x329_converted_genotypes.csv")
plate2 <- subset_chip_genotypes_converted

plate1_and_plate2_49SNPs <- full_join(plate1,plate2[,c(2,which(colnames(plate1)!=colnames(plate2)))])
write_csv(plate1_and_plate2_49SNPs,"SNPs_lince_49x329_converted_genotypes.csv")




