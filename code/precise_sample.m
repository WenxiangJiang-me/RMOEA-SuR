function f  = precise_sample(chromosome,n,phi,func)
[pop, variables] = size(chromosome);
rowrank = randperm(pop);
chromosome_shuffle= chromosome(rowrank,:); 
for j=1:n
      c(1,j)=0.1*(-phi+rand(1)*2*phi); % noise
end
for i=1:2:pop
    if i~=pop
        if chromosome_shuffle(i,n+1)+chromosome_shuffle(i,n+2)<chromosome_shuffle(i+1,n+1)+chromosome_shuffle(i+1,n+2)
            head=i;
        else
            head=i+1;
        end

   f1=chromosome_shuffle( head,1:n)+c(1,1:n);
   f2=chromosome_shuffle( head,1:n)-c(1,1:n);
   ob1(1,:)=evaluate_objective(f1,func);
   ob2(1,:)=evaluate_objective(f2,func);
   chromosome_shuffle( head,n+1)=(chromosome_shuffle( head,n+1)+ob1( 1,n+1)+ob2( 1,n+1))/3;
   chromosome_shuffle( head,n+2)=(chromosome_shuffle( head,n+2)+ob1( 1,n+2)+ob2( 1,n+2))/3;
    end
end
    f=chromosome_shuffle;