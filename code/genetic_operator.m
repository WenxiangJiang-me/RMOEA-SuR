function f  = genetic_operator(parent_chromosome,mu,mum,V,phi,func)

was_mutation = 0;
%% Crossover
parent_1 = parent_chromosome(1,:);
parent_2 = parent_chromosome(2,:);
child_1=parent_1(1,1:V);child_2=parent_2(1,1:V);
for j = 1:V
    % SBX (Simulated Binary Crossover)
    % Generate a random number  
    l_limit=phi;u_limit=1-phi;  
    u=rand(1);
    if u<= 0.5
       bq(j) = (2*u)^(1/(mu+1));
    else
       bq(j) = (1/(2*(1 - u)))^(1/(mu+1));
    end
    child_1(j)=0.5*(((1 + bq(j))*parent_1(j)) + (1 - bq(j))*parent_2(j));
    child_2(j)=0.5*(((1 - bq(j))*parent_1(j)) + (1 + bq(j))*parent_2(j));
    if child_1(j) > u_limit
       child_1(j) = u_limit;
    elseif child_1(j) < l_limit
       child_1(j) = l_limit;
    end
    if child_2(j) > u_limit
       child_2(j) = u_limit;
    elseif child_2(j) < l_limit
       child_2(j) = l_limit;
    end
end
child_1=evaluate_objective(child_1,func);
child_2=evaluate_objective(child_2,func);
%% Mutation
if rand(1)<1/V
   parent_3 = round(2*rand(1));
   if parent_3 < 1
      parent_3 = 1;
   end
   child_3 = parent_chromosome(parent_3,1:V);
   for j= 1:V     
       l_limit=phi;u_limit=1-phi;
       r = rand(1);
       if r < 0.5
          delta(j) = (2*r)^(1/(mum+1)) - 1;
       else
          delta(j) = 1 - (2*(1 - r))^(1/(mum+1));
       end
       child_3(j) = child_3(j) + delta(j);
       if child_3(j) > u_limit
          child_3(j) = u_limit;
       elseif child_3(j) < l_limit
          child_3(j) = l_limit;
       end
   end
   child_3=evaluate_objective(child_3,func);
   was_mutation = 1;
end
%% keep all children
child(1,:) = child_1;
child(2,:) = child_2;
if was_mutation
   child(3,:) = child_3;
end
f = child;