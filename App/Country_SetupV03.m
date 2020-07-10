%% Load data for chosen MyISO
%% MyISO setup V03: 
% this version (09 June 2020)
% 1) Automatically maps locations to MyISO codes

global Dates Cases Smooth Beta_UI Gamma_UI;
global MyISO domain N S_init I_init R_init TotalInfected;
global Country_to_ISO;

Imin = 10; % start clock once there are 10 cases.

if (~isvarname(MyISO))
   MyISO = 'IRL'; % IRL=Ireland, ITA=Italy, DEU=Germany
end

%% Load data from file
CSVdata = readtable('../Data/owid-covid-data.csv');

%% Process ISOs
Country_to_ISO = containers.Map(CSVdata.location, CSVdata.iso_code);
%Country_to_Continent = containers.Map(CSVdata.location, CSVdata.continent);

ISOs=categorical(CSVdata.iso_code);
MyCols=find(ISOs == MyISO); % All with matching MyISO
% get rid of any nans
CSVdata.new_cases( isnan(CSVdata.new_cases))=0;

%% Used to esimate how long someone stays infected
DurationInfected = 14; %% THIS IS MADE Up!
%%

%% Process the data for "MyISO"
Start = find (cumsum(CSVdata.new_cases(MyCols))>=Imin,1); % first non-zero case
MyCols = MyCols(Start:end);
length(MyCols);
Data = table2array(CSVdata(MyCols,5:8));

%% Process dates
DateSerial = datenum(CSVdata.date(MyCols));
Dates = (DateSerial - DateSerial(1));

%% Process Cases (i.e., positive test reported on a given day)
NewDailyCases = CSVdata.new_cases(MyCols);
TotalInfected = cumsum(NewDailyCases);
CurrentInfected = TotalInfected;
CurrentInfected(DurationInfected+1:end) = ...
   TotalInfected(DurationInfected+1:end)-TotalInfected(1:(end-DurationInfected));
Cases = CurrentInfected;
Deaths = CSVdata.new_deaths(MyCols);

%% Do we need to smooth the data? (Probably not)
% Smooth = smoothdata(Cases,'movmean', 7);
Smooth = Cases;

%% Date for ODEs
domain = [Dates(1), Dates(end)];
N = CSVdata.population(MyCols(1)); % Population
S_init = N;
I_init = Cases(1);
R_init = 0;

%% Good guesses for beta and gamma
fprintf("Country (MyISO)=%s\n", MyISO);
if isequal(MyISO, 'IRL')
   Beta_UI  = 2.7;
   Gamma_UI = 2.5;
elseif isequal(MyISO, 'AUT') % Austria
   Beta_UI  = 5.9;
   Gamma_UI = 5.6;
elseif isequal(MyISO, 'BEL') % Belgium
   Beta_UI  = 3.3;
   Gamma_UI = 3.1;
elseif isequal(MyISO, 'DNK') % Belgium
   Beta_UI  = 5.5;
   Gamma_UI = 5.3;
elseif isequal(MyISO, 'ITA')  % Italy
   Beta_UI  = 2.7;
   Gamma_UI = 2.5;
elseif isequal(MyISO, 'AFG') %Afghanistan
   Beta_UI  = 4.67;
   Gamma_UI = 4.56;
elseif isequal(MyISO, 'AUS') % Australia
   Beta_UI  = 8.4;
   Gamma_UI = 8.3;
elseif isequal(MyISO, 'ESP') % Spain
   Beta_UI  = 3.8;
   Gamma_UI = 3.6;
elseif isequal(MyISO, 'FRA') % France
   Beta_UI  = 3.8;
   Gamma_UI = 3.7;
elseif isequal(MyISO, 'GBR') % United Kingdom
   Beta_UI  = 3.2;
   Gamma_UI = 3.0;
elseif isequal(MyISO, 'LVA') % Latvia
   Beta_UI  = 11.6;
   Gamma_UI = 11.4;
elseif isequal(MyISO, 'SVK') % Slovakia
   Beta_UI  = 10.6;
   Gamma_UI = 10.5;
elseif isequal(MyISO, 'CHN') % China
   Beta_UI  = 22;
   Gamma_UI = 21.8;
elseif isequal(MyISO, 'PRT') % Portugal
   Beta_UI  = 4.7;
   Gamma_UI = 4.4;
elseif isequal(MyISO, 'CHE') % Switzerland
   Beta_UI  = 4.1;
   Gamma_UI = 3.9;
elseif isequal(MyISO, 'NOR') % Norway
   Beta_UI  = 5.5;
   Gamma_UI = 5.3;
elseif isequal(MyISO, 'FIN') % Finland
   Beta_UI  = 5.2;
   Gamma_UI = 5.0;
elseif isequal(MyISO, 'BRA') % Brazil
   Beta_UI  = 2.0;
   Gamma_UI = 1.9;
elseif isequal(MyISO, 'MEX') % Mexico
   Beta_UI  = 3.7;
   Gamma_UI = 3.6;
elseif isequal(MyISO, 'POL') % Poland
   Beta_UI  = 5.3;
   Gamma_UI = 5.2;
elseif isequal(MyISO, 'RUS') % Russia
   Beta_UI  = 2.8;
   Gamma_UI = 2.7;
elseif isequal(MyISO, 'ARE') % United Arab Emirates
   Beta_UI  = 2.1;
   Gamma_UI = 1.9;
elseif isequal(MyISO, 'IND') % India
   Beta_UI  = 6.4;
   Gamma_UI = 6.3;
elseif isequal(MyISO, 'PER') % Peru
   Beta_UI  = 1.9;
   Gamma_UI = 1.7;
elseif isequal(MyISO, 'CHL') % Chile
   Beta_UI  = 1.1;
   Gamma_UI = 1.0;
elseif isequal(MyISO, 'IRN') % Iran
   Beta_UI  = 6.1;
   Gamma_UI = 5.9;
elseif isequal(MyISO, 'PAK') % Pakistan
   Beta_UI  = 3.8;
   Gamma_UI = 3.7;
elseif isequal(MyISO, 'ZAF') % South Africa
   Beta_UI  = 2.4;
   Gamma_UI = 2.3;
elseif isequal(MyISO, 'SAU') % Saudi Arabia
   Beta_UI  = 2.0;
   Gamma_UI = 1.9;
else
   Beta_UI  = 2.7;
   Gamma_UI = 2.5;
end   
