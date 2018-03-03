%plot bowl sape incline

pm006Flat=[0	-0.0167;2.045053	-0.0006;-0.61596	-0.0043;7.619756	-0.0941;-4.75736	0.0598];% do not use second row
pm006Incline=[0	-0.0109;-2.84916	-0.0076;0.490772	-0.1011;1.335123	0.0529];

pm005Flat=[0	-0.089;-8.47305	-0.0638;1.073484	-0.0232;1.372527	-0.1891;10.23697	-0.0154];
pm005Incline=[0	-0.0824; 7.848295	-0.0204;-10.0819	-0.1536;-6.01336	-0.0163];

figure
subplot 221
plot(pm006Flat([1;3;4;5],2),pm006Flat([1; 3; 4; 5],1),'ok')
title('PM006Flat')



subplot 222
plot(pm006Incline(:,2),pm006Incline(:,1),'ok')
title('PM006Incline')

subplot 223
plot(pm005Flat([1;3;4;5],2),pm005Flat([1; 3; 4; 5],1),'ok')
title('PM005Flat')
xlabel('SLA');ylabel('metabolic cost')


subplot 224
plot(pm005Incline(:,2),pm005Incline(:,1),'ok')
title('PM005Incline')