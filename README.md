SAS macros that I made many years ago and that I have found useful when working with the Swedish population registries.

%DateNum
SAS macro for transforming alphanumeric dates (YYYYMMDD) into numeric SAS dates.
The macro "corrects" dates that are incomplete or "wrong" into dates that can be stored as a SAS date.

%PINq
SAS macro for checking if a personal identity number or a co-ordination number is formally correct. This only 
implies that the number has a valid date and that the check digit is correct, given the other digits. It does not 
necessarily mean that the number is in use or has been in use by the a person or that is has been issued by the Tax Agency.  

Information from the Tax Agency about population registration in Sweden in general and the personal identity number 
and the co-ordination number.  
http://www.skatteverket.se/privat/sjalvservice/blanketterbroschyrer/broschyrer/info/717b.4.39f16f103821c58f680008017.html
http://www.skatteverket.se/privat/sjalvservice/blanketterbroschyrer/broschyrer/info/704.4.39f16f103821c58f680007993.html
http://www.skatteverket.se/privat/sjalvservice/blanketterbroschyrer/broschyrer/info/707.4.39f16f103821c58f680007997.html
