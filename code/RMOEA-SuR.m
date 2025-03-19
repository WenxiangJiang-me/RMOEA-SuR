function f=RMOEA-SuR(funname,experiment_num)
%Some of the code for this project references MOEA-RE ("https://github.com/ZhenanHe/MOEA-with-robustness-enhancement-MOEA-RE").
%% Parameter setting  
clearvars -except funname experiment_num
M = 2;         % NO.Objectives;
n = 10;        % NO.Decision variables
N = 10*n;       % The size of initial population
func =  eval(['@TP',num2str(funname)]);  % Evaluate_function    
phi = 0.025;   % Disturbance level 
num = 2000;     % The number of generations
mu = 20;       % Distribution index of SBX  
mum = 5;       % Distribution index of polynomial mutation
pool = 2;      % Size of the mating pool in tournament selection
tour = 2;      % No.solutions selected in each comparsion in tournament selection
a1 = 1.1;      % Parameter using in archive updating
cluster=5;
%%Notify: The benchmark problems should be written in a separate document.
%The example of benchmark problems is given in TP1.m, TP2.m, TP3.m, and TP4.m

%% Initialization
fn=initialize_variables(N,n,func,phi);    % Initialize all individual
ak=[];
z=[1000,1000];
fun=['TP',num2str(funname)];
fprintf('test problem: %s, experiment_number: %d\n',fun,experiment_num)
%% Evolution Loop
for ii=1:num
    fd=[];
    for j=1:n
        c(ii,j)=-phi+rand(1)*2*phi; % noise
    end
    %c(ii,:)=generate_noise(phi,fun,n);
    for j=1:N
        f1=fn(j,1:n)+c(ii,1:n); % add disturbance on the variables
        fd(j,:)=evaluate_objective(f1,func); % set objective_value for each variable
    end
    fd=non_domination_sort_mod(fd,M,n); % do non_domination_sort on variables
    cc1=[];
    for i=1:(N/2)
        p1=tournament_selection(fd(:,1:M+n+2), pool, tour); % using tournament_selection for choosing variable
        p=[];
        for i1=1:pool
            p(i1,:)=fd(p1(i1,1),:);%% 1) fn==fd
        end
        % Combination
        offspring_chromosome = genetic_operator(p(:,1:M+n),mu,mum,n,phi,func); %create offspring
        cc1=[cc1;offspring_chromosome(:,1:n)];
    end
    [S1,S2]=size(cc1);
    for j=1:S1
        f1=cc1(j,1:n)+c(ii,1:n);
        cc1(j,1:M+n)=evaluate_objective(f1,func);
    end
    cc=[fd(:,1:M+n);cc1]; % Combine both old population and new population
    sample_chromosome=precise_sample(cc,n,phi,func);
    intermediate_chromosome=non_domination_sort_mod(sample_chromosome, M, n); % do non_domination_sort on the old and new population
    fd=cluster_chromosome(intermediate_chromosome,cluster,M,n,N);

    %fd=replace_chromosome(intermediate_chromosome, M, n, N); % The Pareto front by NSGA-II, and update the fd
    for j=1:N
        fn(j,1:n)=fd(j,1:n)-c(ii,1:n);
    end
    %% Constrcut the ideal point by all individuals
    for i=1:M
        if z(1,i)>min(fd(:,n+i))
           z(1,i)=min(fd(:,n+i)); % z1:ideal point
           if z(1,i)<0
               z(1,i)=0;
           end
        end
    end
    [a,ave]=knee_selection(fd,N,M,n,z); % The knee points by MMD
    [s1,s2]=size(a);
    for j=1:s1
        a(j,1:n)=a(j,1:n)-c(ii,1:n); % delete disturbance on the variables
        a(j,M+n+1)=a(j,M+n+1)+z(1,1)+z(1,2); % add ideal_point_value
        a(j,M+n+2)=a(j,M+n+2)+z(1,1)+z(1,2);
        a(j,M+n+3)=ii; % add the generation for variables
        a(j,M+n+4)=a(j,n+1); % add function evaluate_value on variables
        a(j,M+n+5)=a(j,n+2);
        a(j,M+n+6)=0;
        a(j,M+n+7)=0;
    end
    ak1=[ak;a];
    ak=update_ak1(c(ii,:),ak1,n,M,ii,z,func); % Eliminate worst solutions in archive using non-dominated sorting
    if mod(ii,100)==0
        fprintf('iteration: %d%%%d\n',ii,num)
    end
end
[s1,s2]=size(ak);
final_ak=[];
for i=1:s1
    if ak(i,M+n+6)>=10
        final_ak=[final_ak;ak(i,:)]; 
    end
end
f1=final_solution(final_ak,M,n,num,N); % update the Archive and choose the final solution
[s1,~]=size(f1);
mypof=zeros(s1,n+2);

for j=1:s1 % prevent the number of solutions less than 100, otherwise 1:N
    mypof(j,:)=evaluate_objective(f1(j,1:n),func);
end




%plot(fd(:,6),fd(:,7),'r*');hold on; % show the distribution of variables
%plot(ak(:,6),ak(:,7),'o');

















    