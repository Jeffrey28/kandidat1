function task = gen_task2(a,v,s,entryangle,exitangle,random) 
task=struct;                        % we keep all data here
task.ds=1;                          %[m] sampling interval
%max_s = 110;
max_s = 220;
task.s=[0:task.ds:max_s]';            %[m] vector of traversed distance
task.Ns=numel(task.s);
task.Nv=length(entryangle);                          % number of vehicles
task.I=intersection;

task.V(1:task.Nv)=standardcar;
%rng(0,'twister');

% loop on al possible permutations of crossing orders. Note that Yalmip is not
% meant to be called iteratively, so you may want to replace it with
% another algorithm that is better suited for this purpose. 
task.loopcrossorder=false; 
crossingorder=[1:task.Nv]'; % prototype of "first come first served"
randomentryangleadd = randi([0 3],1,task.Nv)'*pi/2;
if(random)
for i=1:task.Nv
    task.V(i).entryangle=randomentryangleadd(i);
    task.V(i).exitangle=randsample(setdiff(0:3, randomentryangleadd(i)/(pi/2)), 1)'*pi/2;
end
else
%     for i=1:task.Nv/2
%         task.V(2*i).entryangle=0;       
%         task.V(2*i).exitangle=pi;
%  
%         task.V(2*i-1).entryangle=pi/2;
%         task.V(2*i-1).exitangle=3/2*pi;
%     end
    for i=1:task.Nv
        task.V(i).entryangle=entryangle(i);
        task.V(i).exitangle=exitangle(i);
    end
end
ss = []; 
j=150; %distance to center of intersection
task.I.criticalzone;
%vref hardcoded to 50 for all vehicles TODO
vref = ones(task.Nv)*50; %[m/s] reference speed for the vehicles (the first task.Nv elements are used)
for i = 1:task.Nv

    ss(i) = j-s(i)-task.I.criticalzone/2; %[m] distance at which the vehicle enters the critical zone
    se(i)=ss(i)+task.I.criticalzone;
end
%entryangle = entryangle + randomentryangleadd; %+ randomentryangleadd;
          %[m] distance at which the vehicle exits the critical zone
%exitangle=mod(entryangle - pi/2,2*pi);  % + (random half integer) * pi mod 2 pi 
%exitangle = entryangle;

for j=1:task.Nv
    %task.V(j).s=task.s; % (initial) distance for vehicle j
    task.V(j).ss=ss(j); % distance at which vehicle j enters (starts) the critical zone
    task.V(j).se=se(j); % distance at which vehicle j exits the critical zone
    task.V(j).vstart=v(j);
    task.V(j).astart=a(j);
    % disp(randomentryangleadd(j))
    %task.V(j).entryangle=randomentryangleadd(j); % entry angle for vehicle j
    %task.V(j).exitangle=randomturnangle(j); % exit angle for vehicle j
    task.V(j).vref=vref(j)*ones(task.Ns,1);  % reference speed for vehicle j
end
%se �ver denna delen f�r att kunna best�mma crossing order
if task.loopcrossorder
    task.crossorderperm=perms(1:task.Nv);
else
    task.crossorderperm=crossingorder(1:task.Nv)';
end




% Initialise data

%% Critical zone
for j=1:task.Nv
    task.V(j).Nzs=find(task.s <= task.V(j).ss,1,'last');    % number of samples until the vehicle enters the critical zone
    task.V(j).Nze=find(task.s >= task.V(j).se,1,'first');   % number of samples until the vehicle leaves the critical zone
    task.V(j).vrmean=mean(task.V(j).vref);                  % mean reference speed
end

%% Scaling factors
vrmean=mean([task.V.vrmean]);
task.St=task.Ns*task.ds/vrmean; 
task.Sz=1./vrmean; 
task.Sdz=mean(-[task.V.axmin]./[task.V.vrmean].^3);
task.Sddz=50/vrmean^5;
task.Scost=3*vrmean; 

%% Penalties
task.Wv=1; task.Wdv=1; task.Wddv=0.5;


end