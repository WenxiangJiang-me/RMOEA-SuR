function f=generate_noise(phi,fun,n)
%N=100*n;
if strcmpi(fun,'TP1')||strcmpi(fun,'TP2') || strcmpi(fun,'TP3')|| strcmpi(fun,'TP4')||strcmpi(fun,'TP5')
    for j=1:n
          noise(1,j)=-phi+rand(1)*2*phi; 
    end
end

if strcmpi(fun,'TP6')|| strcmpi(fun,'TP7')
    for j=1:n
        if j==1
          noise(1,j)=-phi+rand(1)*2*phi; 
        else
            noise(1,j)=(-phi+rand(1)*2*phi)*2;
        end
    end
end


if strcmpi(fun,'TP8')
    for j=1:n
        if j==1||j==2
          noise(1,j)=-phi+rand(1)*2*phi; 
        else
            noise(1,j)=(-phi+rand(1)*2*phi)*2;
        end
    end
end

if strcmpi(fun,'TP9')
    for j=1:n
        if j==1
          noise(1,j)=-phi+rand(1)*2*phi; 
        elseif j==2
            noise(1,j)=(-phi+rand(1)*2*phi)*1.15;
        else
            noise(1,j)=(-phi+rand(1)*2*phi)*2;
        end
    end
end
f= noise;
