function loadGraph()
    graficBodegues();
    graficPax();
end

function graficPax()
    h = figure(4);
    A = xlsread('Pesos.xlsx', 'Centrado','B3:G24');
    
    xcg_buit = A(18,1);
    pes_buit = A(17,1);
    pos_pax_min = A(14,5); % posicio primera fila
    pos_pax_max = A(15,5); % posicio ultima fila
    num_files = 11;
    cada_quan_fila = (pos_pax_max-pos_pax_min)/num_files;

    %% Carreguem finestres per davant
    count = 1;
    xcg = [];
    pes = [];
    pes_pre = pes_buit;
    xcg_pre = xcg_buit;
    pes_afegit = 77 *2;
    for fila = 0:1:10
        pos_afegit = pos_pax_min + cada_quan_fila*fila;
        pes_total = pes_pre + pes_afegit;        
        nou_xcg = ( xcg_pre * pes_pre + pos_afegit * pes_afegit ) / pes_total;
        xcg(count) = nou_xcg;
        pes(count) = pes_total;
        pes_pre = pes_total;
        xcg_pre = nou_xcg;
        count = count + 1;
    end
    xcg = [xcg_buit, [xcg]];
    pes = [pes_buit, [pes]];
    MAC = A(22,4);
    X_ba = A(19,4);
    hold on
    grid minor
    plot((xcg-X_ba)*100/MAC,pes)
    xlabel('$x_{cg}/MAC \%', 'interpreter','latex')
    ylabel('$W \ (kg)$', 'interpreter','latex')

    %% Carreguem finestres per darrere
    count = 1;
    xcg = [];
    pes = [];
    pes_pre = pes_buit;
    xcg_pre = xcg_buit;
    for fila = 10:-1:0
        pos_afegit = pos_pax_min + cada_quan_fila*fila;
        pes_total = pes_pre + pes_afegit;        
        nou_xcg = ( xcg_pre * pes_pre + pos_afegit * pes_afegit ) / pes_total;
        xcg(count) = nou_xcg;
        pes(count) = pes_total;
        pes_pre = pes_total;
        xcg_pre = nou_xcg;
        count = count + 1;
    end
    xcg = [xcg_buit, [xcg]];
    pes = [pes_buit, [pes]];
    plot((xcg-X_ba)*100/MAC,pes)
    pes_pax_fin = pes(num_files+1);
    xcg_pax_fin = xcg(num_files+1);

    %% Carreguem passadis per davant
    count = 1;
    xcg = [];
    pes = [];
    pes_pre = pes_pax_fin;
    xcg_pre = xcg_pax_fin;
    for fila = 0:1:10
        pos_afegit = pos_pax_min + cada_quan_fila*fila;
        pes_total = pes_pre + pes_afegit;        
        nou_xcg = ( xcg_pre * pes_pre + pos_afegit * pes_afegit ) / pes_total;
        xcg(count) = nou_xcg;
        pes(count) = pes_total;
        pes_pre = pes_total;
        xcg_pre = nou_xcg;
        count = count + 1;
    end
    xcg = [xcg_pax_fin, [xcg]];
    pes = [pes_pax_fin, [pes]];
    plot((xcg-X_ba)*100/MAC,pes)

    %% Carreguem passadis per darrere
    count = 1;
    xcg = [];
    pes = [];
    pes_pre = pes_pax_fin;
    xcg_pre = xcg_pax_fin;
    for fila = 10:-1:0
        pos_afegit = pos_pax_min + cada_quan_fila*fila;
        pes_total = pes_pre + pes_afegit;        
        nou_xcg = ( xcg_pre * pes_pre + pos_afegit * pes_afegit ) / pes_total;
        xcg(count) = nou_xcg;
        pes(count) = pes_total;
        pes_pre = pes_total;
        xcg_pre = nou_xcg;
        count = count + 1;
    end
    xcg = [xcg_pax_fin, [xcg]];
    pes = [pes_pax_fin, [pes]];
    plot((xcg-X_ba)*100/MAC,pes)
    legend('Window F-B loading', 'Window B-F loading', ...
        'Corridor F-B loading', 'Corridor B-F loading')
    set(h,'Units','Inches');
    pos = get(h,'Position');
    set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    print(h,'passatgers','-dpdf','-r0')
end

function graficBodegues()
    h = figure(5);
    A = xlsread('Pesos.xlsx', 'Centrado','B3:G24');
    xcg_buit = A(18,1);
    pes_buit = A(17,1);
    avio_buit       = [xcg_buit, pes_buit];
    baggage_davant  = [A(11,5),     A(11,3)];
    baggage_darrere = [A(12,5),    A(12,3)];

    % Carreguem primer la bodega de davant
    bodega_davant = carregarBodega(avio_buit, baggage_davant);
    totcarregat1  = carregarBodega(bodega_davant, baggage_darrere);
    hold on
    fesPlot(avio_buit, bodega_davant, totcarregat1, 'red', 'blue');
    
    % Carreguem primer la bodega de darrere
    bodega_darrere = carregarBodega(avio_buit, baggage_darrere);
    totcarregat2  = carregarBodega(bodega_darrere, baggage_davant);
    fesPlot(avio_buit, bodega_darrere, totcarregat2, 'blue', 'red');
    grid minor
    xlabel('$x_{cg} \ (m)$', 'interpreter','latex')
    ylabel('$W \ (kg)$', 'interpreter','latex')
    legend('Front bag. compartment', 'Back bag. compartment')

    set(h,'Units','Inches');
    pos = get(h,'Position');
    set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    print(h,'bodegues','-dpdf','-r0')
end

function res = carregarBodega(dades_pre, afegim)
    pos_pre = dades_pre(1);
    pes_pre = dades_pre(2);
    pos_bod = afegim(1);
    pes_bod = afegim(2);
    pes = pes_pre + pes_bod;
    pos = (pos_pre*pes_pre + pos_bod * pes_bod)/pes;
    res(1) = pos;
    res(2) = pes;
end

function fesPlot(buit, mig, final, color1, color2)
    vec1 = mig - buit;
    vec2 = final - mig;
    hold on
    q = quiver(buit(1),buit(2),vec1(1),vec1(2),0);
    q.ShowArrowHead = 'off';
    q.Color = color1;
    q = quiver(mig(1),mig(2),vec2(1),vec2(2),0);
    q.ShowArrowHead = 'off';
    q.Color = color2;
    grid minor
end