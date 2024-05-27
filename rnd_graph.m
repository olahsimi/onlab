clear
close all


ember_num = 300; %hány 'embert' (pontot) akarunk megjeleníteni
meret = 100; %vizsgalt terulet merete
Px = zeros(1,ember_num);
Py = zeros(1,ember_num);
fert_tav = 10;%ilyen távolságon belül fertőződnek az emberek
elek = [];
 
%'emberek' koordinátáit legeneráljuk
for j = 1: ember_num
    x1 = round(rand(1)*meret);
    y1 = round(rand(1)*meret);
    Px(1,j) = x1;
    Py(1,j) = y1;
end

% kiplotolom az embereket
plot(Px, Py, '.');
xlim([-1,meret+1]);
ylim([-1,meret+1]);
hold on
%kuszobertek alatti tavolsagok meghatarozasa, es eleg kozel levo pontok
%osszekotese
for k = 1:ember_num
    for  l =k:ember_num
    % pontok kozotti tavolsagot kiszamolom
    dist = sqrt((Px(k)-Px(l))^2+(Py(k)-Py(l))^2);
        if dist<fert_tav && k~=l
        % a megfelelo vonalak kirajzolasa
        elek = [elek; k l];
        
       
        plot([Px(k),Px(l)], [Py(k),Py(l)], '-','Color','r');


        end
    end
end



