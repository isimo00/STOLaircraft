function [MTOWv,OEWv,FW] = weights(PL,FWr)
    syms('MTOW','positive');
    syms('OEWr','positive');
    a = -8.2e-7;
    b = 0.65;

    [MTOW_v, OEWr_v]=solve([MTOW==PL/(1-FWr-OEWr),OEWr==a*MTOW+b],[MTOW,OEWr]);

    MTOWv = double(MTOW_v);
    OEWrv = double(OEWr_v);
    FW = FWr*MTOWv;
    OEWv = OEWrv*MTOWv;
    
end
