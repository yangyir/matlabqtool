clear;
clc;
%% Configurate and initialize
% splitMark is the mark to slice the tick array
% splitMark = MMSS
% MM, length of the slice in minutes
% SS, slice boundary in seconds, millisecond is rounded to seconds. 
% for example:
% splitMark = 0110, 1min slice, from every 10s to next 9s.
splitMark = 0100;

% markList contains all the split marks.
markList = genSliceMarkList(splitMark);
numMark = length(markList);

%define a global quote container
maxNumTick = 32410 ;
%tickInfo is a struct including information that stay unchanged throughout
%the day.
%1,contract code; 2,pre square; 3,upLimit; 4,downLimit; 5,pre close day;
%6,pre open interest; 7,exchange type

% tickInfo;
% 1,time; 2,close; 3,high; 4,low; 5,volume; 6,amount;
% 7,openInterest; 8,delta;
tickArr = zeros(maxNumTick,8);

sliceType = 'M';
switch sliceType
    case 'M'
        sliceQuote = zeros(numMark,9);
    case 'B'
        sliceQuote = initBars(numMark);
end

% tick count;
numTick = 1;
% slice index
sliceInd = 1;
%
exitTime = 151501;
%% creat tcp/ip object
% free the port, if occupied
u=instrfindall;
if ~isempty(u)
    delete(u)
end
% create port
ipA='10.41.17.90';
portA=7861;
portB=7861;
rPort=udp(ipA,portA,'LocalPort',portB);
set(rPort,'TimeOut',inf);
set(rPort,'InputBufferSize',1024);
fopen(rPort);
%%
while 1
    if rPort.BytesAvailable>0
        % fread takes about 1.5ms
        buff = fread(rPort,rPort.BytesAvailable);
        % unit8 and rslvPack together take less than 0.2ms
        buff = uint8(buff);
        currTick = rslvBMktInfo(buff)
        
        % save tick info to workspace
        myclock=clock;
        tickArr(numTick,1) = floor(myclock(4)*10000000+myclock(5)*100000+myclock(6)*1000);
        tickArr(numTick,2) = currTick.last;
        tickArr(numTick,3) = currTick.high;
        tickArr(numTick,4) = currTick.low;
        tickArr(numTick,5) = currTick.volume;
        tickArr(numTick,6) = currTick.amount;
        tickArr(numTick,7) = currTick.openInterest;
        tickArr(numTick,8) = currTick.delta;
        
        if numTick== 1
            tickInfo.contractCode = currTick.contractCode;
            tickInfo.openDay      = currTick.open;
            tickInfo.preSquare    = currTick.preSquare;
            tickInfo.upLimit      = currTick.upLimit;
            tickInfo.downLimit    = currTick.downLimit;
            tickInfo.preCloseDay  = currTick.preCloseDay;
            tickInfo.preOI        = currTick.preOpenInterest;
            tickInfo.exchType     = currTick.exchType;
            if strcmp(sliceType,'B')
                sliceQuote.code   = currTick.contractCode;
            end
            
            indStartTick = 1;
            numTickInSlice = 0;              
        end
        
        currTime = floor(currTick.tickTime/1000);
        % working within a valid slice
        if sliceInd<numMark
            if currTime>=markList(sliceInd)&&currTime<markList(sliceInd+1)
                numTickInSlice = numTickInSlice+1;
            elseif currTime>=markList(sliceInd+1)
                % pack the completed slice;
                if numTickInSlice>0
                    sliceQuote = packBar(tickArr,indStartTick,numTickInSlice,sliceQuote,sliceInd);
                    % sliceInd
                    % feed strategy with data
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    % 
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                end
                
                sliceInd = sliceInd+1;
                while(sliceInd<numMark&&currTime>=markList(sliceInd+1))
                    sliceInd = sliceInd+1;
                end
                
                indStartTick = numTick;
                numTickInSlice = 1;
            end
        end
                
        numTick=numTick+1;
        if currTime>exitTime
            break;
        end

    end % if real time quote available   
end % while 1

fclose(rPort);
delete(rPort);