function f = initialize_variables(N,n,func,phi)
fun=func2str(func);%or functions(func).function
for i=1:N
    % Initialize each decision variable
    f1=zeros(1,n);
    if strcmpi(fun,'TP1')||strcmpi(fun,'TP2') || strcmpi(fun,'TP3')|| strcmpi(fun,'TP4')||strcmpi(fun,'TP5')
        for j=1:n
            %f1(1,j)=phi+(1-phi*2)*rand(1); %[phi,1-phi] from [0,1]
            f1(1,j)=phi+(1-phi*2)*rand();
        end
    end
    if strcmpi(fun,'TP6')|| strcmpi(fun,'TP7')
        f1(1,1)=phi+(1-phi*2)*rand();
        for j=2:n
            f1(1,j)= -1+2*phi+(2- phi*4)*rand();
        end
    end
%         f1(1,1)=rand();
%         for j=2:n
%             f1(1,j)= 2*rand () - 1;
%         end
%     end
        
        if strcmpi(fun,'TP8')
        f1(1,1)=phi+(1-phi*2)*rand();
        f1(1,2)=phi+(1-phi*2)*rand();
        for j=3:n
            f1(1,j)= -1+2*phi+(2- phi*4)*rand();
        end
    end
     if strcmpi(fun,'TP9')
        f1(1,1)=phi+(1-phi*2)*rand();
        f(1,2)= -0.15+2*phi+(1.15- phi*4)*rand();
        for j=3:n
            f1(1,j)= -1+2*phi+(2- phi*4)*rand();
        end
    end
    % Evaluate the objective function
    f(i,:) = evaluate_objective(f1,func);
end
end

    
