%macro DateNum(_InVar_,_OutVar_); * / store source des="%DateNum(<<Alphanumeric date (YYYYMMDD)>>,<<Variable for new SAS-date>>)";
length &_OutVar_. 4;
format &_OutVar_. yymmdd10.;

_TEMPDATE_=put(&_InVar_.,$8.);
if '1800'<put(_TEMPDATE_,$4.)<'2050' then do;
  if length(_TEMPDATE_)=8 then &_OutVar_.=input(_TEMPDATE_,?? yymmdd8.);
  if &_OutVar_.=. then do;
    if substr(&_InVar_.,5,2) in ('04','06','09','11') and substr(&_InVar_.,7,2)='31' then _TEMPDATE_ = put(&_InVar_.,$6.)||'30'; else
    if substr(&_InVar_.,5,2)='02' and substr(&_InVar_.,7,2) in ('29', '30', '31') then _TEMPDATE_ = put(&_InVar_.,$6.)||'28'; else
    if '01'<=substr(&_InVar_.,5,2)<='12' then _TEMPDATE_=put(&_InVar_.,$6.)||'15'; else _TEMPDATE_ = put(&_InVar_.,$4.)||'0702';
    &_OutVar_.=input(_TEMPDATE_,?? yymmdd8.);
  end;
end;
drop _TEMPDATE_;
%mend;

data TestDate;
length AlphaDate $8;
input AlphaDate;
%DateNum(AlphaDate,SASdate)
cards;
19500101
19600431
19700229
19800229
199010zz
2000zzzz
210Ozzzz
;
run;
proc print data=TestDate;
run;
