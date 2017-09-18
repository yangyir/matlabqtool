clear all; rehash;

cts = DayTradingMiscs;
cts.handle_open_limit(2);
cts

cts2 = cts.getCopy;
cts2

a = AssetOne;

e = Entrust;
e.volume = 2;
e.dealVolume = 1;
e.cancelVolume = 1;
e.offsetFlag = 1;
e.entrustNo = 100;

a.push_pendingEntrust(e);
a.dayTradingMiscs


