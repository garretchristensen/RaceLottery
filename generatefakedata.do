cd C:/Users/garret/Documents/RaceLottery
clear all
set seed 1492
set obs 26
gen firstname=""
replace firstname="April" in 1
replace firstname="Bob" in 2
replace firstname="Cathy" in 3
replace firstname="Doug" in 4
replace firstname="Elise" in 5
replace firstname="Fred" in 6
replace firstname="Geraldine" in 7
replace firstname="Hidalgo" in 8
replace firstname="Ismarelda" in 9
replace firstname="Joe" in 10
replace firstname="Katelyn" in 11
replace firstname="Lance" in 12
replace firstname="Ming" in 13
replace firstname="Nate" in 14
replace firstname="Octavia" in 15
replace firstname="Prince" in 16
replace firstname="Quinn" in 17
replace firstname="Rob" in 18
replace firstname="Suzy" in 19
replace firstname="Trayvon" in 20
replace firstname="Ursula" in 21
replace firstname="Von" in 22
replace firstname="Wendy" in 23
replace firstname="Xavier" in 24
replace firstname="Yolonda" in 25
replace firstname="Zebluon" in 26

expand 10
gen lastname=int(_n/26)+1
tostring lastname, replace
gen fullname=firstname+" "+lastname
gen female=mod(_n,2)
gen age=round(runiform(18,68),1)

*MOST PEOPLE HAVEN'T RUN BEFORE
gen temp=runiform()
gen finishes=0
replace finishes=1 if temp>0.8
replace finishes=2 if temp>0.9
replace finishes=3 if temp>0.95

*SOME PEOPLE HAVE DNF'd
replace temp=runiform()
gen starts=finishes
replace starts=starts+1 if temp>0.75
replace starts=starts+1 if temp>0.9

*APPLICATIONS ARE UNIFORM
gen applications=round(runiform(0,2),1)

*VOLUNTEERING IS A SEPARATE LOTTERY
outsheet using ./fakedata.csv, replace comma


