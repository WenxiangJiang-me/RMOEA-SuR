function f  = cluster_chromosome(chromosome,cluster,M,n,N)
    rowrank = randperm(size(chromosome, 1));
    chromosome_shuffle= chromosome(rowrank,:); 
    number=size(chromosome_shuffle,1);
%  N:分组数
    a=floor(number/cluster);%能正好分组
    f_select=[];
    for k=1:cluster
        intermediate_chromosome=chromosome_shuffle((k-1)*a+1:k*a,:);
        f_select1=replace_chromosome(intermediate_chromosome, M, n, N/cluster);
        f_select=[f_select;f_select1];
    end
    f=f_select;