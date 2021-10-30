function [xCoM_0,xCG] = centering(FW)
    %% Variables constants en vol i temps
    h = figure(3);

    A = xlsread('Pesos.xlsx', 'Centrado','B3:G24');

    % Pesos
    wing = A(1,3);
    tail = A(2,3);
    fuselage = A(3,3);
    landing_gear = A(4,3);
    surface_controls = A(5,3);
    nacelle = A(6,3);
    engine = A(7,3);
    pilots = A(8,3);

    % Posicions
    wing_pos = A(1,5);
    tail_pos = A(2,5);
    fuselage_pos = A(3,5);
    landing_gear_pos = A(4,5);
    surface_controls_pos = A(5,5);
    nacelle_pos = A(6,5);
    engine_pos = A(7,5);
    pilots_pos = A(8,5);

    CMA = A(22,4);
    xba = A(19,4);

    vector_fix = [wing     tail     fuselage     landing_gear     surface_controls     nacelle     engine    pilots;
        wing_pos tail_pos fuselage_pos landing_gear_pos surface_controls_pos nacelle_pos engine_pos pilots_pos];

    %% Variables variables
    % Per vol
    crew_max = A(10,3);
    crew_min = A(10,4);
    crew_pos = A(10,5);

    pl_pas_max = A(13,3); 
    pl_pas_min = A(13,4);
    pl_pas_pos = A(13,5);
    pl_lug_fwd_max = A(11,3);
    pl_lug_fwd_min = A(11,4);
    pl_lug_fwd_pos = A(11,5);
    pl_lug_rear_max = A(12,3); 
    pl_lug_rear_min = A(12,4);
    pl_lug_rear_pos = A(12,5);    

    crew_vect = [crew_max; crew_pos];
    pl_pas_vect = [pl_pas_max; pl_pas_pos];
    pl_lug_fwd_vect = [pl_lug_fwd_max; pl_lug_fwd_pos];
    pl_lug_rear_vect = [pl_lug_rear_max; pl_lug_rear_pos];
    
    
    fuel = FW;
    fuel_pos = A(9,5);

    fuel_vect = [fuel; fuel_pos];

    %% Calculations
    xCoM_0 = compute_xCoM(vector_fix, crew_vect, pl_pas_vect,pl_lug_fwd_vect,pl_lug_rear_vect, fuel_vect);
    xCG = (xCoM_0-xba)/CMA*100;
    
    % MPL
    time = sym('time', 'positive'); 
    mf = 620/3600; 
    fuel = FW - 0.95*time*mf; 
    temps_buidat_s= solve(0 == FW - time*mf,time);
    temps_buidat = double(temps_buidat_s);
    
    A = xlsread('Pesos.xlsx', 'Centrado','B3:G24');
    MAC = A(22,4);
    X_ba = A(19,4);   
    
    legend('-DynamicLegend');
    deltat = temps_buidat/120;
    temps = zeros(120,1);
    xCoM = zeros(120,1);
    
    for i=1:1:round(deltat) % 2 min evaluation
        temps(i) = 120*i;
        fuelv = subs(fuel,time,temps(i));
        fuel_vect = [fuelv; fuel_pos];
        CG = compute_xCoM(vector_fix, crew_vect, pl_pas_vect,pl_lug_fwd_vect,pl_lug_rear_vect, fuel_vect);
        xCoM(i) = (CG-X_ba)*100/MAC;
    end
    
    plot(temps/temps_buidat*100,xCoM)
    
    hold on
    
    crew_vect = [crew_min; crew_pos]; 
    pl_pas_vect = [pl_pas_min; pl_pas_pos];
    pl_lug_fwd_vect = [pl_lug_fwd_min; pl_lug_fwd_pos];
    pl_lug_rear_vect = [pl_lug_rear_min; pl_lug_rear_pos];
    temps = zeros(120,1);
    xCoM = zeros(120,1);
    for i=1:1:round(deltat) %cada 2 min
        temps(i) = 120*i;
        fuelv = subs(fuel,time,temps(i));
        fuel_vect = [fuelv; fuel_pos];
        CG = compute_xCoM(vector_fix, crew_vect, pl_pas_vect,pl_lug_fwd_vect,pl_lug_rear_vect, fuel_vect);
        xCoM(i) = (CG-X_ba)*100/MAC;
    end
    hold on
    plot(temps/temps_buidat*100,xCoM)

    legend('OEW', 'MPL')
    legend show
    grid minor
    xlim([0 100])
    xlabel('Time \%','Interpreter','Latex')
    ylabel('$\frac{x_{cg}}{MAC} \%$','Interpreter','Latex')
    set(h,'Units','Inches');
    pos = get(h,'Position');
    set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    print(h,'time-xcom','-dpdf','-r0')
    
end