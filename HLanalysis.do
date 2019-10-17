cd C:/Users/garret/Documents/RaceLottery
clear all

tempfile hl17 hl18 hl19
import excel "HiLo Entrants by year.xlsx", firstrow sheet("2019")
gen name=First_Name+" "+Last_Name
duplicates list name
duplicates drop name, force
gen hl19=1
save `hl19'
import excel "HiLo Entrants by year.xlsx", firstrow sheet("2018") clear
gen name=First_Name+" "+Last_Name
duplicates list name
duplicates drop name, force
gen hl18=1
save `hl18'
import excel "HiLo Entrants by year.xlsx", firstrow sheet("2017") clear
gen name=First_Name+" "+Last_Name
duplicates list name
duplicates drop name, force
gen hl17=1
save `hl17'
duplicates drop name, force
merge 1:1 name using `hl18'

*Calc the return rate 1718
count if _merge==3
local return1718=r(N)

count if _merge==2
local new18=r(N)

count if _merge==1
local leave1718=r(N)

disp "Return Rate '17-'18 was "`return1718'/(`return1718'+`leave1718')

*Calc the return rate 1819
use `hl18', clear
merge 1:1 name using `hl19'
count if _merge==3
local return1819=r(N)

count if _merge==2
local new19=r(N)

count if _merge==1
local leave1819=r(N)

disp "Return Rate '18-'19 was "`return1819'/(`return1819'+`leave1819')


use `hl17', clear
merge 1:1 name using `hl19'
count if _merge==3
local return1719=r(N)

count if _merge==2
local new19=r(N)

count if _merge==1
local leave1719=r(N)
disp "Return Rate '17-'19 was "`return1719'/(`return1719'+`leave1719')

*************************************
*PUT THEM ALL TOGETHER
use `hl17', clear
merge 1:1 name using `hl18'
rename _merge merge1718
merge 1:1 name using `hl19'
rename _merge merge1819
replace hl17=0 if hl17==.
replace hl18=0 if hl18==.
replace hl19=0 if hl19==.

egen hltotal=rowtotal(hl17 hl18 hl19)

tab hltotal

move hl17 name
move hl18 name
move hl19 name
move hltotal name
export excel "HL2019runcount.xlsx", replace

**********************************************

*TO DO: Select a random 30%, to come back, 
*then give the rest 0 finishes, and use this data as the practice data
