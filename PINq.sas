proc format;
value $PINqFmt
'A'='A: Not completely numeric'
'0'='0: Formally correct personal identity number'
'4'='4: Formally correct co-ordination number'
'8'='8: Not formally correct personal identity/co-ordination number'
'9'='9: Missing';
run;

%macro PINq(_PIN_,_PINq_);* / store source des='Check of personal identity and co-ordination number';

/* START: Specifying variables for PIN and PINq */
%if &_PIN_. =  %then %let _PIN_=PIN;
%if &_PINq_.=  %then %let _PINq_=&_PIN_.q;
/* END: Specifying variables for PIN and PINq */

/* START: Print to log */
%put;
%put NOTE: ******************************************************;
%put NOTE: *** Check of personal identity/co-ordination number;
%put NOTE: ***;
%put NOTE: *** Variable for PIN: &_PIN_.;
%put NOTE: *** Variable with check-code for PIN: &_PINq_.;
%put NOTE: ***;
%put NOTE: ******************************************************;
%put;
/* END: Print to log */

length &_PINq_. $1 _TEMPk_ _TEMPslask_ _TEMPsum_ _TEMPfday_ 3;
* format &_PINq_. $PINqFmt.;

if &_PIN_.>'' then do;
if notdigit(&_PIN_.,1)=0 then do;

/* Calculation of the check digit */
_TEMPsum_ = 0;
do _TEMPk_ = 3 to 11 by 1;
  _TEMPslask_ = input(substr(&_PIN_.,_TEMPk_,1),1.) * (mod((_TEMPk_-2),2) + 1);
  if _TEMPslask_ > 9 then do;
    _TEMPsum_ = _TEMPslask_ - 10 * int(_TEMPslask_/10) + _TEMPsum_;
    _TEMPsum_ = _TEMPsum_ + int(_TEMPslask_/10);
  end;
  else do;
    _TEMPsum_ = _TEMPsum_ + _TEMPslask_;
  end;
end;
_TEMPsum_ = _TEMPsum_ - int(_TEMPsum_/10) * 10;
_TEMPsum_ = 10 - _TEMPsum_;
if _TEMPsum_ = 10 then _TEMPsum_ = 0;

/* Classification of personal identity number and co-ordination number */
_TEMPfday_=(input(substr(&_PIN_.,7,2),?? 2.)-60);
if '0010'<=substr(&_PIN_.,9,4)<='9999' and substr(&_PIN_.,12,1)=put(_TEMPsum_,1.) then do;
  if input(put(&_PIN_.,$8.),?? yymmdd8.)>. then &_PINq_.='0'; else
  if 1<=_TEMPfday_<=31 and input(put(&_PIN_.,$6.)||put(_TEMPfday_,Z2.),?? yymmdd8.)>. then &_PINq_.='4'; else 
  &_PINq_.='8'; /* Not formally correct personal identity number or co-ordination number */
end; else &_PINq_.='8';
end; else &_PINq_.='A'; /* Not completely numeric */
end; else &_PINq_.='9'; /* Missing */

drop _TEMPfday_ _TEMPk_ _TEMPslask_ _TEMPsum_;
%mend;

data TestPNI;
length PIN $12;
input PIN;
PNR=PIN;
PersonNr=PIN;
%PINq
%PINq(PIN,PINCheck)
%PINq(PNR)
%PINq(PersonNr)
cards;
196408233234
19640B233234
196408233239
196408323233
191212121212
201212121212
201212211212
197010632391
191212721219
1912X2121212
;
run;
proc print data=TestPNI;
format PINq $PINqFmt.;
run;
