function f=update_ak1(c,ak,n,M,ii,z,func)
f=[];
[s1,s2]=size(ak);
tk=[];
%% Evaluate objective value of solutions in archive under the disturbance ak:origin tk:current generation
if ii>1
    for i=1:s1
        t1=ak(i,1:n)+c(1,:);
        tk(i,:)=evaluate_objective(t1,func);
        tk(i,(n+1):(n+M))=tk(i,(n+1):(n+M))-z;
    end
%% Eliminate solutions
    x = non_domination_sort_mod1(tk(:,1:M+n), M, n); % Select solutions on the first pareto front
    for i=1:s1
       if x(i,1)<=1
          temp1=cumsum(tk(i,(n+1):(n+M)));
          temp2=temp1(1,end);
          if ak(i,M+n+1)>(temp2+z(1,1)+z(1,2))
              ak(i,M+n+1)=temp2+z(1,1)+z(1,2);
          end 
          ak(i,M+n+2)=ak(i,M+n+2)+temp2+z(1,1)+z(1,2); %%accumulate value
          ak(i,M+n+4)=ak(i,M+n+4)+tk(i,n+1)+z(1,1);
          ak(i,M+n+5)=ak(i,M+n+5)+tk(i,n+2)+z(1,2);
          ak(i,M+n+6)=ak(i,M+n+6)+1;      
       end
    end
    for i=1:s1
        ak(i,M+n+7)=ak(i,M+n+6)/(ii- ak(i,M+n+3)+1);          
        if ak(i,M+n+7)>=0.5
            f=[f;ak(i,:)]; 
        end
    end
else
     for i=1:s1
        ak(i,M+n+6)=ak(i,M+n+6)+1;
     end
     f=[f;ak];
end
