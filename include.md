# High Lonesome 2020 Lottery

## Background

Welcome to the High Lonesome 2020 Lottery. This lottery is run with code written by Garret Christensen. The code is available on GitHub [here](http://www.github.com/garretchristensen/RaceLottery). The intent with using Github is to make the entire process transparent and reproducible.

### Lottery Design Choices
There's no perfect design, but we have a few values we'd like to try and implement.

* We want equal numbers of men and women
* We'd like to get a mix of new and veteran runners, without guaranteeing entry for either
* Previous unsuccessful applications should be the major determinant of selection
* We value volunteering and trail work
* We'd like new entrants to have a decent chance to run within a couple-few years

So here are the activities for which we will award points:

* Volunteer shifts *at* High Lonesome
* Extra volunteer trailwork beyond the eight hours required
* Previous applications for the race
* Previous finishes of the race


#### Chosen Model

We've chosen the following weighting method:

Tickets=2^(n+k+1)+2ln(v+t+1) where n, k, v, and t are defined as follows:

* Previous unsuccessful applications: Since you were last *picked* in the lottery, offered entry off the waitlist, or offered entry via the volunteer raffle, how many times have you entered the High Lonesome lottery, not including this year? Note that previous lottery entries need not be in successive years, but they reset to zero after you are picked in the lottery or are offered a slot via other means such as the waitlist or the volunteer raffle. n is equal to your previous unsuccessful applications, as defined above, with no maximum.


* Previous finishes: How many times have you finished High Lonesome 100?
We will award previous finishers a boost until they have finished High Lonesome three times; then the boost decreases. (We love returning runners, but after a while, it's cool to give others a chance.)
k is defined according to the following rule:
k=0 if finishes==0
k=0.5 if finishes==1
k=1 if finishes==2
k=1.5 if finishes==3
k=1 if finishes>=4

* Volunteer shifts: How many 8-hour shifts did you volunteer at the previous (current calendar year at the time of the lottery) running of High Lonesome? v is  the number of 8-hour shifts.

* Trailwork: How many solid 8-hour shifts of physical volunteer trail work have you completed since November 15 of last year? Volunteering or pacing at a race doesn't count. These trailwork hours must be over and above the 8-hours required for High Lonesome itself, they must be done with an approved land management agency or partner organization, and they must not be used in order to qualify for any other race or ultra--or court-mandated community service requirement ;). We obviously don't have a great way to verify this, so you're on your honor. Please don't abuse this. t is the number of 8-hour shifts.

# Implementing the Lottery
To run the lottery, all you have to do is enter the seed below. (It will show an error until you enter a number.) The actual seed will be determined by a live roll of nine 10-sided dice at Laws Whiskey House in Colorado on Friday November 15, each single die roll becoming a digit of the integer, in order. The seed primes R's pseudo-random number generator reproducibly. Before the seed is set, applicants can enter any integer they want to simulate the lottery. Well, almost. For computer-y reasons it can be any integer with absolute value less than or equal to 2,147,483,647.
