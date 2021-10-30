function [R_MPL,R_MTOW,R_max]=Range(MTOW,OEW,MPL,FW,MFW)

    % Parameters

    RF = FW*0.05;
    TF = FW - RF;
    MRF = MFW*0.05;
    MTF = MFW - MRF;

    eta_p = 0.7;
    LD_max = 17;
    C = 0.7/(3600*550)*1/0.3048;

    % Range at MPL
    Wi = MTOW;
    Wf = MTOW - TF;
    R_MPL = (eta_p*LD_max)/C*log(Wi/Wf);

    Wi = MTOW;
    Wf = MTOW - MFW + MRF;
    R_MTOW = (eta_p*LD_max)/C*log(Wi/Wf);

    PL = MPL - (MFW-FW);
    Wi = MTOW - PL;
    Wf = MTOW - MFW - PL;
    R_max = (eta_p*LD_max)/C*log(Wi/Wf);

    % Total weight graph

    x1 = [0; R_MPL; R_MTOW; R_max];
    y1 = [OEW+MPL+RF; MTOW; MTOW; MTOW-PL];

    h = figure(1);
    plot(x1/10^3,y1/10^3)
    grid minor
    ylim([0 25])

    % MTOW
    x2 = [0; R_max];
    y2 = [MTOW; MTOW];

    hold on
    plot(x2/10^3,y2/10^3,'--k')

    %OEW
    x3 = [0; R_max];
    y3 = [OEW; OEW];

    hold on
    plot(x3/10^3,y3/10^3,'-.r')

    %MZFW
    x4 = [0; R_MPL; R_MTOW; R_max];
    y4 = [OEW+MPL;OEW+MPL;OEW+PL;OEW];

    hold on
    plot(x4/10^3,y4/10^3,'--m')

    % MZFW+RF
    x5 = [0; R_MPL; R_MTOW; R_max];
    y5 = [OEW+MPL+RF;OEW+MPL+RF;OEW+PL+RF;OEW];

    hold on
    plot(x5/10^3,y5/10^3,'-.g')

    %RMPL

    x6 = [R_MPL;R_MPL];
    y6 = [0;MTOW];
    hold on
    plot(x6/10^3,y6/10^3,':k')

    %RMTOW

    x7 = [R_MTOW;R_MTOW];
    y7 = [0;MTOW];
    hold on
    plot(x7/10^3,y7/10^3,':k')

    %RMTOW

    x8 = [R_max;R_max];
    y8 = [0;MTOW];
    hold on
    plot(x8/10^3,y8/10^3,':k')

    xlabel('Range (km)','Interpreter','Latex');
    ylabel('Weight (t)','Interpreter','Latex');

    hold off
    
    set(h,'Units','Inches');
    pos = get(h,'Position');
    set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    print(h,'range','-dpdf','-r0')
end