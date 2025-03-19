function [lf,y]=archive_updating(w,q,n)

[N1,M]=size(w);
for i=1:N1
    t1(i,1)=norm(w(i,:));
end
[N,S]=size(q);
lf=cell(N1,1);
for i=1:N
    t2(i,1)=norm(q(i,n+1:n+M));
end

lff=[];
for i=1:N
    t=[];
    for j=1:N1
        t(j,1)=acos(q(i,n+1:n+M)*w(j,:)'/t1(j,1)/t2(i,1));
    end 
    [y1,y2]=min(t(:,1)); % Associate solution with vector
    q(i,S-2)=i;
    lf{y2,1}=[lf{y2,1};q(i,:)];
    y(i,:)=t';
end
