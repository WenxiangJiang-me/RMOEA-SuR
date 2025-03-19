function [t,ave]=knee_selection(fd,N,M,n,z)

x=fd(:,(n+1):(n+M));
K=20;

%% Construct all direction vectors
pv=zeros(N,M+3);
for i=1:N
    pv(i,1:M)=x(i,1:M)-z(1,:);%/(z(2,:)-z(1,:));%%
    %Calculation of norm for each vector
    sum1=0;sum2=0;
    for j=1:M
         sum1=sum1+(pv(i,j))^2;
         sum2=sum2+pv(i,j);
    end
    pv(i,M+1)=sum1^0.5;
    pv(i,M+2)=i;
    pv(i,M+3)=sum2;
end
%% Calculate the angle between each pair of direction vectors
r=[]; %r:angle
cc=zeros(N,N);
for i=1:(N-1)
    c=0;d=[];
    for j=(i+1):N
        cc(i,j)=acos(pv(i,1:M)*(pv(j,1:M)')/pv(i,M+1)/pv(j,M+1))/pi*180;
        c=c+1;
        d(c,1)=cc(i,j);d(c,2)=i;d(c,3)=j;
        cc(j,i)=cc(i,j);
    end
    r=[r;d];
end
%% Each time, remove all pairs containg the point with the shortest distance to others
[s2,temp]=size(r); 
N1=N;
y=zeros(N,1);
[a1,a2]=sort(r(:,1));
t=1;
while N1>K
     if t>s2
         break;
     end
     while (y(r(a2(t,1),2),1)==1 || y(r(a2(t,1),3),1)==1)
         t=t+1;
     end
     if pv(r(a2(t,1),2),M+3)-pv(r(a2(t,1),3),M+3)<-0   % Two individuals with the closest angle
        b=r(a2(t,1),3);
     elseif pv(r(a2(t,1),2),M+3)-pv(r(a2(t,1),3),M+3)>0
        b=r(a2(t,1),2);
     else
        e=round(2+rand(1));
        b=r(a2(t,1),e);
     end 
     N1=N1-1;
     y(b,1)=1;  %Solution b is eliminated
     t=t+1;
end
kb=[];k1=0;
for i=1:N
    if y(i,1)==0
        if fd(pv(i,M+2),M+n+1)==1 %only non-dominated solutions are selected
           k1=k1+1;
           kb(k1,1:M+n)=fd(pv(i,M+2),1:M+n);
           kb(k1,M+n+1)=pv(i,M+3);%best perofrmance
           kb(k1,M+n+2)=pv(i,M+3);%accumulated performance
        end
    end
end
ave=max(kb(:,M+n+2));t=kb;
%[t,ave]=find_all(kb,cc,fd,M,n);
