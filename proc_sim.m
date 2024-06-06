clear
close all
%gráfhoz szükséges paraméterek
nV=30; %csúcsok száma
NE= nV*(nV-1)/2; %maximális behúzható élek száma
nE = ceil(NE/4); %reprezentálni kívánt élek száma, tetszőlegesen választható, 
%nE =round(rand*NE); %ha az élek számát is randomizálni szeretnénk
%gráf megjelenítése
[G,A]=randgraf(nV, nE,NE);
h=plot(G,'Layout','circle');

title(sprintf('t = %.2f', 0));
nodeColors = repmat([0 0 1], numnodes(G), 1); %csúcsok színének tetszőleges beállítása: S:kék, I:piros, r:zöld
h.NodeColor = nodeColors;
pause(1);

%hawkes paraméterei
c = 50; %hány eseményig nézzük
lam = 1; %exp. eloszlás lambda paramétere
mu = 1/lam;
tau = 8; %fertőzési idő
T_k = cumsum(exprnd(mu,1,c)); %események bekövetkezésének ideje
simnum=ceil(T_k(end)); %szimulációs idő meghatározása
allapot = zeros(2,nV); %első sor: 0-S, 1-I, 2-R; második sor megfertőződés ideje

%ha adott valószínűség szerint akarjuk a kezdetben fertőzötteket generálni
%kezd_fert = 0.1;
%kezd = rand(size(allapot)); %kezdeti fertozes kiszamitasa
%fert = find(kezd <= kezd_fert); 
%allapot(fert) = 1; %kezdeti fertozottek allapotanak beallitasa
%disp(allapot)

%kezdeti fertőzöttek fix-számú kiválasztása
fert = randperm(nV,2);
allapot(1,fert)=1;
%disp(allapot);

%kezdeti fertőzöttek átszínezése
for i = 1:length(fert)
             nodeColors(fert(i), :) = [1 0 0];
end
              h.NodeColor = nodeColors;
waitforbuttonpress;



a=0;
j=1;
% if sum(allapot(1,:)~=0 %akkor kell csak ha véletlen generáljuk a kezdeti
% fertőzötteket
for t = 0:0.01:simnum %t-vel végmegyek a szimulációs időn
    title(sprintf('t = %.2f', t));
    %for j=1+a:length(T_k) %j-vel pedig a az összes T_k-n
         if j<=length(T_k) && t>T_k(j)
            fokszam = deg(A); %csúcsok fokszámának kiszámolása
            index = find(fokszam~=0); %nem 0 fokszámú csúcsok meghatározása
        
            szomszedok=keres(A, index, allapot); %fertőzött ágensekkel szomszédos csúcsok megkeresése
            a=a+1;
        
            %if sum(allapot)~=0
            allapot = kioszt(allapot,szomszedok,T_k,j); %annak kiválasztása, hogy melyik potencionális csúcs fertőződjön meg
            %end
           
            fert1= find(allapot(1,:)==1);
            %disp(fert1)
           
           for i = 1:length(fert1)
             nodeColors(fert1(i), :) = [1 0 0];
             if allapot(2,fert1(i)) + tau <t %annak a vizsgálata, hogy melyik csúcs kerül R állapotba
                    nodeColors(fert1(i), :) = [0 1 0];
                    allapot(1,fert1(i)) = 2;
             end
           end
            
              h.NodeColor = nodeColors;
               j=j+1;
                %pause(0.1);
                waitforbuttonpress
         end   
         
   % end  
    
end


% end
function [allapot] = kioszt(allapot,szomszedok,T_k,j)
    hatarok=sort(rand(1,length(szomszedok)-1));
    hatarok = [0,hatarok,1];
    intervals = cell(1, length(hatarok)-1);
    for i = 1:length(hatarok)-1
    intervals{i} = [hatarok(i), hatarok(i+1)];
    end
random_number = rand;
    for i = 1:length(hatarok)-1
        if random_number >= intervals{i}(1) && random_number <= intervals{i}(2) && ~isempty(szomszedok)
           % disp(i);%ha meg akarjuk nézni melyik csúcshoz lett kiosztva
            allapot(1,szomszedok(i))=1;
            allapot(2,szomszedok(i)) = T_k(j);
        break;

        end
    end
    %fert=find(allapot(1,:)==1);
   % display(fert)
end

function [szomszedok] = keres(A,index, allapot)
szomszedok=[];
fert= find(allapot(1,:)==1);
     for k=1:length(index)
         for l =1:length(fert)
             if  A(index(k),fert(l)) ==1 && allapot(1,index(k))~=2                    
            szomszedok=[szomszedok,index(k)];
             end
         end
     end
     %display(fert);
end


function [G,A] = randgraf(nV, nE,NE) %gráf rajzoló függvény
    idx = randperm(NE,nE);
    d = ceil(idx/nV);
    i = mod(idx-1,nV)+1;
    j = mod(idx+d-1,nV)+1;
    A = full(sparse(i,j,idx*0+1,nV,nV));
    A = A + A';
    G = graph(A);
end

function [fokszam] = deg(A) %fokszám számító függvény
    fokszam = sum(A);       %erre van a matlabnak beépített függvénye is
end