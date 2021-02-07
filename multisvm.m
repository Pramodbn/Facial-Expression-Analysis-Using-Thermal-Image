function [result] = multisvm(TrainingSet,GroupTrain,TestSet)
%Models a given training set with a corresponding group vector and 
%classifies a given test set using an SVM classifier 

u=unique(GroupTrain);
numClasses=length(u);
result = zeros(length(TestSet(1,:)),1);
TestSet(isnan(TestSet))=1;
TrainingSet(isnan(TrainingSet))=1;
%%
disp('Training The Data ....');
model = cell(length(u),1);
for k=1:numClasses
    a=double(GroupTrain==u(k));
    k
%     a(find(a==0))=2;
    model{k} = svmtrain( TrainingSet,a,'kernel_function','rbf','RBF_Sigma', 0.8,'BoxConstraint', 0.3);
end
out=zeros(1,length(GroupTrain))';
%# get probability estimates of test instances using each model
% prob = zeros(numTest,numLabels); 
ss=0;
disp('Testing The Data ....');
for k=1:numClasses
    p = svmclassify(model{k},TestSet);
    x(k)=p(1);
end
%% 

[c,result]=max(x);
end