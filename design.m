function [SSs,PPp]=design(MTOW,ar)

    h = figure(2);
    
    %% INPUT DATA
    vs=37*3.2808; %ft/s
    vmax=140*3.2808; %ft/s 
    vto=1.25*vs; %ft/s
    roc=1000/60; %ft/s
    roc_c=100/60; %ft/s
    s_to=700*3.2808; %TO distance
    clmax=5; 
    cl_c=0.3; 
    rho_0=0.002378; %SL slug/ft^3
    rho_to = 0.002378; %SL slug/ft^3
    rho_alt=0.001267; %20.000ft slug/ft^3
    rho_roc=0.002378; %SL slug/ft^3
    rho_c = 0.001187; %23.000ft slug/ft^3
    rendiment=0.83;
    rendiment_to=0.6;
    rendiment_c=0.7;
    e=0.85;
    k=1/(pi*e*ar);
    cd0=0.02; 
    mu=0.05;
    m=MTOW*2.2046; %lb
    eficiencia_max=17;
    
    %% First graph - Stall speed
    w_s1=0.5*rho_0*vs^2*clmax;

    %% Second graph - Maximum speed
    sigma=rho_alt/rho_0;
    w_s2=[3:1:90];
    w_p2=rendiment*550./((0.5*rho_0*vmax^3*cd0./w_s2)+(2*k/(rho_alt*sigma*vmax).*w_s2));

    %% Third graph - TO
    cd0lg=0.009; 
    cd0hld=0.005; 
    cd0to=cd0+cd0lg+cd0hld; 
    clflap=0.6; 
    clto=cl_c+clflap;
    cdto=cd0to+k*clto^2;
    cdg=cdto-mu*clto;
    clr = clmax/(1.2)^2;
    w_s3=[3:1:90];
    w_p3=(1-exp(0.6*rho_to*32.2*cdg*s_to*(1./w_s3)))./(mu-((mu+(cdg/clr))*(exp(0.6*rho_to*cdg*32.2*s_to*(1./w_s3))))).*(rendiment_to/vto)*550;


    %% Fourth graph - ROC

    w_p4=1*550./((roc/rendiment_c)+sqrt(2./(rho_roc*sqrt(3*cd0/k)).*w_s3).*(1.155/(eficiencia_max*rendiment_c)));

    %% Fifth graph - Ceiling
    sigma_c=rho_c/rho_0;
    w_p5=sigma_c*550./((roc_c/rendiment)+sqrt(2./(rho_c*sqrt(3*cd0/k)).*w_s3)*1.155/(eficiencia_max*rendiment));
    
    figure(2)
    hold on;
    plot(w_s3,w_p4,'--');
    plot(w_s3,w_p3,'-.');
    plot(w_s3,w_p5);
    plot(w_s2,w_p2,'-.');
    xline(w_s1);
    legend('ROC','TO','Ceiling','Maximum Speed','Stall','Location','Northeast');
    grid minor
    hold off;
    xlim([0 90])
    ylim([0 20])
    xlabel('$W/S (lb/ft^2)$','Interpreter','Latex')
    ylabel('$W/P\; (lb/hp)$','Interpreter','Latex')

    %% Solve system (for max and stall)
    WS=w_s1;
    WP=rendiment*550./((0.5*rho_0*vmax^3*cd0./WS)+(2*k/(rho_alt*sigma*vmax).*WS));
    S = m/WS*0.09290304;
    P = m/WP*0.745699872;

    disp('Max & Stall speed intersection')
    fprintf('S = %s [m^2]',S);
    disp('-')
    fprintf('P = %s [kW]',P);
    disp('-')

    %% Solve system (for max and ceiling)
    syms('WPP','positive');
    syms('WSS','positive');
    eq1 = rendiment*550/((0.5*rho_0*vmax^3*cd0/WSS)+(2*k/(rho_alt*sigma*vmax)*WSS));
    eq2 = sigma_c*550/((roc_c/rendiment)+sqrt(2/(rho_c*sqrt(3*cd0/k))*WSS)*1.155/(eficiencia_max*rendiment));
    WSs = solve(eq1==eq2, WSS);
    Wss = double(WSs(1,1));
    Wpp = rendiment*550/((0.5*rho_0*vmax^3*cd0/Wss)+(2*k/(rho_alt*sigma*vmax)*Wss));
    Ss = m/Wss*0.09290304;
    Pp = m/Wpp*0.745699872;
    disp('Max & ceiling intersection')
    fprintf('S = %s [m^2]',Ss);
    disp('-')
    fprintf('P = %s [kW]',Pp);

    %% Solve system (for max and TO)
    syms('wp','positive');
    syms('ws','positive');
    eq1 = rendiment*550/((0.5*rho_0*vmax^3*cd0/ws)+(2*k/(rho_alt*sigma*vmax)*ws));
    eq2 = (1-exp(0.6*rho_to*32.2*cdg*s_to*(1/ws)))/(mu-((mu+(cdg/clr))*(exp(0.6*rho_to*cdg*32.2*s_to*(1/ws)))))*(rendiment_to/vto)*550;
    WSs = solve(eq1==eq2, ws);
    Wss = double(WSs(1,1));
    Wpp = rendiment*550/((0.5*rho_0*vmax^3*cd0/Wss)+(2*k/(rho_alt*sigma*vmax)*Wss));
    SSs = m/Wss*0.09290304;
    PPp = m/Wpp*0.745699872;
    disp('max & TO intersection')
    fprintf('S = %s [m^2]',SSs);
    disp('-')
    fprintf('P = %s [kW]',PPp);
    set(h,'Units','Inches');
    pos = get(h,'Position');
    set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    print(h,'design','-dpdf','-r0')

end