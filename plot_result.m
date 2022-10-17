clear all
clc


a = trainingStats.AverageReward  ;
size = length(a);
 plot(1:2:6595,a(1:1:250,:));
 scatter( 1:1:size,a2);
a2 = a+2; 
size = size -1 ;

av = [];

for i = 1:1:6595
    avarage_val = (a(i,:)+a(i+1,:))/2;
    av = [av;avarage_val];
end

av2 = [];

for i = 1:1:3297
    avarage_val2 =  (av(i,:)+a(i+1,:))/2;
    av2 = [av2;avarage_val2];
end

av3 = [];

for i = 1:1:1648
    avarage_val3 =  (av2(i,:)+a(i+1,:))/2;
    av3 = [av3;avarage_val3];
end
plot(1:1:1648,av3);
plot(1:1:6304,a);

plot(1:1:6000,av2);
hold on
plot(1:8:13184,av3);


